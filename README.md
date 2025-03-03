
# 🛠️ Kali Tools Installer  

The **Kali Tools Installer** allows you to integrate Kali Linux tools into your existing Linux distribution.  
This script automates the installation of tools for penetration testing, cybersecurity analysis, and more.  

---

## 📝 Overview  

This script enables users to keep their preferred Linux distribution while installing a variety of tools commonly used in Kali Linux. It supports multiple distributions, detects your package manager, and installs the tools seamlessly.  

**Note**: Some tools may not be available in certain distribution repositories. The script will install only the tools accessible in your system's repositories.  

---

## 🎯 Features  

- **Automatic Distribution Detection**: Identifies the Linux distribution and uses the appropriate package manager.  
- **Comprehensive Tool Categories**:  
  - Information gathering  
  - Network analysis  
  - Password cracking  
  - Exploitation tools  
  - And more  
- **Resource Cleanup**: Ensures unused packages are removed after installation.  

---

## 🛑 Prerequisites  

- **Root Access**: The script requires root permissions to execute.  
- **Supported Linux Distributions**:  
  - Ubuntu/Debian/Kali  
  - Arch/Manjaro  
  - Fedora/CentOS/RHEL/AlmaLinux/Rocky  

---

## 🚀 Installation  

1. Clone the repository:  
   ```bash
   git clone https://github.com/Midohajhouj/ToolsInstaller.git
   cd ToolsInstaller
   chmod +x install.sh
   ```
2. Run the script as root:  
   ```bash
   sudo ./install.sh
   ```  

---

## 🧰 Installed Tools  

### 🎛 Core Dependencies  
- build-essential, python3-pip, python3-dev, git, curl, wget  

### 🕵️‍♂️ Information Gathering  
- theHarvester, dnsrecon, dnsenum, subfinder  

### 🌐 Network Analysis  
- nmap, netcat, Wireshark, tcpdump  

### 🔐 Password Cracking  
- john, hashcat, crunch  

### 💥 Exploitation Tools  
- metasploit, responder, evil-winrm  

…and many others! For a complete list, check the script itself.  

---

## ❗ Disclaimer  

This script is intended for legal and ethical use only. The developers are not responsible for any misuse or damage caused by this tool.  

---

#### *Developed by [LIONMAD](https://github.com/Midohajhouj)*  
