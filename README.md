## 🛠️ Kali Tools Installer 
Keep your own Linux distro and add all kali linux tools to it.


P.S: Some tools might not be available in certain distro repositories. In such cases, the script will install only those tools that are accessible.

---

## 📝 About

This is a Kali Linux tools installation script that works across multiple distributions. Whether you're hacking, pen-testing, or just pretending to be a wizard at the terminal, this script has your back.

It auto-detects your Linux distro, grabs the appropriate package manager, and installs a truckload of tools for your inner techie.

No magic required (unless you're using Arch, which is basically black magic).

---

## 🎯 Features

    Distro Detective: Automatically figures out your Linux flavor (Ubuntu, Debian, Arch, Fedora, and more).
    Package Manager Whisperer: Talks to apt, pacman, dnf, or yum .
    Tool Heaven: Installs a buffet of tools for:
        🕵️‍♂️ Information gathering
        💥 Exploitation
        🔐 Password cracking
        🌐 Network analysis
        And much more!
    Cleanup Pro: Tidies up unused packages when it's done.

---

## 🛑 Prerequisites

    Be Root, Or Be Gone: Run it as root. Otherwise, the script will sass you and exit.
    Linux Distro: Supported distros include:
        Ubuntu/Debian/Kali
        Arch/Manjaro
        Fedora/CentOS/RHEL/AlmaLinux/Rocky

---

## 🚀 Usage

    Download the script:

git clone https://github.com/Midohajhouj/ToolsInstaller.git

cd ToolsInstaller


chmod +x install.sh

Run the script as root:

    sudo ./install.sh

🧰 Tools Installed
🎛 Essential Dependencies

    build-essential, python3-pip, python3-dev, git, curl, wget

🕵️‍♂️ Information Gathering

    theHarvester, dnsrecon, dnsenum, subfinder

🌐 Network Analysis

    nmap, netcat, Wireshark, tcpdump

🔐 Password Cracking

    john, hashcat, crunch

💥 Exploitation

    metasploit, responder, evil-winrm

…and many more! (Check the script for the full menu.)


📦 Fun Extras

    Auto-installs Metasploit Framework for you if curl is available.
    Built-in sass for unsupported distros.

---
    
## ❗ Disclaimer

Use it responsibly. I am not responsible for any damage, loss of data, or coffee spills resulting from its use. 

---

#### *<p align="center"> Coded by <a href="https://github.com/Midohajhouj">LIONMAD</a> </p>*
