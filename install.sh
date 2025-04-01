#!/bin/bash

# =============================================
#   Security Tools Installer - Pro Edition
# =============================================
#   Version: 2.0
#   Author: Security Professional
#   Description: Comprehensive security tools installation script
#   with enhanced UI, logging, and system checks
# =============================================

# --------------------------
#  Configuration
# --------------------------
LOG_FILE="/var/log/security_tools_installer.log"
TEMP_DIR="/tmp/security_installer"
INSTALL_TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create temp directory
mkdir -p "$TEMP_DIR"

# --------------------------
#  Color Definitions
# --------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Enhanced color output
BOLD='\033[1m'
UNDERLINE='\033[4m'

# --------------------------
#  UI Elements
# --------------------------
function print_banner() {
  clear
  echo -e "${CYAN}${BOLD}   SECURITY TOOLS INSTALLER "
  echo -e "    Coded By LIONMAD "
  echo -e "${MAGENTA}   $(date)${NC}\n"
}

function print_section() {
  echo -e "\n${BLUE}${BOLD}${UNDERLINE}$1${NC}\n"
}

function print_status() {
  if [ "$2" == "success" ]; then
    echo -e "  ${GREEN}✓${NC} $1"
  elif [ "$2" == "error" ]; then
    echo -e "  ${RED}✗${NC} $1"
  elif [ "$2" == "warning" ]; then
    echo -e "   ⚠${NC} $1"
  else
    echo -e "  ${BLUE}•${NC} $1"
  fi
}

function print_progress() {
  printf "  ${BLUE}[${NC}%-20s${BLUE}]${NC} %s\r" "${2:0:20}" "$1"
  sleep 0.1
}

# --------------------------
#  Logging Setup
# --------------------------
exec > >(tee -a "$LOG_FILE") 2>&1
print_banner
print_status "Logging to $LOG_FILE" "info"

# --------------------------
#  Error Handling
# --------------------------
function handle_error() {
  print_status "Error: $1" "error"
  echo -e "${RED}${BOLD}[-] Installation failed. Check $LOG_FILE for details.${NC}"
  exit 1
}

# --------------------------
#  Root Check
# --------------------------
print_section "Prerequisite Checks"
if [ "$(id -u)" -ne 0 ]; then
  handle_error "This script must be run as root. Use 'sudo $0' to run the script."
else
  print_status "Root privileges confirmed" "success"
fi

# --------------------------
#  System Detection
# --------------------------
function detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$ID"
  elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    echo "$DISTRIB_ID" | tr '[:upper:]' '[:lower:]'
  elif [ -f /etc/debian_version ]; then
    echo "debian"
  elif [ -f /etc/redhat-release ]; then
    echo "rhel"
  elif [ -f /etc/arch-release ]; then
    echo "arch"
  else
    echo "unknown"
  fi
}

function detect_package_manager() {
  local distro=$1
  case $distro in
    ubuntu|debian|kali|parrot)
      echo "apt"
      ;;
    arch|manjaro)
      echo "pacman"
      ;;
    fedora|centos|rhel|rocky|alma)
      if command -v dnf &>/dev/null; then
        echo "dnf"
      else
        echo "yum"
      fi
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

DISTRO=$(detect_distro)
PACKAGE_MANAGER=$(detect_package_manager "$DISTRO")

if [ "$PACKAGE_MANAGER" == "unknown" ]; then
  handle_error "Unsupported Linux distribution. Exiting..."
fi

print_status "Detected Distribution: ${BOLD}$DISTRO${NC}" "success"
print_status "Using Package Manager: ${BOLD}$PACKAGE_MANAGER${NC}" "success"

# --------------------------
#  System Update
# --------------------------
function update_system() {
  print_section "System Update"
  read -p "Do you want to update the system packages? (y/n):" update_choice
  if [[ "$update_choice" =~ ^[Yy]$ ]]; then
    print_status "Updating system packages..." "info"
    
    case $PACKAGE_MANAGER in
      apt)
        apt update && apt upgrade -y || handle_error "Failed to update system packages."
        ;;
      pacman)
        pacman -Syu --noconfirm || handle_error "Failed to update system packages."
        ;;
      yum)
        yum update -y || handle_error "Failed to update system packages."
        ;;
      dnf)
        dnf update -y || handle_error "Failed to update system packages."
        ;;
    esac
    
    print_status "System update completed successfully" "success"
  else
    print_status "Skipping system update" "warning"
  fi
}

