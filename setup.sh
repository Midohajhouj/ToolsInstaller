#!/bin/bash

# =============================================
#   Python 3 Modules Installer - Pro Edition
# =============================================
#   Version: 1.0
#   Author: Python Professional
#   Description: Comprehensive Python 3 modules installation script
#   with enhanced UI, logging, and system checks
# =============================================

# --------------------------
#  Configuration
# --------------------------
LOG_FILE="/var/log/python_modules_installer.log"
TEMP_DIR="/tmp/python_installer"
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
  echo -e "${CYAN}${BOLD}   PYTHON 3 MODULES INSTALLER "
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
  print_status "Running without root privileges. Some installations may require sudo." "warning"
else
  print_status "Root privileges confirmed" "success"
fi

# --------------------------
#  Python Version Check
# --------------------------
function check_python() {
  if command -v python3 &>/dev/null; then
    PYTHON_VERSION=$(python3 --version | awk '{print $2}')
    print_status "Python 3 version detected: ${BOLD}$PYTHON_VERSION${NC}" "success"
    return 0
  else
    handle_error "Python 3 is not installed. Please install Python 3 first."
    return 1
  fi
}

function check_pip() {
  if command -v pip3 &>/dev/null; then
    PIP_VERSION=$(pip3 --version | awk '{print $2}')
    print_status "pip3 version detected: ${BOLD}$PIP_VERSION${NC}" "success"
    return 0
  else
    print_status "pip3 not found. Attempting to install pip..." "warning"
    
    if command -v python3 &>/dev/null; then
      python3 -m ensurepip --upgrade || \
      curl -s https://bootstrap.pypa.io/get-pip.py | python3 || \
      handle_error "Failed to install pip"
      
      print_status "pip installed successfully" "success"
      return 0
    else
      handle_error "Cannot install pip without Python 3"
      return 1
    fi
  fi
}

check_python
check_pip

# --------------------------
#  Package Installation
# --------------------------
function install_python_package() {
  local package=$1
  local description=${2:-$1}
  
  print_progress "Installing $description" "$package"
  
  # Try with --break-system-packages first, fall back to --user if needed
  if pip3 install "$package" --break-system-packages >/dev/null 2>&1; then
    print_progress "Installed $description" "$package"
    echo -e "\n"
    return 0
  else
    print_progress "Failed with system install, trying user install" "$package"
    if pip3 install "$package" --user >/dev/null 2>&1; then
      print_progress "Installed $description (user space)" "$package"
      echo -e "\n"
      return 0
    else
      print_progress "Failed to install $description" "$package"
      echo -e "\n"
      return 1
    fi
  fi
}

# --------------------------
#  Python Module Categories
# --------------------------
function install_essential() {
  print_section "Essential Python Packages"
  ESSENTIAL_PACKAGES=(
    "pip:Pip Package Manager"
    "setuptools:Setuptools"
    "wheel:Wheel"
    "virtualenv:Virtual Environment"
    "virtualenvwrapper:VirtualEnv Wrapper"
    "ipython:Interactive Python"
    "jupyter:Jupyter Notebook"
    "jupyterlab:Jupyter Lab"
    "numpy:Numerical Computing"
    "pandas:Data Analysis"
    "matplotlib:Data Visualization"
    "seaborn:Statistical Data Visualization"
  )
  
  for pkg in "${ESSENTIAL_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_python_package "$package" "$description"
  done
}

function install_web_dev() {
  print_section "Web Development Packages"
  WEB_PACKAGES=(
    "django:High-level Web Framework"
    "flask:Micro Web Framework"
    "fastapi:Modern Web Framework"
    "requests:HTTP Requests"
    "beautifulsoup4:HTML/XML Parser"
    "selenium:Web Browser Automation"
    "scrapy:Web Scraping Framework"
    "pyramid:Web Framework"
    "tornado:Web Framework"
    "aiohttp:Async HTTP Client/Server"
    "sanic:Async Web Framework"
    "quart:Async Web Framework"
  )
  
  for pkg in "${WEB_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_python_package "$package" "$description"
  done
}

function install_data_science() {
  print_section "Data Science Packages"
  DATA_SCIENCE_PACKAGES=(
    "scipy:Scientific Computing"
    "scikit-learn:Machine Learning"
    "tensorflow:Deep Learning"
    "keras:Deep Learning"
    "pytorch:Deep Learning"
    "opencv-python:Computer Vision"
    "nltk:Natural Language Processing"
    "spacy:Natural Language Processing"
    "gensim:Topic Modeling"
    "statsmodels:Statistical Modeling"
    "xgboost:Gradient Boosting"
    "lightgbm:Gradient Boosting"
    "catboost:Gradient Boosting"
    "dask:Parallel Computing"
  )
  
  for pkg in "${DATA_SCIENCE_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_python_package "$package" "$description"
  done
}

