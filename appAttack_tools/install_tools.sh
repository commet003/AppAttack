# Function to install Go (programming language) if not already installed
install_go() {
    # Check current Go version
    if command -v go &> /dev/null; then
        version=$(go version | awk '{print $3}')
    else
        version=""
    fi
    release=$(wget -qO- "https://golang.org/VERSION?m=text")
    if [[ $version == "$release" ]]; then
        echo "Go is already up-to-date."
        return
    fi
    git clone https://github.com/udhos/update-golang &> /dev/null
    cd update-golang  || exit 1
    # Run the update script, suppress all output
    {
        sudo ./update-golang.sh &> /dev/null
    } || {
        echo "Failed to update Go."
        return
    }
    # Update PATH
    echo "export PATH=\$PATH:${HOME}/apps/go/bin" >> ~/.bashrc
    source ~/.bashrc
    source /etc/profile.d/golang_path.sh  # Update current shell's PATH

    # Verify installation
    version=$(go version | awk '{print $3}' 2>/dev/null) || true
    if [ -n "$version" ]; then
        echo -e "${GREEN}Dependencies installed successfully!${NC}"
    else
        echo "Failed to get Go version."
    fi
}

install_sonarqube() {
    # Check if SonarQube Docker container is already installed
    if ! sudo docker images | grep -q sonarqube; then
        echo -e "${CYAN}Pulling SonarQube Docker image...${NC}"
        sudo docker pull sonarqube
        
        echo -e "${CYAN}Downloading and installing SonarScanner...${NC}"
        wget -O sonarscanner-cli.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-6.1.0.4477-linux-x64.zip?_gl=1*1vsu6fm*_gcl_au*MTA1MTc2MzQ4NS4xNzI1NTQ4Njcw*_ga*MTIzMjQ3ODQ1OC4xNzI1NTQ4Njcw*_ga_9JZ0GZ5TC6*MTcyNTU0ODY3MC4xLjEuMTcyNTU0OTY2MS42MC4wLjA.
        sudo unzip sonarscanner-cli.zip -d /opt/sonarscanner

        #Add path to ./bashrc
        echo 'export PATH=$PATH:/opt/sonarscanner/sonar-scanner-6.1.0.4477-linux-x64/bin' >> ~/.bashrc
        source ~/.bashrc
        
        echo -e "${GREEN}SonarQube and SonarScanner installed successfully!${NC}"
    else
        echo -e "${GREEN}SonarQube is already installed.${NC}"
    fi
}

install_bandit() {
    if ! command -v bandit &> /dev/null; then
        echo -e "${CYAN}Installing Bandit...${NC}"
        sudo apt update && sudo apt install -y bandit
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Bandit installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install Bandit.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Bandit is already installed.${NC}"
    fi
}

# Function to install npm (Node.js package manager) if not already installed
install_npm() {
    echo -e "${CYAN}Installing npm...${NC}"
    sudo apt update && sudo apt install -y npm
    if [ $? -eq 0 ]; then
        sudo chown -R $(whoami) ~/.npm
        echo -e "${GREEN}npm installed successfully!${NC}"
    else
        echo -e "${RED}Failed to install npm.${NC}"
        exit 1
    fi
}

# Function to install Snyk CLI (a vulnerability scanner) if not already installed
install_snyk_cli() {
    if ! command -v npm &> /dev/null; then
        install_npm
    fi
    if ! command -v snyk &> /dev/null; then
        echo -e "${CYAN}Installing snyk cli...${NC}"
        sudo npm install -g snyk
        echo -e "${GREEN}Snyk cli installed successfully!${NC}"
        echo -e "${YELLOW}Authenticating snyk...${NC}"
        echo -e "${RED}Please authenticate by clicking 'Authenticate' in the browser to continue.${NC}"
        snyk auth
    else
        echo -e "${GREEN}snyk cli is already installed.${NC}"
    fi
}