# --------------------------
#  Package Installation
# --------------------------
function install_package() {
  local package=$1
  local description=${2:-$1}
  
  print_progress "Installing $description" "$package"
  
  case $PACKAGE_MANAGER in
    apt)
      apt install -y "$package" >/dev/null 2>&1
      ;;
    pacman)
      pacman -S --noconfirm "$package" >/dev/null 2>&1
      ;;
    yum)
      yum install -y "$package" >/dev/null 2>&1
      ;;
    dnf)
      dnf install -y "$package" >/dev/null 2>&1
      ;;
  esac
  
  if [ $? -eq 0 ]; then
    print_progress "Installed $description" "$package"
    echo -e "\n"
    return 0
  else
    print_progress "Failed to install $description" "$package"
    echo -e "\n"
    return 1
  fi
}

# --------------------------
#  Service Management
# --------------------------
function enable_service() {
  local service=$1
  print_status "Enabling and starting $service service" "info"
  
  if systemctl enable "$service" >/dev/null 2>&1 && systemctl start "$service" >/dev/null 2>&1; then
    print_status "Service $service started successfully" "success"
  else
    print_status "Failed to start $service service" "error"
  fi
}

# --------------------------
#  Tool Categories
# --------------------------
function install_essential() {
  print_section "Essential Dependencies"
  ESSENTIAL_PACKAGES=(
    "build-essential:Build Essential Tools"
    "python3-pip:Python 3 PIP"
    "python3-dev:Python 3 Development"
    "git:Git Version Control"
    "curl:cURL Utility"
    "wget:wget Downloader"
    "zsh:Z Shell"
    "tmux:Terminal Multiplexer"
    "vim:Vim Editor"
    "jq:JSON Processor"
    "unzip:Unzip Utility"
    "htop:Interactive Process Viewer"
  )
  
  for pkg in "${ESSENTIAL_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_package "$package" "$description"
  done
}

function install_network_tools() {
  print_section "Network Tools"
  NETWORK_TOOLS=(
    "nmap:Network Mapper"
    "ncat:Netcat Implementation"
    "ndiff:Nmap Diff"
    "zenmap:Nmap GUI"
    "wireshark:Network Protocol Analyzer"
    "tshark:Wireshark CLI"
    "tcpdump:Packet Analyzer"
    "netcat-traditional:Traditional Netcat"
    "ettercap-common:Ettercap Suite"
    "arpwatch:ARP Monitoring"
    "iptables:Firewall Utility"
    "iproute2:IP Routing Utilities"
    "net-tools:Network Tools"
    "iftop:Interface Traffic Monitor"
    "nethogs:Net Hogs"
    "socat:Socket Cat"
  )
  
  for tool in "${NETWORK_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
}

function install_web_tools() {
  print_section "Web Application Testing Tools"
  WEB_TOOLS=(
    "gobuster:Directory/File Brute-forcer"
    "ffuf:Fast Web Fuzzer"
    "wpscan:WordPress Scanner"
    "nikto:Web Server Scanner"
    "sqlmap:SQL Injection Tool"
    "burpsuite:Web Security Testing"
    "dirb:Web Content Scanner"
    "whatweb:Web Technology Identifier"
    "wapiti:Web Vulnerability Scanner"
    "skipfish:Web Application Scanner"
    "arachni:Web Application Security Scanner"
  )
  
  for tool in "${WEB_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
}

function install_pen_test_tools() {
  print_section "Penetration Testing Tools"
  PEN_TEST_TOOLS=(
    "metasploit-framework:Metasploit Framework"
    "aircrack-ng:WiFi Security Suite"
    "bettercap:MITM Framework"
    "beef-xss:Browser Exploitation Framework"
    "responder:LLMNR/NBT-NS Poisoner"
    "evil-winrm:Windows Remote Management"
    "mimikatz:Windows Credential Dumper"
    "powershell-empire:Post-Exploitation Framework"
    "crackmapexec:Network Exploitation Tool"
    "impacket:Network Protocol Classes"
    "bloodhound:Active Directory Mapper"
    "commix:Automated Command Injection"
    "shellter:Dynamic Shellcode Injector"
  )
  
  for tool in "${PEN_TEST_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
}

