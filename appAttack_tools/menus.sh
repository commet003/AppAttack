#!/bin/bash

# Display the Banner
echo -e "${BYellow}                                                                           ${Color_Off}"
echo -e "${BRed} █████╗ ██████╗ ██████╗     █████╗ ████████╗████████╗ █████╗  ██████╗██╗  ██╗${Color_Off}"
echo -e "${BRed}██╔══██╗██╔══██╗██╔══██╗   ██╔══██╗╚══██╔══╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝${Color_Off}"
echo -e "${BGreen}███████║██████╔╝██████╔╝   ███████║   ██║      ██║   ███████║██║     █████╔╝ ${Color_Off}"
echo -e "${BGreen}██╔══██║██╔═══╝ ██╔═══╝    ██╔══██║   ██║      ██║   ██╔══██║██║     ██╔═██╗ ${Color_Off}"
echo -e "${BBlue}██║  ██║██║     ██║        ██║  ██║   ██║      ██║   ██║  ██║╚██████╗██║  ██╗${Color_Off}"
echo -e "${BBlue}╚═╝  ╚═╝╚═╝     ╚═╝        ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝${Color_Off}"
echo -e "${BYellow}                                                                           ${Color_Off}"
echo -e "${BPurple}              A Professional Pen-Testing/Secure Code Review Toolkit        ${Color_Off}"
#echo -e "${BCyan}Usage:${Color_Off} ./app-attack.sh [options]"


display_main_menu() {
    echo -e "\n${BYellow}╔════════════════════════════════╗${NC}"
    echo -e "${BYellow}║           Main Menu            ║${NC}"
    echo -e "${BYellow}╚════════════════════════════════╝${NC}"
    echo -e "${BCyan}1)${NC} ${White}Penetration Testing Tools${NC}"
    echo -e "${BCyan}2)${NC} ${White}Secure Code Review Tools${NC}"
	echo -e "${BCyan}3)${NC} ${White}IoT Security Tools${NC}"
    echo -e "${BCyan}4)${NC} ${White}Step by Step Guide${NC}"
    echo -e "${BCyan}5)${NC} ${White}Exit${NC}"
    echo -e "${BYellow}╚════════════════════════════════╝${NC}"
}


# Function to display asterisks in order to make the display uncluttered.
#display_asterisk(){
   # echo -e "${YELLOW}"
    # Using a loop
   # for i in {1..100}; do
     #   echo -n "*"
 #   done
 #   echo  # Move to the next line after printing all asterisks
    
#}


# Function to display Penetration Testing Tools menu
display_penetration_testing_tools_menu() {
    echo -e "\n${BYellow}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BYellow}║        Penetration Testing Tools           ║${NC}"
    echo -e "${BYellow}╚════════════════════════════════════════════╝${NC}"
    echo -e "${BCyan}1)${NC} ${BWhite}nmap${NC}: Network exploration and security auditing tool"
    echo -e "${BCyan}2)${NC} ${BWhite}nikto${NC}: Web server scanner"
    echo -e "${BCyan}3)${NC} ${BWhite}LEGION${NC}: Automated web application security scanner"
    echo -e "${BCyan}4)${NC} ${BWhite}OWASP ZAP${NC}: Web application security testing tool"
    echo -e "${BCyan}5)${NC} ${BWhite}John the Ripper${NC}: Password cracking tool"
    echo -e "${BCyan}6)${NC} ${BWhite}SQLmap${NC}: SQL Injection and database takeover tool"
    echo -e "${BCyan}7)${NC} ${BWhite}Metasploit Framework${NC}: Penetration testing framework"
    echo -e "${BCyan}8)${NC} ${BWhite}Wapiti${NC}: Web Application Vulnerability Scanner"
    echo -e "${BCyan}9)${NC} ${BWhite}Automated Scan${NC}: Run an automated vulnerability scan"
    echo -e "${BCyan}0)${NC} ${BWhite}Go Back${NC}"
    echo -e "${BYellow}╚════════════════════════════════════════════╝${NC}"
}


# Function to display Secure Code Review Tools menu
display_secure_code_review_tools_menu() {
    echo -e "\n${BYellow}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BYellow}║        Secure Code Review Tools            ║${NC}"
    echo -e "${BYellow}╚════════════════════════════════════════════╝${NC}"
    echo -e "${BCyan}1)${NC} ${White}osv-scanner: Scan a directory for vulnerabilities${NC}"
    echo -e "${BCyan}2)${NC} ${White}snyk cli: Test code locally or monitor for vulnerabilities${NC}"
    echo -e "${BCyan}3)${NC} ${White}brakeman: Scan a Ruby on Rails application for security vulnerabilities${NC}"
    echo -e "${BCyan}4)${NC} ${White}bandit: Security linter for Python code${NC}"
    echo -e "${BCyan}5)${NC} ${White}SonarQube: Continuous inspection of code quality and security${NC}"
    echo -e "${BCyan}6)${NC} ${White}Go Back${NC}"
    echo -e "${BYellow}╚════════════════════════════════════════════╝${NC}"
}

