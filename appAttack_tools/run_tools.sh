#!/bin/bash


# Function to run nmap
run_nmap(){
    OUTPUT_DIR=$1
    isIoTUsage=$2

    output_file="${OUTPUT_DIR}/nmap_output.txt"


    # Prompt user for URL or IP address
    read -p "Enter URL or IP address to scan: " url


    # Handle file output and IoT usage
    if [[ "$output_to_file" == "y" ]]; then
        if [[ "$isIoTUsage" == "true" ]]; then
            nmap_output=$(nmap -A "$url" -oN "$output_file")
        else
            nmap_output=$(nmap -oN "$output_file" "$url")
        fi
    else
        if [[ "$isIoTUsage" == "true" ]]; then
            nmap_output=$(nmap -A "$url")
            nmap -A "$url"
        else
            nmap_output=$(nmap "$url")
            nmap "$url"
        fi
    fi

    # Call the generate_ai_insights function with the Nmap output
    generate_ai_insights "$nmap_output"
    echo -e "${GREEN}Nmap Operation completed.${NC}"
}

# Function to run Bandit
run_bandit() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/bandit_output.txt"
    read -p "Enter the directory to scan: " directory

    # Capture the output of the Bandit command
    if [[ "$output_to_file" == "y" ]]; then
        bandit_output=$(bandit -r "$directory" -f txt)
        echo "$bandit_output" > "$output_file"
    else
        bandit_output=$(bandit -r "$directory" -f txt)
        echo -e "${NC}"
        echo "$bandit_output"
    fi
    generate_ai_insights "$bandit_output"
    echo -e "${GREEN} Bandit operation completed.${NC}"
}

# Function to run SonarQube
run_sonarqube() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/sonarqube_output.txt"

    # Check if SonarQube Docker container is already running or exists
    if sudo docker ps -a --format '{{.Names}}' | grep -w "sonarqube" > /dev/null; then
        echo -e "${YELLOW}A container named 'sonarqube' already exists. Removing the existing container...${NC}"
        sudo docker rm -f sonarqube
    fi

    echo -e "${CYAN}Running SonarQube container...${NC}"
    sudo docker run -d --name sonarqube -p 9001:9000 sonarqube

    echo -e "${GREEN}SonarQube is running at http://localhost:9001${NC}"
    echo "Default credentials: "
    echo "login: admin"
    echo "password: admin"

    # Capture SonarQube logs
    if [[ "$output_to_file" == "y" ]]; then
        # Show the logs on the screen and capture them in a file using 'tee'
        sudo docker logs -f sonarqube | tee "$output_file.txt" > "$output_file_log.txt"
        sonarqube_output=$(cat "$output_file_log.txt")
    else
        # Capture the logs in a variable and display them
        sonarqube_output=$(sudo docker logs -f sonarqube 2>&1)
        echo "$sonarqube_output"
    fi

    # Call the function to generate AI insights based on SonarQube logs
    generate_ai_insights "$sonarqube_output" "$output_to_file" "$output_file.txt"
    echo -e "${GREEN}SonarQube operation completed.${NC}"


}

# Function to run Nikto
run_nikto() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/nikto_output.txt"
    read -p "Enter URL and port to scan (Example: http://localhost:4200): " url
    if [[ "$output_to_file" == "y" ]]; then
        read -p "Enter the output format (txt, html, xml): " format
        nikto_output=$(nikto -h "$url" -o "$output_file" -Format "$format")
    echo "$nikto_output" > "$output_file"
    else
        nikto_output=$(nikto -h "$url")
        nikto -h "$url"
    fi
    generate_ai_insights "$nikto_output"
    echo -e "${GREEN} Nikto Operation completed.${NC}"
}



# Function to run LEGION
run_legion() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/legion_output.txt"

    if [[ "$output_to_file" == "y" ]]; then
        # Show the output on the screen and capture it in a file using 'tee'
        sudo legion | tee "$output_file" > "$output_file_log.txt"
        legion_output=$(cat "$output_file_log.txt")
    else
        # Just show the output on the screen and capture it in a variable
        legion_output=$(sudo legion 2>&1)
        echo "$legion_output"
    fi

    # Call the function to generate AI insights based on Legion output
    generate_ai_insights "$legion_output" "$output_to_file" "$output_file"
    echo -e "${GREEN} Legion operation completed.${NC}"


}


# Function to run OWASP ZAP
run_owasp_zap() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/zap_output.txt"
    read -p "Enter URL and port to scan (Example: http://localhost:4200): " url

    if [[ "$output_to_file" == "y" ]]; then
        # Show the output on the screen and capture it in a file using 'tee'
        zap -quickurl $url | tee "$output_file" > "$output_file_log.txt"
        zap_output=$(cat "$output_file_log.txt")
    else
        # Just show the output on the screen and capture it in a variable
        zap_output=$(zap -quickurl $url 2>&1)
        echo "$zap_output"
    fi
    # Call the function to generate AI insights based on OWASP ZAP output
    generate_ai_insights "$zap_output" "$output_to_file" "$output_file"
    echo -e "${GREEN} OWASP ZAP Operation completed.${NC}"


}



# Function to run John the Ripper
run_john() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/john_output.txt"

    read -p "Enter the path to the password file to crack: " password_file

    if [[ "$output_to_file" == "y" ]]; then
        # Capture the output of john to a file
        john --session="$output_file" "$password_file" > "$output_file" 2>&1
        john_output=$(cat "$output_file")
    else
        # Capture the output of john to a variable
        john_output=$(john "$password_file" 2>&1)
        echo "$john_output"
    fi

    # Call the function to generate AI insights based on John the Ripper output
    generate_ai_insights "$john_output" "$output_to_file" "$output_file"
    echo -e "${GREEN} John the Ripper operation completed.${NC}"


}