# Function to install Brakeman if not already installed
install_brakeman() {
    if ! command -v brakeman &> /dev/null; then
        echo -e "${MAGENTA}Installing brakeman...${NC}"
        sudo gem install brakeman
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Brakeman installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install brakeman.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}brakeman is already installed.${NC}"
    fi
}

# Function to install osv-scanner (a vulnerability scanner) if not already installed
install_osv_scanner() {
    install_go
    if ! command -v osv-scanner &> /dev/null; then
        echo -e "${CYAN}Installing osv-scanner...${NC}"
        go install github.com/google/osv-scanner/cmd/osv-scanner@v1
        echo -e "${GREEN}osv-scanner installed successfully!${NC}"
        # Add osv-scanner to the user's PATH
        echo 'export PATH=$PATH:'"$(go env GOPATH)"/bin >> ~/.bashrc
        source ~/.bashrc
    else
        echo -e "${GREEN}osv-scanner is already installed.${NC}"
    fi
}


# Function to install Nmap if not already installed
install_nmap() {
    if ! command -v nmap &> /dev/null; then
        echo -e "${MAGENTA}Installing nmap...${NC}"
        sudo apt update && sudo apt install -y nmap
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}nmap installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install nmap.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}nmap is already installed.${NC}"
    fi
}

# Function to install Aircrack if not already installed
install_aircrack-ng() {
    if ! command -v aircrack-ng &> /dev/null; then
        echo -e "${MAGENTA}Installing aircrack-ng...${NC}"
        sudo apt update && sudo apt install -y aircrack-ng
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}aircrack-ng installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install aircrack-ng.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}aircrack-ng is already installed.${NC}"
    fi
}

# Function to install Reaver if not already installed
install_reaver() {
    if ! command -v reaver &> /dev/null; then
        echo -e "${MAGENTA}Installing reaver...${NC}"
        sudo apt update && sudo apt install -y reaver
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}reaver installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install reaver.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}reaver is already installed.${NC}"
    fi
}

# Function to install Ncrack if not already installed
install_ncrack() {
    if ! command -v ncrack &> /dev/null; then
        echo -e "${MAGENTA}Installing ncrack...${NC}"
        sudo apt update && sudo apt install -y ncrack
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}ncrack installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install ncrack.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}ncrack is already installed.${NC}"
    fi
}

# Function to install nikto
install_nikto() {
    # Check if nikto is not installed
    if ! command -v nikto &> /dev/null; then
        # Display message indicating nikto installation
        echo -e "${CYAN}Installing nikto...${NC}"
        # Update package list and install nikto
        sudo apt update && sudo apt install -y nikto
        # Check if the installation was successful
        if [ $? -eq 0 ]; then
            # Display success message
            echo -e "${GREEN}nikto installed successfully!${NC}"
        else
            #   Display failure message and exit script
            echo -e "${RED}Failed to install nikto.${NC}"
            exit 1
        fi
    else
        # Display message if nikto is already installed
        echo -e "${GREEN}nikto is already installed.${NC}"
    fi
}
# Function to install LEGION
install_legion() {
    # Check if legion is not installed
    if ! command -v legion &> /dev/null; then
        # Display message indicating LEGION installation
        echo -e "${MAGENTA}Installing LEGION...${NC}"
        # Update package list
        sudo apt update
        # Install legion
        sudo apt install -y legion
        # Check if the installation was successful
        if [ $? -eq 0 ]; then
            # Display success message
            echo -e "${GREEN}LEGION installed successfully!${NC}"
        else
            # Display failure message and exit script
            echo -e "${RED}Failed to install LEGION.${NC}"
            exit 1
        fi
    else
        # Display message if LEGION is already installed
        echo -e "${GREEN}LEGION is already installed.${NC}"
    fi
}

