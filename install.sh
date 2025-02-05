#!/bin/bash

# Linux Tools Installation Script

# This script automates the installation of various cybersecurity tools
# on Debian-based Linux distributions (e.g., Ubuntu, Kali Linux).

# Make sure to run the script with sudo privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo to run the script."
  exit 1
fi

# Update and upgrade system packages
echo "[+] Updating system packages..."
apt update && apt upgrade -y

# Install essential dependencies
echo "[+] Installing essential dependencies..."
apt install -y build-essential python3-pip python3-dev git curl wget

# Network Scanning and Analysis Tools
echo "[+] Installing network scanning and analysis tools..."
apt install -y nmap ncat ndiff zenmap wireshark tshark tcpdump netcat-traditional ettercap-common arpwatch

# Web Application Testing Tools
echo "[+] Installing web application testing tools..."
apt install -y gobuster ffuf wpscan nikto

# Penetration Testing Frameworks
echo "[+] Installing penetration testing frameworks..."
apt install -y metasploit-framework aircrack-ng bettercap beef-xss

# Vulnerability Analysis Tools
echo "[+] Installing vulnerability analysis tools..."
apt install -y hydra sqlmap rkhunter chkrootkit lynis

# Information Gathering Tools
echo "[+] Installing information gathering tools..."
apt install -y theharvester cewl dnsrecon dnsenum amass subfinder

# Password Cracking Tools
echo "[+] Installing password cracking tools..."
apt install -y john hashcat crunch

# Exploitation Tools
echo "[+] Installing exploitation tools..."
apt install -y responder evil-winrm mimikatz powershell-empire

# Miscellaneous Tools
echo "[+] Installing miscellaneous tools..."
apt install -y burpsuite yara fcrackzip ghidra dirbuster spiderfoot masscan

# Additional Tools
echo "[+] Installing additional tools..."
apt install -y recon-ng maltego sublist3r massdns dirsearch scapy feroxbuster wfuzz fuzz

# Cleanup unnecessary packages
echo "[+] Cleaning up unnecessary packages..."
apt autoremove -y

# Final message
echo "[+] Installation complete! All tools are installed successfully."
echo "[+] You may want to restart your system for all changes to take effect."