# Function to display IoT Tools menu
display_iot_security_tools_menu() {
    echo -e "\n${BYellow}╔══════════════════════════════════════════╗${NC}"
    echo -e "${BYellow}║            IoT Security Tools            ║${NC}"
    echo -e "${BYellow}╚══════════════════════════════════════════╝${NC}"
    echo -e "${BCyan}1)${NC} ${White}Aircrack-ng${NC}"
    echo -e "${BCyan}2)${NC} ${White}Bettercap${NC}"
    echo -e "${BCyan}3)${NC} ${White}Binwalk${NC}"
    echo -e "${BCyan}4)${NC} ${White}Hashcat${NC}"
    echo -e "${BCyan}5)${NC} ${White}Miranda${NC}"
    echo -e "${BCyan}6)${NC} ${White}Ncrack${NC}"
    echo -e "${BCyan}7)${NC} ${White}Nmap${NC}"
    echo -e "${BCyan}8)${NC} ${White}Pholus${NC}"
    echo -e "${BCyan}9)${NC} ${White}Reaver${NC}"
    echo -e "${BCyan}10)${NC} ${White}Scapy${NC}"
    echo -e "${BCyan}11)${NC} ${White}Umap${NC}"
    echo -e "${BCyan}12)${NC} ${White}Wifiphisher${NC}"
    echo -e "${BCyan}13)${NC} ${White}Wireshark${NC}"
    echo -e "${BCyan}14)${NC} ${White}Yersinia${NC}"
    echo -e "${BCyan}15)${NC} ${White}Go Back${NC}"
    echo -e "${BYellow}╚═══════════════════════════════════════════╝${NC}"
}

# Function to display Step by Step Guide menu
display_step_by_step_guide_menu() {
    echo -e "\n${BYellow}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BYellow}║           Step by Step Guide               ║${NC}"
    echo -e "${BYellow}╚════════════════════════════════════════════╝${NC}"
    echo -e "${BCyan}1)${NC} ${White}Learn about Pen Testing tools${NC}"
    echo -e "${BCyan}2)${NC} ${White}Learn about Secure code review tools${NC}"
	echo -e "${BCyan}3)${NC} ${White}Learn about IoT Security tools${NC}"
    echo -e "${BCyan}4)${NC} ${White}Go Back${NC}"
    echo -e "${BYellow}╚════════════════════════════════════════════╝${NC}"
}

# Function to display the step by step guide of the penetration testing tools.
display_step_by_step_guide_pen_testing(){
    
    echo -e "${YELLOW}Penetration Testing Tools step by step guide :${NC}"
    echo -e "${CYAN}1) nmap: Network exploration and security auditing tool${NC}"
    echo -e "${MAGENTA}2) nikto: Web server scanner${NC}"
    echo -e "${CYAN}3) LEGION: Automated web application security scanner${NC}"
    echo -e "${MAGENTA}4) OWASP ZAP: Web application security testing tool${NC}"
    echo -e "${CYAN}5) John the Ripper: Password cracking tool${NC}"
    echo -e "${MAGENTA}6) SQLmap: SQL Injection and database takeover tool${NC}"
    echo -e "${CYAN}7) Metasploit Framework: Penetration testing framework${NC}"
    echo -e "${MAGENTA}8) Wapiti: Web Application Vulnerability Scanner${NC}"
    echo -e "${YELLOW}9) Go Back${NC}"
   # display_asterisk
    
}

# Function to display the step by step guide of the Secure Code Review tools.

display_step_by_step_guide_secure_code_review(){
    
    echo -e "${YELLOW}Secure Code Review Tools:${NC}"
    echo -e "${CYAN}1) osv-scanner: Scan a directory for vulnerabilities${NC}"
    echo -e "${MAGENTA}2) snyk cli: Test code locally or monitor for vulnerabilities${NC}"
    echo -e "${CYAN}3) brakeman: Scan a Ruby on Rails application for security vulnerabilities${NC}"
    echo -e "${MAGENTA}4) bandit: Security linter for Python code${NC}"
    echo -e "${CYAN}5) SonarQube: Continuous inspection of code quality and security${NC}"
    echo -e "${YELLOW}6) Go Back"
  #  display_asterisk
    
}