# Function to install OWASP ZAP
install_owasp_zap() {
    # Check if OWASP ZAP is not installed by checking its directory
    if [ ! -d "/opt/owasp-zap/" ]; then
        # Display message indicating OWASP ZAP installation
        echo -e "${CYAN}Installing OWASP ZAP...${NC}"
        # Download OWASP ZAP tar file to /tmp directory
        wget https://github.com/zaproxy/zaproxy/releases/download/v2.15.0/ZAP_2.15.0_Linux.tar.gz -P /tmp
        # Check if the download was successful
        if [ $? -eq 0 ]; then
            # Create directory for OWASP ZAP in /opt
            sudo mkdir -p /opt/owasp-zap
            # Change ownership of the OWASP ZAP directory to the current user
            sudo chown -R $(whoami):$(whoami) /opt/owasp-zap
            # Extract the downloaded tar file to the OWASP ZAP directory
            tar -xf /tmp/ZAP_2.15.0_Linux.tar.gz -C /opt/owasp-zap/
            # Create a symbolic link for the OWASP ZAP executable in /usr/local/bin
            sudo ln -s /opt/owasp-zap/ZAP_2.15.0/zap.sh /usr/local/bin/zap
            # Check if the symbolic link creation was successful
            if [ $? -eq 0 ]; then
                # Display success message
                echo -e "${GREEN}OWASP ZAP installed successfully!${NC}"
            else
                # Display failure message and exit script
                echo -e "${RED}Failed to move OWASP ZAP.${NC}"
                exit 1
            fi
        else
            # Display failure message if download failed and exit script
            echo -e "${RED}Failed to download OWASP ZAP.${NC}"
            exit 1
        fi
    else
        # Display message if OWASP ZAP is already installed
        echo -e "${GREEN}OWASP ZAP is already installed.${NC}"
    fi
}

# Function to install John the Ripper if not already installed
install_john() {
    if ! command -v john &> /dev/null; then
        echo -e "${MAGENTA}Installing John the Ripper...${NC}"
        sudo apt update && sudo apt install -y john
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}John the Ripper installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install John the Ripper.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}John the Ripper is already installed.${NC}"
    fi
}

# Function to install sqlmap if not already installed
install_sqlmap() {
    if ! command -v sqlmap &> /dev/null; then
        echo -e "${MAGENTA}Installing sqlmap...${NC}"
        sudo apt update && sudo apt install -y sqlmap
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}sqlmap installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install sqlmap.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}sqlmap is already installed.${NC}"
    fi
}

# Function to install Metasploit if not already installed
install_metasploit() {
    if ! command -v msfconsole &> /dev/null; then
        echo -e "${MAGENTA}Installing Metasploit...${NC}"
        sudo apt update && sudo apt install -y metasploit-framework
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Metasploit installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install Metasploit.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Metasploit is already installed.${NC}"
    fi
}

# Function to install Wapiti (a vulnerability scanner) if not already installed
install_wapiti() {
    if ! command -v wapiti &> /dev/null; then
        echo -e "${CYAN}Installing Wapiti...${NC}"
        sudo apt update && sudo apt install -y wapiti
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Wapiti installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install Wapiti.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Wapiti is already installed.${NC}"
    fi
}

# Function to install Tshark (Wireshark CLI), if it is not already installed
install_tshark() {
    if ! command -v tshark &> /dev/null; then
        echo -e "${CYAN}Installing TShark...${NC}"
        sudo apt update && sudo apt install -y tshark
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}TShark installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install TShark.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}TShark is already installed.${NC}"
    fi
}

# Function to install Binwalk (Firmware analyzer), if it is not already installed
install_binwalk() {
    if ! command -v binwalk &> /dev/null; then
        echo -e "${CYAN}Installing Binwalk...${NC}"
        sudo apt update && sudo apt install -y binwalk
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Binwalk installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install Binwalk.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Binwalk is already installed.${NC}"
    fi
}

# Function to install Hashcat (Fast password recovery, cracking), if it is not already installed
install_hashcat() {
    if ! command -v hashcat &> /dev/null; then
        echo -e "${CYAN}Installing Hashcat...${NC}"
        sudo apt update && sudo apt install -y hashcat
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Hashcat installed successfully!${NC}"
        else
            echo -e "${RED}Failed to install Hashcat.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Hashcat is already installed.${NC}"
    fi
}