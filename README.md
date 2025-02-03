# Linux Tools Installer

This repository contains a Bash script to automate the installation of popular Linux tools for penetration testing, network analysis, and cybersecurity. The script installs a wide range of tools using `apt` and `pip`, ensuring an efficient setup process on Debian-based Linux distributions (such as Ubuntu, Kali Linux, etc.).

## Features

- Installs tools for network scanning, penetration testing, vulnerability assessment, and more.
- Supports Debian-based Linux distributions (e.g., Ubuntu, Kali Linux).
- Automates the installation process to save time and effort.

## Tools Included

### Network Scanning and Analysis
- **nmap**: Network scanning and exploration.
- **ncat**: Networking utility for reading and writing data.
- **ndiff**: Utility for comparing nmap scans.
- **zenmap**: GUI for nmap.
- **wireshark**: Network protocol analyzer.
- **tshark**: Command-line Wireshark.
- **tcpdump**: Packet analyzer.
- **netcat-traditional**: Networking utility for debugging and investigation.
- **ettercap**: Man-in-the-middle attack suite.
- **arpwatch**: Monitors Ethernet activity for address pairing changes.

### Web Application Testing
- **gobuster**: Brute-forces directories/files in web servers.
- **ffuf**: Fast web fuzzer.
- **wpscan**: WordPress security scanner.
- **nikto**: Web server scanner.

### Penetration Testing Frameworks
- **metasploit-framework**: Comprehensive exploitation framework.
- **aircrack-ng**: Wi-Fi security auditing tools.
- **bettercap**: Network attack and monitoring framework.
- **beef-xss**: Browser exploitation framework.

### Vulnerability Analysis
- **hydra**: Password brute-forcer.
- **sqlmap**: Automatic SQL injection tool.
- **rkhunter**: Rootkit detection tool.
- **chkrootkit**: Another rootkit detection tool.
- **lynis**: System auditing and hardening tool.

### Information Gathering
- **theharvester**: Email and subdomain collection.
- **cewl**: Custom wordlist generator.
- **dnsrecon**: DNS enumeration.
- **dnsenum**: Multi-threaded DNS enumeration.
- **amass**: Subdomain enumeration.
- **subfinder**: Subdomain enumeration.

### Password Cracking
- **john (John the Ripper)**: Password cracker.
- **hashcat**: GPU-accelerated password cracking.
- **crunch**: Custom wordlist generator.
- **cewl**: Wordlist generator from web content.

### Exploitation Tools
- **responder**: LLMNR, NBT-NS, and MDNS poisoning.
- **evil-winrm**: WinRM exploitation tool.
- **mimikatz**: Windows credential extraction tool.
- **powershell-empire**: Post-exploitation framework.

### Miscellaneous
- **burpsuite**: Web vulnerability scanner and proxy.
- **yara**: File pattern matching for malware detection.
- **fcrackzip**: ZIP password cracker.
- **ghidra**: Reverse engineering suite.
- **dirbuster**: Directory brute-forcing tool.
- **spiderfoot**: Open-source intelligence automation.
- **masscan**: Internet-wide port scanner.

### Additional Tools
- **recon-ng**: Open-source reconnaissance framework.
- **maltego**: Graphical link analysis for OSINT and forensics.
- **sublist3r**: Subdomain enumeration tool.
- **massdns**: High-performance DNS resolver.
- **dirsearch**: Directory brute-forcing tool.
- **scapy**: Python-based packet manipulation tool.

## Prerequisites

- Debian-based Linux distribution (e.g., Ubuntu, Kali).
- sudo privileges.
- Internet access for downloading packages.

## Installation

1. **Clone the repository**:
   ```bash
   git clone 
   cd directory

    Give the script execution permissions:

chmod +x install.sh

Run the installation script:

    sudo ./install.sh

The script will automatically install the listed tools using apt , ensuring a quick and efficient setup for all the tools mentioned.
Usage

After the installation is complete, you can start using the tools by simply invoking their names in the terminal. For example:

    nmap for network scanning
    gobuster for directory brute-forcing
    metasploit-framework for exploiting vulnerabilities

Refer to the documentation for each individual tool for more details on how to use them.
Contributing

If you'd like to contribute to the project or suggest additional tools, feel free to fork the repository, create a pull request, or open an issue for discussion.