# Function to run sqlmap
run_sqlmap() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/sqlmap_output.txt"

    read -p "Enter URL to scan (e.g., http://example.com/vuln.php?id=1): " url

    if [[ "$output_to_file" == "y" ]]; then
        sqlmap -u "$url" --output-dir="$output_file" > "$output_file" 2>&1
        sqlmap_output=$(cat "$output_file") # Capture the output
    else
        sqlmap_output=$(sqlmap -u "$url" 2>&1) # Capture output to variable
        echo "$sqlmap_output"
    fi

    echo -e "${GREEN} SQLmap operation completed.${NC}"

    # Call the function to generate AI insights based on sqlmap output
    generate_ai_insights "$sqlmap_output" "$output_to_file" "$output_file"
}

# Function to run Metasploit
run_metasploit() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/metasploit_output.txt"

    if [[ "$output_to_file" == "y" ]]; then
        sudo msfconsole | tee "$output_file"
    else
        sudo msfconsole
    fi
    echo -e "${GREEN} Metasploit operation completed.${NC}"
}

# Function to run osv-scanner
run_osv_scanner(){
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/osvscanner_output.txt"

    read -p "Enter directory to scan: " directory
    source ~/.bashrc
    if [[ "$output_to_file" == "y" ]]; then
        osv_output=$(osv-scanner --format table --output "$output_file" -r "$directory")
    echo "$osv_output" > "$output"
    else
        osv_output=$(osv-scanner --recursive "$directory")
        osv-scanner --recursive "$directory"
    fi
    generate_ai_insights "$osv_output"
    echo -e "${GREEN} OSV-Scanner Operation completed.${NC}"
}

# Function to run snyk cli
run_snyk(){
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/snyk_output.txt"

    # Check if Snyk is authenticated
	snyk_auth_check=$(snyk auth --help | grep -i "You are authenticated")
	if [[ -z "$snyk_auth_check" ]]; then
		echo -e "${YELLOW}Snyk is not authenticated. Redirecting to browser for authentication...${NC}"
		snyk auth
		# Check if authentication was successful
		if [[ $? -ne 0 ]]; then
			echo -e "${RED}Snyk authentication failed! ${NC}"
			read -p "Would you like to retry authentication? (y/n): " retry
			if [[ "$retry" == "y" ]]; then
				snyk auth
			else
				echo -e "${RED}Snyk authentication failed! ${NC}"
				exit 1
			fi
		else
			echo -e "${GREEN}Snyk authentication successful!${NC}"
		fi
	else
		echo -e "${GREEN}Snyk is already authenticated.${NC}"
	fi
    
    read -p "Select Snyk option:
    1) Run code test locally
    2) Monitor for vulnerabilities and see results in Snyk UI
    Enter your choice (1/2): " snyk_option
    case $snyk_option in
        1)   if [[ "$output_to_file" == "y" ]]; then
                read -p "Enter directory to scan (current directory ./): " directory
                snyk_output=$(snyk code test $directory)
            echo "$snyk_output" > $output_file
                echo -e "${GREEN} SNYK Operation completed.${NC}"
            else
                read -p "Enter directory to scan (current directory ./): " directory
                snyk code test $directory
                snyk_output=$(snyk code test $directory)
                echo -e "${GREEN} SNYK Operation completed.${NC}"
            fi
        ;;
        2) if [[ "$output_to_file" == "y" ]]; then
                read -p "Enter directory to scan (current directory ./): " directory
                snyk_output=$(snyk monitor $directory --all-projects > $output_file)
                echo "$snyk_output" > "$output"
                echo -e "${GREEN} SNYK Operation completed.${NC}"
            else
                snyk_output=$(snyk monitor $directory --all-projects)
                echo -e "${GREEN} SNYK Operation completed.${NC}"
            fi
            echo -e "${GREEN} SNYK Operation completed.${NC}"
        ;;
        *)
            echo -e "${RED}Invalid choice!${NC}"
        ;;
    esac
    generate_ai_insights "$snyk_output"
    echo -e "${GREEN} SNYK Operation completed.${NC}"
}

# Function to run Brakeman
run_brakeman(){
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/brakeman_output.txt"
 
    read -p "Enter directory to scan (current directory ./): " directory
    if [[ "$output_to_file" == "y" ]]; then
        brakeman_output=$(sudo brakeman "$directory" --force  -o "$output_file")
    else
        brakeman_output=$(sudo brakeman "$directory" --force)
        sudo brakeman "$directory" --force
    fi
    generate_ai_insights "$brakeman_output"
    echo -e "${GREEN} Brakeman Operation completed.${NC}"
}

# Function to log messages with a timestamp to the log file
log_message() {
    local message="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $message" >> "$LOG_FILE"
}

# Function to run Wapiti
run_wapiti() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/wapiti_output.txt"

    read -p "Enter the URL to scan: " url

    if [[ "$output_to_file" == "y" ]]; then
        # Run Wapiti scan
        wapiti -u "$url" -o "$output_file"
    else
        # Run Wapiti scan
        wapiti -u "$url"
    fi
    
    echo -e "${GREEN}Wapiti scan completed. Results saved to $output_file.${NC}"
}