function install_networking() {
  print_section "Networking Packages"
  NETWORKING_PACKAGES=(
    "scapy:Packet Manipulation"
    "paramiko:SSH Protocol"
    "twisted:Event-driven Networking"
    "pyshark:Packet Analysis"
    "dnspython:DNS Toolkit"
    "netmiko:Network Automation"
    "napalm:Network Automation"
    "ncclient:NETCONF Client"
    "pySNMP:SNMP Library"
    "requests-html:HTML Parsing"
  )
  
  for pkg in "${NETWORKING_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_python_package "$package" "$description"
  done
}

function install_security() {
  print_section "Security Packages"
  SECURITY_PACKAGES=(
    "cryptography:Cryptographic Recipes"
    "pycryptodome:Cryptographic Library"
    "paramiko:SSH Protocol"
    "pwntools:CTF Framework"
    "impacket:Network Protocols"
    "scapy:Packet Manipulation"
    "pyopenssl:OpenSSL Wrapper"
    "bandit:Security Linter"
    "safety:Security Checker"
    "pyjwt:JSON Web Tokens"
    "bcrypt:Password Hashing"
    "hashlib:Hash Algorithms"
  )
  
  for pkg in "${SECURITY_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_python_package "$package" "$description"
  done
}

function install_database() {
  print_section "Database Packages"
  DATABASE_PACKAGES=(
    "sqlalchemy:ORM"
    "psycopg2:PostgreSQL Adapter"
    "mysql-connector-python:MySQL Adapter"
    "pymongo:MongoDB Driver"
    "redis:Redis Client"
    "pymysql:MySQL Client"
    "sqlite3:SQLite Interface"
    "dataset:Simple Database Interface"
    "peewee:ORM"
    "django-orm:Django ORM"
    "tortoise-orm:Async ORM"
    "asyncpg:Async PostgreSQL"
  )
  
  for pkg in "${DATABASE_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_python_package "$package" "$description"
  done
}

function install_dev_tools() {
  print_section "Development Tools"
  DEV_TOOLS_PACKAGES=(
    "black:Code Formatter"
    "flake8:Linter"
    "pylint:Linter"
    "mypy:Static Type Checker"
    "pytest:Testing Framework"
    "pytest-cov:Test Coverage"
    "sphinx:Documentation Generator"
    "pdoc:API Documentation"
    "autopep8:Code Formatter"
    "yapf:Code Formatter"
    "isort:Import Sorter"
    "bpython:REPL"
    "ptpython:REPL"
    "ipdb:Debugger"
  )
  
  for pkg in "${DEV_TOOLS_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_python_package "$package" "$description"
  done
}

function install_gui() {
  print_section "GUI Packages"
  GUI_PACKAGES=(
    "tkinter:Standard GUI"
    "pyqt5:Qt GUI"
    "pyside2:Qt GUI"
    "wxpython:wxWidgets GUI"
    "kivy:Multi-touch GUI"
    "pygame:Game Development"
    "pyglet:Game Development"
    "arcade:Game Development"
    "pygtk:GTK GUI"
    "pysimplegui:Simple GUI"
  )
  
  for pkg in "${GUI_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_python_package "$package" "$description"
  done
}

function install_async() {
  print_section "Async Packages"
  ASYNC_PACKAGES=(
    "asyncio:Async I/O"
    "aiohttp:Async HTTP"
    "aioredis:Async Redis"
    "aiomysql:Async MySQL"
    "aiopg:Async PostgreSQL"
    "trio:Async I/O"
    "curio:Async I/O"
    "uvloop:Fast Async I/O"
    "httpx:Async HTTP Client"
    "anyio:Async Compatibility"
  )
  
  for pkg in "${ASYNC_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_python_package "$package" "$description"
  done
}

function install_cloud() {
  print_section "Cloud Packages"
  CLOUD_PACKAGES=(
    "boto3:AWS SDK"
    "google-cloud-python:Google Cloud"
    "azure-storage-blob:Azure Storage"
    "openstack:OpenStack"
    "libcloud:Cloud Abstraction"
    "pulumi:Infrastructure as Code"
    "terraformpy:Terraform Wrapper"
    "kubernetes:Kubernetes Client"
    "docker:Docker SDK"
    "ansible:Automation"
  )
  
  for pkg in "${CLOUD_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_python_package "$package" "$description"
  done
}

