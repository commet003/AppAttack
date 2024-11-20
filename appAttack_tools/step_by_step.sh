#!/bin/bash
# Function for handling the guide for the OSV scanner , which helps to update the documentation, once there is any new release.
handle_step_by_step_SCR_OSV_Scanner(){
    local choice
    while true; do
        echo "   - OSV Scanner is a tool for detecting security vulnerabilities in open source projects. To learn more, click on the following link below."
        echo "   - Download: https://github.com/google/osv-scanner"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        case $choice in
            1) break ;;
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
        esac
        
    done
    
}

# Function for handling the guide for the Snyc code scanner , which helps to update the documentation, once there is any new release.
handle_step_by_step_SCR_Snyk(){
    
    local choice
    while true; do
        echo "   - Snyk ia a CLI tool to find and fix vulnerabilities in your code, dependencies, containers, and infrastructure as code."
        echo "   -  To Download and learn more: https://snyk.io/download/"
        echo "   - Run code test locally: snyk code test <directory>"
        echo "   - Monitor for vulnerabilities: snyk monitor <directory> --all-projects"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) break ;;
            
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
    
    
    
}

# Function for handling the guide for the brakeman tool, which helps to update the documentation, once there is any new release.
handle_step_by_step_SCR_brakeman(){
    
    local choice
    
    while true; do
        
        echo "   - Barakeman is a static analysis tool specifically designed to find security issues in Ruby on Rails applications."
        echo "   - Download: https://github.com/presidentbeef/brakeman"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) break ;;
            
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
    
    
    
}

# Function for handling the guide for the bandit tool , which helps to update the documentation, once there is any new release.
handle_step_by_step_SCR_bandit(){
    
    local choice
    
    while true; do
        
        echo "   - A tool designed to find common security issues in Python code."
        echo "   - Download: https://bandit.readthedocs.io/en/latest/"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) break ;;
            
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
    
    
    
}

# Function for handling the guide for the SonarQube , which helps to update the documentation, once there is any new release.
handle_step_by_step_SCR_sonar(){
    
    local choice
    
    while true; do
        
        echo "   - An open-source platform for continuous inspection of code quality and security to detect bugs, vulnerabilities, and code smells."
        echo "   - Download: https://www.sonarqube.org/downloads/"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) break ;;
            
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
    
    
    
}

# Function for handling the guide for the nmap pentest tool, which helps to update the documentation, once there is any new release.
handle_step_by_step_pentest_nmap(){
    
    local choice
    
    while true; do
        
        echo "   - A versatile and powerful tool for network discovery and security auditing, widely used for network inventory, managing service upgrade schedules, and monitoring host or service uptime."
        echo "   - Download: https://nmap.org/download.html"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) break ;;
            
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
}

# Function for handling the guide for the nitko pentest tool, which helps to update the documentation, once there is any new release.
handle_step_by_step_pentest_nitko(){
    
    local choice
    
    while true; do
        
        echo "   - An open source web server scanner that performs comprehensive tests against web servers for multiple items, including over 6700 potentially dangerous files/programs and outdated versions."
        echo "   - Download: https://cirt.net/nikto/"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) break ;;
            
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
}

# Function for handling the guide for the legion pentest tool, which helps to update the documentation, once there is any new release.
handle_step_by_step_pentest_legion(){
    
    local choice
    
    while true; do
        
        echo "   - A toolkit for web application testing that automates the scanning process to identify common vulnerabilities and exposures in web applications."
        echo "   - Download: https://github.com/GoVanguard/legion"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) break ;;
            
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
}

# Function for handling the guide for the OWASP ZAP pentest tool, which helps to update the documentation, once there is any new release.
handle_step_by_step_pentest_owasp_zap(){
    
    local choice
    
    while true; do
        
        echo "   - An open-source web application security scanner and testing tool maintained by the OWASP community, used for finding vulnerabilities in web applications."
        echo "   - Download: https://github.com/zaproxy/zaproxy/releases"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) break ;;
            
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
}

# Function for handling the guide for the John the ripper pentest tool, which helps to update the documentation, once there is any new release.
handle_step_by_step_pentest_John_the_ripper(){
    
    local choice
    
    while true; do
        
        echo "   - A powerful and flexible password cracking tool that supports various encryption algorithms and is used to crack password hashes through brute-force attacks."
        echo "   - Download: https://www.openwall.com/john/"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) break ;;
            
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
}

# Function for handling the guide for the SQLmap pentest tool, which helps to update the documentation, once there is any new release.
handle_step_by_step_pentest_SQLmap(){
    
    local choice
    
    while true; do
        
        echo "   - An open-source penetration testing tool that automates the process of detecting and exploiting SQL injection vulnerabilities and taking over database servers."
        echo "   - Download: https://sqlmap.org/"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) break ;;
            
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
}

# Function for handling the guide for the metasploit pentest tool, which helps to update the documentation, once there is any new release.
handle_step_by_step_pentest_metasploit(){
    
    local choice
    
    while true; do
        
        echo "   - A comprehensive open-source framework for developing, testing, and executing exploits against target systems, widely used for penetration testing and vulnerability assessment."
        echo "   - Download: https://metasploit.help.rapid7.com/docs/installing-the-metasploit-framework"
        echo -e "${YELLOW}1) Go Back${NC}"
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) break ;;
            
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
}

# Function for handling the guide for the Wapiti pentest tool, which helps to update the documentation, once there is any new release.
handle_step_by_step_pentest_wapiti() {
    echo -e "${YELLOW}Wapiti Step-by-Step Guide:${NC}"
    echo -e "${CYAN}1) Install Wapiti:${NC}"
    echo "   To install Wapiti, run the following command:"
    echo "   sudo apt-get install wapiti"
    
    echo -e "${CYAN}2) Run Wapiti:${NC}"
    echo "   To run Wapiti on a target URL, use the following command:"
    echo "   wapiti -u http://example.com -o output_directory"
    
    echo -e "${CYAN}3) View Results:${NC}"
    echo "   After Wapiti completes its scan, the results will be available in the output directory specified."
    
    echo -e "${CYAN}4) Update Documentation:${NC}"
    echo "   Ensure that you regularly check for updates to Wapiti and update the documentation accordingly."
    
    echo -e "${YELLOW}End of Wapiti Step-by-Step Guide${NC}"
}