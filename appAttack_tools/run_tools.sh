#!/bin/bash


# Function to run nmap
run_nmap(){
    output_file="${output}_nmap"
    read -p "Enter URL or IP address to scan: " url
    if [[ "$output_to_file" == "y" ]]; then
        nmap_output=$(nmap -oN "$output_file" "$url")
    else
        nmap_output=$(nmap "$url")
        nmap "$url"
    fi
    generate_ai_insights "$nmap_output"
    echo -e "${GREEN} Nmap Operation completed.${NC}"
}

# Function to run Bandit
run_bandit() {
    output_file="${output}_bandit.txt"
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
    output_file="${output}_sonarqube"

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
    output_file="${output}_nikto"
    read -p "Enter URL and port to scan (Example: http://localhost:4200): " url
    if [[ "$output_to_file" == "y" ]]; then
        read -p "Enter the output format (txt, html, xml): " format
        nikto_output=$(nikto -h "$url" -o "$output_file" -Format "$format")
    echo "$nikto_output" > "$output"
    else
        nikto_output=$(nikto -h "$url")
        nikto -h "$url"
    fi
    generate_ai_insights "$nikto_output"
    echo -e "${GREEN} Nikto Operation completed.${NC}"
}



# Function to run LEGION
run_legion() {
    output_file="${output}_legion"

    if [[ "$output_to_file" == "y" ]]; then
        # Show the output on the screen and capture it in a file using 'tee'
        sudo legion | tee "$output_file.txt" > "$output_file_log.txt"
        legion_output=$(cat "$output_file_log.txt")
    else
        # Just show the output on the screen and capture it in a variable
        legion_output=$(sudo legion 2>&1)
        echo "$legion_output"
    fi

    # Call the function to generate AI insights based on Legion output
    generate_ai_insights "$legion_output" "$output_to_file" "$output_file.txt"
    echo -e "${GREEN} Legion operation completed.${NC}"


}


# Function to run OWASP ZAP
run_owasp_zap() {
    output_file="${output}_zap"
    read -p "Enter URL and port to scan (Example: http://localhost:4200): " url

    if [[ "$output_to_file" == "y" ]]; then
        # Show the output on the screen and capture it in a file using 'tee'
        zap -quickurl $url | tee "$output_file.txt" > "$output_file_log.txt"
        zap_output=$(cat "$output_file_log.txt")
    else
        # Just show the output on the screen and capture it in a variable
        zap_output=$(zap -quickurl $url 2>&1)
        echo "$zap_output"
    fi
    # Call the function to generate AI insights based on OWASP ZAP output
    generate_ai_insights "$zap_output" "$output_to_file" "$output_file.txt"
    echo -e "${GREEN} OWASP ZAP Operation completed.${NC}"


}



# Function to run John the Ripper
run_john() {
    output_file="${output}_john"
    read -p "Enter the path to the password file to crack: " password_file

    if [[ "$output_to_file" == "y" ]]; then
        # Capture the output of john to a file
        john --session="$output_file" "$password_file" > "$output_file.txt" 2>&1
        john_output=$(cat "$output_file.txt")
    else
        # Capture the output of john to a variable
        john_output=$(john "$password_file" 2>&1)
        echo "$john_output"
    fi

    # Call the function to generate AI insights based on John the Ripper output
    generate_ai_insights "$john_output" "$output_to_file" "$output_file.txt"
    echo -e "${GREEN} John the Ripper operation completed.${NC}"


}


# Function to run sqlmap
run_sqlmap() {
    output_file="${output}_sqlmap"
    read -p "Enter URL to scan (e.g., http://example.com/vuln.php?id=1): " url

    if [[ "$output_to_file" == "y" ]]; then
        sqlmap -u "$url" --output-dir="$output_file" > "$output_file/sqlmap_output.txt" 2>&1
        sqlmap_output=$(cat "$output_file/sqlmap_output.txt") # Capture the output
    else
        sqlmap_output=$(sqlmap -u "$url" 2>&1) # Capture output to variable
        echo "$sqlmap_output"
    fi

    echo -e "${GREEN} SQLmap operation completed.${NC}"

    # Call the function to generate AI insights based on sqlmap output
    generate_ai_insights "$sqlmap_output" "$output_to_file" "$output_file/sqlmap_output.txt"
}

# Function to run Metasploit
run_metasploit() {
    output_file="${output}_metasploit"
    if [[ "$output_to_file" == "y" ]]; then
        sudo msfconsole | tee "$output_file.txt"
    else
        sudo msfconsole
    fi
    echo -e "${GREEN} Metasploit operation completed.${NC}"
}

# Function to run osv-scanner
run_osv_scanner(){
    output_file="${output}_osv_scanner"
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
    output_file="${output}_snyk"

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
    output_file="${output}_brakeman"
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
    read -p "Enter the URL to scan: " url
    read -p "Enter the output file path: " output_file
    
    # Run Wapiti scan
    wapiti -u "$url" -o "$output_file"
    
    echo -e "${GREEN}Wapiti scan completed. Results saved to $output_file.${NC}"
}