display_step_by_step_guide_iot_security_tools(){
    
    echo -e "${YELLOW}IoT Security Tools:${NC}"
    echo -e "${BCyan}1)  Aircrack-ng: Used for WEP, WPA PSK cracking, de-authentication and replay attacks${NC}"
    echo -e "${MAGENTA}2)  Bettercap: A WiFi, BLE, HID, and Ethernet reconnaissance tool${NC}"
    echo -e "${BCyan}3)  Binwalk: Use to analyse or extract firmware from an IoT device${NC}"
    echo -e "${MAGENTA}4)  Hashcat: A fast password recovery and cracking tool${NC}"
    echo -e "${BCyan}5)  Miranda: A tool used to attack UPnP devices${NC}"
    echo -e "${MAGENTA}6)  Ncrack: A network authentication cracking tool${NC}"
    echo -e "${BCyan}7)  Nmap: Network exploration and security auditing tool${NC}"
    echo -e "${MAGENTA}8)  Pholus: A mDNS and DNS-SD security assessment tool${NC}"
    echo -e "${BCyan}9)  Reaver: Used to conduct brute force attacks against WPS PINs${NC}"
    echo -e "${MAGENTA}10) Scapy: A tool for crafting, decoding, and forging packets for a variety of network protocols${NC}"
    echo -e "${BCyan}11) Umap: Used to attack UPnP devices via the WAN interface${NC}"
    echo -e "${MAGENTA}12) Wifiphisher: Rouge access point framework used to conduct man-in-the-middle attacks${NC}"
    echo -e "${BCyan}13) Wireshark: Network packet capture and analysis tool${NC}"
    echo -e "${MAGENTA}14) Yersinia: Network layer 2 attack tool${NC}"
    echo -e "${YELLOW}15) Go Back"
  #  display_asterisk  
}


#Handle Options

# Function for Penetration Testing Tools
handle_penetration_testing_tools() {
    # Run Wapiti scan
    local OUTPUT_DIR=$1
    local choice
    while true; do
        display_penetration_testing_tools_menu
        read -p "Choose an option: " choice
        case $choice in
            1) run_nmap "$OUTPUT_DIR" "false" ;;
            2) run_nikto "$OUTPUT_DIR" ;;
            3) run_legion "$OUTPUT_DIR" ;;
            4) run_owasp_zap "$OUTPUT_DIR" ;;
            5) run_john "$OUTPUT_DIR" ;;
            6) run_sqlmap "$OUTPUT_DIR" ;;
            7) run_metasploit "$OUTPUT_DIR" ;;
	        8) run_wapiti "$OUTPUT_DIR" ;;
            9) run_automated_scan ;;
            0) break ;;
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
        esac
    done
}

# Function for Secure Code Review Tools
handle_secure_code_review_tools() {
    OUTPUT_DIR=$1
    local choice
    while true; do
        display_secure_code_review_tools_menu
        read -p "Choose an option: " choice
        case $choice in
            1) run_osv_scanner "$OUTPUT_DIR" ;;
            2) run_snyk "$OUTPUT_DIR" ;;
            3) run_brakeman "$OUTPUT_DIR" ;;
            4) run_bandit "$OUTPUT_DIR" ;;
            5) run_sonarqube "$OUTPUT_DIR" ;;
            6) break ;;
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
        esac
    done
}

# Function for IoT Security Tools
handle_iot_security_tools() {
    local OUTPUT_DIR=$1
    local choice
    while true; do
        display_iot_security_tools_menu
        read -p "Choose an option: " choice
        case $choice in
            1) run_assigniot ;;
            2) run_assigniot ;;
            3) run_assigniot ;;
            4) run_assigniot ;;
            5) run_assigniot ;;
            6) run_assigniot ;;
            7) run_nmap "$OUTPUT_DIR" "true" ;;
            8) run_assigniot ;;
            9) run_assigniot ;;
            10) run_assigniot ;;
            11) run_assigniot ;;
            12) run_assigniot ;;
            13) run_assigniot ;;
            14) run_assigniot ;;
            15) break ;;
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
        esac
    done
}

# Function for handling the step by step guide
handle_step_by_step_guide(){
    
    local choice
    
    while true; do
        
        display_step_by_step_guide_menu
        
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) handle_step_by_step_guide_Pentest;;
            2) handle_step_by_step_guide_SCR;;
			3) handle_step_by_step_guide_IoT;;
            4) break ;;
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
    
}

handle_step_by_step_guide_SCR(){
    
    local choice
    
    while true; do
        
        display_step_by_step_guide_secure_code_review
        
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) handle_step_by_step_SCR_OSV_Scanner;;
            2) handle_step_by_step_SCR_Snyk ;;
            3) handle_step_by_step_SCR_brakeman;;
            4) handle_step_by_step_SCR_bandit;;
            5) handle_step_by_step_SCR_sonar ;;
            6) break;;
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
    
    
    
}

handle_step_by_step_guide_Pentest(){
    
    local choice
    
    while true; do
        
        display_step_by_step_guide_pen_testing
        
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) handle_step_by_step_pentest_nmap;;
            2) handle_step_by_step_pentest_nitko;;
            3) handle_step_by_step_pentest_legion;;
            4) handle_step_by_step_pentest_owasp_zap;;
            5) handle_step_by_step_pentest_John_the_ripper;;
            6) handle_step_by_step_pentest_SQLmap;;
            7) handle_step_by_step_pentest_metasploit;;
	        8) handle_step_by_step_pentest_wapiti ;;  
            9) break ;;
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
}

handle_step_by_step_guide_IoT(){
    
    local choice
    
    while true; do
        
        display_step_by_step_guide_iot_security_tools
        
        read -p "Choose an option: " choice
        
        case $choice in
            
            1) ;;
            2) ;;
            3) ;;
            4) ;;
            5) break;;
            *) echo -e "${RED}Invalid choice, please try again.${NC}" ;;
            
        esac
        
    done
    
}