function install_vulnerability_tools() {
  print_section "Vulnerability Analysis Tools"
  VULN_TOOLS=(
    "hydra:Network Login Cracker"
    "sqlmap:SQL Injection Tool"
    "rkhunter:Rootkit Hunter"
    "chkrootkit:Rootkit Checker"
    "lynis:Security Auditing Tool"
    "openvas:Vulnerability Scanner"
    "nessus:Vulnerability Scanner"
    "nikto:Web Server Scanner"
    "golismero:Vulnerability Scanner"
    "vuls:Agentless Vulnerability Scanner"
  )
  
  for tool in "${VULN_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
}

function install_info_gathering_tools() {
  print_section "Information Gathering Tools"
  INFO_TOOLS=(
    "theharvester:Email/Subdomain Finder"
    "cewl:Custom Word List Generator"
    "dnsrecon:DNS Enumeration"
    "dnsenum:DNS Enumeration Tool"
    "amass:Subdomain Enumeration"
    "subfinder:Subdomain Discovery"
    "recon-ng:Reconnaissance Framework"
    "maltego:Forensics/Intel Tool"
    "sublist3r:Subdomain Enumeration"
    "massdns:High-Performance DNS"
    "spiderfoot:Reconnaissance Tool"
    "osintgram:OSINT Instagram"
    "holehe:Email Checker"
  )
  
  for tool in "${INFO_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
}

function install_password_tools() {
  print_section "Password Cracking Tools"
  PASSWORD_TOOLS=(
    "john:John the Ripper"
    "hashcat:Password Cracker"
    "crunch:Wordlist Generator"
    "hash-identifier:Hash Type Identifier"
    "seclists:Security Testing Wordlists"
    "cewl:Custom Word List Generator"
    "patator:Multi-purpose Brute-forcer"
    "hashid:Hash Identifier"
    "ophcrack:Windows Password Cracker"
  )
  
  for tool in "${PASSWORD_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
}

function install_exploitation_tools() {
  print_section "Exploitation Tools"
  EXPLOIT_TOOLS=(
    "exploitdb:Exploit Database"
    "searchsploit:Exploit Search Tool"
    "msfpc:MSFvenom Payload Creator"
    "pwntools:CTF Framework"
    "ropgadget:ROP Gadget Finder"
    "armitage:Metasploit GUI"
    "routersploit:Embedded Device Exploitation"
    "autoenum:Automated Enumeration"
    "linux-exploit-suggester:Linux Privilege Escalation"
    "windows-exploit-suggester:Windows Privilege Escalation"
  )
  
  for tool in "${EXPLOIT_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
}

function install_misc_tools() {
  print_section "Miscellaneous Tools"
  MISC_TOOLS=(
    "dirbuster:Web Path Scanner"
    "spiderfoot:Reconnaissance Tool"
    "masscan:Mass Port Scanner"
    "yara:Malware Identification"
    "fcrackzip:Zip Password Cracker"
    "pdfcrack:PDF Password Cracker"
    "steghide:Steganography Tool"
    "binwalk:Binary Analysis"
    "radare2:Reverse Engineering"
    "ghidra:Reverse Engineering"
    "wireshark:Network Protocol Analyzer"
    "hexedit:Hex Editor"
    "foremost:Data Recovery"
    "testdisk:Data Recovery"
  )
  
  for tool in "${MISC_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
}

function install_services() {
  print_section "Security Services"
  SERVICES=(
    "openssh-server:SSH Server"
    "fail2ban:Login Protection"
    "clamav:Antivirus"
    "tripwire:File Integrity Checker"
    "aide:File Integrity Checker"
    "snort:Intrusion Detection"
    "suricata:Intrusion Detection"
  )
  
  for service in "${SERVICES[@]}"; do
    IFS=':' read -r package description <<< "$service"
    if install_package "$package" "$description"; then
      enable_service "$package"
    fi
  done
}

function install_cloud_tools() {
  print_section "Cloud Security Tools"
  CLOUD_TOOLS=(
    "awscli:AWS CLI"
    "terraform:Infrastructure as Code"
    "cloudsploit:Cloud Security Posture"
    "scoutsuite:Cloud Security Auditor"
    "prowler:AWS Security Assessment"
    "cloudmapper:AWS Visualization"
    "kubectl:Kubernetes CLI"
    "helm:Kubernetes Package Manager"
  )
  
  for tool in "${CLOUD_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
}