function install_misc() {
  print_section "Miscellaneous Packages"
  MISC_PACKAGES=(
    "pillow:Image Processing"
    "pyautogui:GUI Automation"
    "pytz:Time Zones"
    "arrow:Better Dates"
    "dateutil:Date Utilities"
    "lxml:XML Processing"
    "pyyaml:YAML Parser"
    "toml:TOML Parser"
    "pydantic:Data Validation"
    "click:Command Line Interface"
    "typer:Command Line Interface"
    "rich:Terminal Formatting"
    "tqdm:Progress Bars"
    "colorama:Terminal Colors"
    "faker:Test Data"
    "factory_boy:Test Fixtures"
  )
  
  for pkg in "${MISC_PACKAGES[@]}"; do
    IFS=':' read -r package description <<< "$pkg"
    install_python_package "$package" "$description"
  done
}

# --------------------------
#  Interactive Mode
# --------------------------
function interactive_mode() {
  print_section "Module Selection"
  echo -e " Choose which categories of Python modules to install:${NC}"
  
  # Essential Packages
  read -p "   Install Essential Packages? (y/n): " install_essential
  if [[ "$install_essential" =~ ^[Yy]$ ]]; then
    install_essential
  fi
  
  # Web Development
  read -p "   Install Web Development Packages? (y/n): " install_web
  if [[ "$install_web" =~ ^[Yy]$ ]]; then
    install_web_dev
  fi
  
  # Data Science
  read -p "   Install Data Science Packages? (y/n): " install_data
  if [[ "$install_data" =~ ^[Yy]$ ]]; then
    install_data_science
  fi
  
  # Networking
  read -p "   Install Networking Packages? (y/n): " install_net
  if [[ "$install_net" =~ ^[Yy]$ ]]; then
    install_networking
  fi
  
  # Security
  read -p "   Install Security Packages? (y/n): " install_sec
  if [[ "$install_sec" =~ ^[Yy]$ ]]; then
    install_security
  fi
  
  # Database
  read -p "   Install Database Packages? (y/n): " install_db
  if [[ "$install_db" =~ ^[Yy]$ ]]; then
    install_database
  fi
  
  # Development Tools
  read -p "   Install Development Tools? (y/n): " install_dev
  if [[ "$install_dev" =~ ^[Yy]$ ]]; then
    install_dev_tools
  fi
  
  # GUI
  read -p "   Install GUI Packages? (y/n): " install_gui
  if [[ "$install_gui" =~ ^[Yy]$ ]]; then
    install_gui
  fi
  
  # Async
  read -p "   Install Async Packages? (y/n): " install_async
  if [[ "$install_async" =~ ^[Yy]$ ]]; then
    install_async
  fi
  
  # Cloud
  read -p "   Install Cloud Packages? (y/n): " install_cloud
  if [[ "$install_cloud" =~ ^[Yy]$ ]]; then
    install_cloud
  fi
  
  # Miscellaneous
  read -p "   Install Miscellaneous Packages? (y/n): " install_misc
  if [[ "$install_misc" =~ ^[Yy]$ ]]; then
    install_misc
  fi
}

# --------------------------
#  Post-Installation
# --------------------------
function post_installation() {
  print_section "Post-Installation Tasks"
  
  # Upgrade pip
  print_status "Upgrading pip to latest version..." "info"
  pip3 install --upgrade pip --break-system-packages || pip3 install --upgrade pip --user
  print_status "pip upgraded successfully" "success"
  
  # Cleanup
  print_status "Cleaning up pip cache..." "info"
  pip3 cache purge || print_status "Failed to clean pip cache" "warning"
  
  # Final recommendations
  print_section "Installation Complete"
  echo -e "${GREEN}${BOLD}[+] Python modules installation completed successfully!${NC}"
  echo -e "\n Recommended next steps:${NC}"
  echo -e "1. Review installed packages in $LOG_FILE"
  echo -e "2. Consider creating virtual environments for your projects"
  echo -e "3. Update your shell configuration: source ~/.bashrc or restart your terminal"
  echo -e "\n${GREEN}Happy Coding!${NC}"
}

# --------------------------
#  Main Execution
# --------------------------
interactive_mode
post_installation

# Cleanup temp files
rm -rf "$TEMP_DIR"
