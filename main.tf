terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = "~> 1.0"

  backend "remote" {
    organization = "ACG-Terraform-Demos-abdus"

    workspaces {
      name = "demo-github-actions"
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id = "a4c81412-9cb9-4d76-aaa7-14f85696678a"
  client_id = "15228083-4afb-4421-9826-ff06d09bfc85"
  client_secret = "b6bf4e95-9788-43c0-a6e1-110273659091"
  tenant_id = "ff1fc9e3-26ae-45ae-a79a-32197c30c04d"
}

resource "random_pet" "sg" {}

resource "azurerm_network_security_group" "web-sg" {
  name                = "${random_pet.sg.id}-sg"
  location            = "East US"
  
  security_rule {
    name                       = "Allow_HTTP_Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "web-ip" {
  name                = "${random_pet.sg.id}-ip"
  location            = "East US"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "web-nic" {
  name                = "${random_pet.sg.id}-nic"
  location            = "East US"

  ip_configuration {
    name                          = "web-ip"
    subnet_id                     = azurerm_subnet.web-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-ip.id
  }
}

resource "azurerm_virtual_machine" "web" {
  name                  = "${random_pet.sg.id}-vm"
  location              = "East US"
  resource_group_name   = "my-resource-group"
  network_interface_ids = [azurerm_network_interface.web-nic.id]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${random_pet.sg.id}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "echo 'Hello, World' | sudo tee /var/www/html/index.html"
    ]

    connection {
      type     = "ssh"
      host     = azurerm_public_ip.web-ip.ip_address
      user     = "adminuser"
      password = "Password1234!"
    }
  }
}

output "web-address" {
  value = "http://${azurerm_public_ip.web-ip.ip_address}:8080"
}