function install_container_tools() {
  print_section "Container Security Tools"
  CONTAINER_TOOLS=(
    "docker-ce:Docker Engine"
    "docker-compose:Docker Orchestration"
    "trivy:Container Vulnerability Scanner"
    "anchore:Container Security"
    "clair:Container Vulnerability Scanner"
    "dive:Image Analysis"
    "sysdig:Container Troubleshooting"
  )
  
  for tool in "${CONTAINER_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
  
  # Post-installation steps for Docker
  if command -v docker &>/dev/null; then
    print_status "Configuring Docker..." "info"
    usermod -aG docker "$SUDO_USER" && \
    systemctl enable docker && \
    systemctl start docker && \
    print_status "Docker configured successfully" "success" || \
    print_status "Failed to configure Docker" "error"
  fi
}

function install_mobile_tools() {
  print_section "Mobile Security Tools"
  MOBILE_TOOLS=(
    "apktool:APK Decompiler"
    "dex2jar:Android Decompiler"
    "jadx:Java Decompiler"
    "frida:Dynamic Instrumentation"
    "objection:Runtime Mobile Exploration"
    "mobsf:Mobile Security Framework"
  )
  
  for tool in "${MOBILE_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
}

function install_forensic_tools() {
  print_section "Forensic Tools"
  FORENSIC_TOOLS=(
    "autopsy:Digital Forensics"
    "sleuthkit:Forensic Toolkit"
    "volatility:Memory Forensics"
    "bulk_extractor:Data Extraction"
    "guymager:Forensic Imaging"
    "dcfldd:Forensic Imaging"
    "scalpel:File Carving"
    "regripper:Registry Analysis"
  )
  
  for tool in "${FORENSIC_TOOLS[@]}"; do
    IFS=':' read -r package description <<< "$tool"
    install_package "$package" "$description"
  done
}

function install_custom_tools() {
  print_section "Custom Tools Installation"
  
  # Install Metasploit Framework
  read -p "   Do you want to install Metasploit Framework? (y/n): " install_metasploit
  if [[ "$install_metasploit" =~ ^[Yy]$ ]]; then
    if command -v curl &>/dev/null; then
      print_status "Installing Metasploit Framework..." "info"
      curl -s https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > "$TEMP_DIR/msfinstall"
      chmod 755 "$TEMP_DIR/msfinstall" && "$TEMP_DIR/msfinstall" || print_status "Failed to install Metasploit Framework" "error"
    else
      print_status "curl is not installed. Skipping Metasploit installation." "warning"
    fi
  fi
  
  
  # Install Python tools
  read -p "   Do you want to install popular Python security tools? (y/n): " install_python_tools
  if [[ "$install_python_tools" =~ ^[Yy]$ ]]; then
    print_status "Installing Python tools..." "info"
    
    PYTHON_TOOLS=(
      "pipx"
      "pyftpdlib"
      "pycryptodome"
      "scapy"
      "pwntools"
      "ropgadget"
      "androguard"
    )
    
    for tool in "${PYTHON_TOOLS[@]}"; do
      print_progress "Installing $tool" "$tool"
      pip install "$tool" --break-system-packages >/dev/null 2>&1 || print_status "Failed to install $tool" "error"
    done
  fi
}

# --------------------------
#  Interactive Mode
# --------------------------
function interactive_mode() {
  print_section "Tool Selection"
  echo -e " Choose which categories of tools to install:${NC}"
  
  # Essential Dependencies
  read -p "   Install Essential Dependencies? (y/n): " install_essential
  if [[ "$install_essential" =~ ^[Yy]$ ]]; then
    install_essential
  fi
  
  # Network Tools
  read -p "   Install Network Tools? (y/n): " install_network
  if [[ "$install_network" =~ ^[Yy]$ ]]; then
    install_network_tools
  fi
  
  # Web Tools
  read -p "   Install Web Application Testing Tools? (y/n): " install_web
  if [[ "$install_web" =~ ^[Yy]$ ]]; then
    install_web_tools
  fi
  
  # Pen Test Tools
  read -p "   Install Penetration Testing Tools? (y/n): " install_pen_test
  if [[ "$install_pen_test" =~ ^[Yy]$ ]]; then
    install_pen_test_tools
  fi
  
  # Vulnerability Tools
  read -p "   Install Vulnerability Analysis Tools? (y/n): " install_vuln
  if [[ "$install_vuln" =~ ^[Yy]$ ]]; then
    install_vulnerability_tools
  fi
  
  # Info Gathering Tools
  read -p "   Install Information Gathering Tools? (y/n): " install_info
  if [[ "$install_info" =~ ^[Yy]$ ]]; then
    install_info_gathering_tools
  fi
  
  # Password Tools
  read -p "   Install Password Cracking Tools? (y/n): " install_password
  if [[ "$install_password" =~ ^[Yy]$ ]]; then
    install_password_tools
  fi
  
  # Exploitation Tools
  read -p "   Install Exploitation Tools? (y/n): " install_exploit
  if [[ "$install_exploit" =~ ^[Yy]$ ]]; then
    install_exploitation_tools
  fi
  
  # Forensic Tools
  read -p "   Install Forensic Tools? (y/n): " install_forensic
  if [[ "$install_forensic" =~ ^[Yy]$ ]]; then
    install_forensic_tools
  fi
  
  # Cloud Tools
  read -p "   Install Cloud Security Tools? (y/n): " install_cloud
  if [[ "$install_cloud" =~ ^[Yy]$ ]]; then
    install_cloud_tools
  fi
  
  # Container Tools
  read -p "   Install Container Security Tools? (y/n): " install_container
  if [[ "$install_container" =~ ^[Yy]$ ]]; then
    install_container_tools
  fi
  
  # Mobile Tools
  read -p "   Install Mobile Security Tools? (y/n): " install_mobile
  if [[ "$install_mobile" =~ ^[Yy]$ ]]; then
    install_mobile_tools
  fi
  
  # Security Services
  read -p "   Install Security Services? (y/n): " install_services
  if [[ "$install_services" =~ ^[Yy]$ ]]; then
    install_services
  fi
  
  # Custom Tools
  install_custom_tools
}

# --------------------------
#  Post-Installation
# --------------------------
function post_installation() {
  print_section "Post-Installation Tasks"
  
  # Cleanup
  read -p "   Do you want to clean up unnecessary packages? (y/n): " cleanup_choice
  if [[ "$cleanup_choice" =~ ^[Yy]$ ]]; then
    print_status "Cleaning up unnecessary packages..." "info"
    case $PACKAGE_MANAGER in
      apt)
        apt autoremove -y || print_status "Failed to clean up unnecessary packages." "error"
        ;;
      pacman)
        pacman -Rns $(pacman -Qdtq) --noconfirm || print_status "Failed to clean up unnecessary packages." "error"
        ;;
      yum|dnf)
        print_status "Skipping cleanup for $PACKAGE_MANAGER as it doesn't require additional commands." "info"
        ;;
    esac
    print_status "Cleanup completed" "success"
  fi
  
  # Create tool directories
  print_status "Creating tool directories..." "info"
  mkdir -p "$HOME/tools" "$HOME/wordlists" "$HOME/projects" "$HOME/reports"
  print_status "Tool directories created in $HOME" "success"
  
  # Download common wordlists
  read -p "   Do you want to download common wordlists? (y/n): " wordlist_choice
  if [[ "$wordlist_choice" =~ ^[Yy]$ ]]; then
    print_status "Downloading common wordlists to $HOME/wordlists..." "info"
    wget -q -O "$HOME/wordlists/rockyou.txt.gz" https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt.gz && \
    gunzip "$HOME/wordlists/rockyou.txt.gz" && \
    wget -q -O "$HOME/wordlists/dirbuster.txt" https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-2.3-medium.txt && \
    wget -q -O "$HOME/wordlists/subdomains.txt" https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-5000.txt && \
    print_status "Wordlists downloaded successfully" "success" || \
    print_status "Failed to download some wordlists" "error"
  fi
  
  # Final recommendations
  print_section "Installation Complete"
  echo -e "${GREEN}${BOLD}[+] Security tools installation completed successfully!${NC}"
  echo -e "\n Recommended next steps:${NC}"
  echo -e "1. Review installed tools in $LOG_FILE"
  echo -e "2. Configure security services (fail2ban, clamav, etc.)"
  echo -e "3. Update your shell configuration: source ~/.bashrc or restart your terminal"
  echo -e "4. Consider rebooting your system for all changes to take effect"
  echo -e "\n${GREEN}Happy Hacking!${NC}"
}

# --------------------------
#  Main Execution
# --------------------------
update_system
interactive_mode
post_installation

# Cleanup temp files
rm -rf "$TEMP_DIR"
