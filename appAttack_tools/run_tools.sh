#!/bin/bash 
source utilities.sh
LOG_FILE="$HOME/automated_scan.log"

>$LOG_FILE

# Function to run nmap
run_nmap(){
    OUTPUT_DIR=$1
    isIoTUsage=$2

    output_file="${OUTPUT_DIR}/nmap_output.txt"
    

    echo "running Nmap..." >> $LOG_FILE

    # Prompt user for URL or IP address
    read -p "Enter URL or IP address to scan: " url
    
    # Handle file output and IoT usage
    if [[ "$output_to_file" == "y" ]]; then
        if [[ "$isIoTUsage" == "true" ]]; then
            nmap_ai_output=$(nmap --top-ports 100 -v -iR 100 -oN "$output_file" "$url")
        else
            nmap_ai_output=$(nmap -oN "$output_file" "$url")
        fi
    else
        if [[ "$isIoTUsage" == "true" ]]; then
            nmap_ai_output=$(nmap --top-ports 100 -v -iR 100 "$ul")
    else
            nmap_ai_output=$(nmap "$url")
        fi
        echo "$nmap_ai_output"
        echo "$nmap_ai_output" > "$output_file"
    fi
    echo "$nmap_ai_output" >> "$LOG_FILE"
    echo "Nmap scan completed." >> "$LOG_FILE"
    # Call the generate_ai_insights function with the Nmap output    
    generate_ai_insights "$nmap_ai_output" "$output_to_file" "$output_file" 
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
    echo "Running Nikto..." >> $LOG_FILE
    read -p "Enter URL and port to scan (Example: http://localhost:4200): " url
    if [[ "$output_to_file" == "y" ]]; then
        read -p "Enter the output format (txt, html, xml): " format
        nikto_ai_output=$(nikto -h "$url" -o "$output_file" -Format "$format")
    echo "$nikto_output" > "$output_file"
    else
        nikto_ai_output=$(nikto -h "$url")
        nikto -h "$url"
    fi
    echo "$nikto_ai_output"
    echo "$nikto_ai_output" > "$output_file"
    echo "Nikto output saved to $nikto_output_file" >> $LOG_FILE
    echo "Nikto scan completed." >> $LOG_FILE
    generate_ai_insights "$nikto_ai_output" "$output_to_file" "$output_file"
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
    echo "running OWASP ZAP..." >> $LOG_FILE
    read -p "Enter URL and port to scan (Example: http://localhost:4200): " url

    if [[ "$output_to_file" == "y" ]]; then
        # Show the output on the screen and capture it in a file using 'tee'
        zap -quickurl $url | tee "$output_file" > "$output_file_log.txt"
        zap_ai_output=$(cat "$output_file_log.txt")
    else
        # Just show the output on the screen and capture it in a variable
        zap_ai_output=$(zap -quickurl $url 2>&1)
        echo "$zap_ai_output"
    fi
   auto_zap() {
    echo "Running OWASP ZAP..." >> $LOG_FILE
    zap_output_file="$HOME/zap_scan_output.txt"
    zap_ai_output=$(zap -quickurl "http://$ip:$port" -cmd)
    echo "$zap_ai_output" > "$zap_output_file"
    echo "OWASP ZAP output saved to $zap_output_file" >> $LOG_FILE
    echo "OWASP ZAP scan completed." >> $LOG_FILE
}
    # Call the function to generate AI insights based on OWASP ZAP output
    generate_ai_insights "$zap_ai_output" "$output_to_file" "$output_file"
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
    echo "running Wapiti..." >> $LOG_FILE
    read -p "Enter the URL to scan: " url

    if [[ "$output_to_file" == "y" ]]; then
        # Run Wapiti scan
        wapiti_ai_output=$(wapiti -u "$url" -o "$output_file")
    else
        # Run Wapiti scan
        wapiti_ai_output=$(wapiti -u "$url")
    fi
    echo "$wapiti_ai_output" 
    echo "$wapiti_ai_output" > "$output_file"
    echo "Wapiti output saved to $output_file" >> $LOG_FILE
    echo "Wapiti scan completed." >> $LOG_FILE
    generate_ai_insights "$wapiti_ai_output"
    echo -e "${GREEN}Wapiti scan completed. Results saved to $output_file.${NC}"
}


# Function to run TShark (Wireshark CLI)
run_tshark() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/tshark_output.txt"


    echo -e "${NC}" 
    tshark -D
    echo -e "${NC}"
    read -p "Enter the interface you want to use: " interface
    read -p "Enter how many packets you want to capture: " packets_limit

    echo "Starting Wireshark scan now on interface $interface..."


    # Capture the output of the Wireshark command
    if [[ "$output_to_file" == "y" ]]; then
        tshark_output=$(tshark -i "$interface" -c "$packets_limit")
        echo "$tshark_output" > "$output_file"
    else
        tshark_output=$(tshark -i "$interface" -c "$packets_limit")
        echo -e "${NC}"
        echo "$tshark_output"
    fi
    generate_ai_insights "$tshark_output"
    echo -e "${GREEN} TShark operation completed.${NC}"
}

# Function to run Binwalk
run_binwalk() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/binwalk_output.txt"

    echo -e "${NC}" 
    read -p "Enter the path to the file you want to scan: " path_to_target

    if [[ "$output_to_file" == "y" ]]; then
        binwalk_output=$(binwalk -Y -f "$output_file" "$path_to_target")
    else
        binwalk_output=$(binwalk -Y "$path_to_target")
        echo -e "${NC}"
        echo "$binwalk_output"
    fi
    
    generate_ai_insights "$binwalk_output"
    echo -e "${GREEN}Binwalk scan completed. Results saved to $output_file.${NC}"
}

# Function to run Hashcat
run_hashcat() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/hashcat_output.txt"

    echo -e "${NC}"
    read -p "Enter the hash mode: " hash_mode
    read -p "Enter the attack mode: " attack_mode
    read -p "Enter the hash file path: " hash_file_path
    
    echo -e "${NC}"
    echo -e "${BCyan}Hashcat attack starting..."

    if [[ "$output_to_file" == "y" ]]; then
        hashcat_output=$(hashcat -m "$hash_mode" -a "$attack_mode" -i --increment-min=4 --increment-max=8 "$hash_file_path" ?a?a?a?a?a?a?a?a --outfile "$output_file")
    else
        hashcat_output=$(hashcat -m "$hash_mode" -a "$attack_mode" -i --increment-min=4 --increment-max=8 "$hash_file_path" ?a?a?a?a?a?a?a?a)
        echo -e "${NC}"
        echo "$hashcat_output"
    fi
    
    generate_ai_insights "$hashcat_output"
    echo -e "${GREEN}Hashcat attack complete. Results saved to $output_file.${NC}"
}

# Function to run Aircrack-ng
run_aircrack(){
    output_file="${output}_aircrack"
    read -p "Enter the path to the .cap file: " cap_file
    read -p "Enter the Wi-Fi network's ESSID (optional, press Enter to skip): " essid
    if [[ "$output_to_file" == "y" ]]; then
        if [[ -n "$essid" ]]; then
            aircrack_output=$(aircrack-ng -w "$wordlist" -e "$essid" -l "$output_file" "$cap_file")
        else
            aircrack_output=$(aircrack-ng -w "$wordlist" -l "$output_file" "$cap_file")
        fi
    else
        if [[ -n "$essid" ]]; then
            aircrack-ng -w "$wordlist" -e "$essid" "$cap_file"
        else
            aircrack-ng -w "$wordlist" "$cap_file"
        fi
    fi
    generate_ai_insights "$aircrack_output"
    echo -e "${GREEN}Aircrack-ng operation completed.${NC}"
}

# Function to run Miranda
run_miranda() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/miranda_output.txt"
    
    echo -e "${NC}"
    echo -e "${BCyan}Miranda starting..."

    miranda
    msearch
    host get 0
    host details 0


    if [[ "$output_to_file" == "y" ]]; then
        miranda_output=$(host send 0 WANConnectionDevice WANIPConnection AddPortMapping)
        echo "$miranda_output" > "$output_file"
    else
        miranda_output=$(host send 0 WANConnectionDevice WANIPConnection AddPortMapping)
        echo -e "${NC}"
        echo "$miranda_output"
    fi
    
    generate_ai_insights "$miranda_output"
    echo -e "${GREEN}Miranda testing complete. Results saved to $output_file.${NC}"
}

# Function to run Umap
run_umap() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/umap_output.txt"
    
    echo -e "${NC}"
    echo -e "${BCyan}Umap starting..."

    read -p "Enter your target IP: " target_ip


    if [[ "$output_to_file" == "y" ]]; then
        umap_output=$(umap -c -i "$target_ip")
        echo "$umap_output" > "$output_file"
    else
        umap_output=$(umap -c -i "$target_ip")
        echo -e "${NC}"
        echo "$umap_output"
    fi
    
    generate_ai_insights "$umap_output"
    echo -e "${GREEN}Miranda testing complete. Results saved to $output_file.${NC}"
}


# Function to run Bettercap
run_bettercap() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/bettercap_output.txt"
    read -p "Enter the network interface to use (e.g., wlan0, eth0): " interface
    read -p "Enter the target IP or range (optional, press Enter to skip): " target
    
    if [[ -z "$interface" ]]; then
        echo -e "${RED}No interface provided. Exiting.${NC}"
        return
    fi
    
    if [[ "$output_to_file" == "y" ]]; then
        if [[ -n "$target" ]]; then
            bettercap_output=$(sudo bettercap -iface "$interface" -eval "set arp.spoof.targets $target; arp.spoof on; net.probe on" > "$output_file" 2>&1)
        else
            bettercap_output=$(sudo bettercap -iface "$interface" -eval "net.probe on" > "$output_file" 2>&1)
        fi
    else
        if [[ -n "$target" ]]; then
            sudo bettercap -iface "$interface" -eval "set arp.spoof.targets $target; arp.spoof on; net.probe on"
        else
            sudo bettercap -iface "$interface" -eval "net.probe on"
        fi
    fi
    
    echo -e "${GREEN}Bettercap operation completed.${NC}"
    if [[ "$output_to_file" == "y" ]]; then
        echo -e "${GREEN}Results saved to $output_file.${NC}"
    fi
}

# Function to run Scapy
run_scapy() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/scapy_output.txt"
    echo -e "${CYAN}Launching Scapy interactive shell...${NC}"
    
    read -p "Do you want to save session output to a file? (y/n): " save_to_file
    
    if [[ "$save_to_file" == "y" ]]; then
        echo -e "${YELLOW}Scapy session will be logged to $output_file.${NC}"
        scapy -c "log = open('$output_file', 'w'); exec(input('Scapy> '))" 
        echo -e "${GREEN}Scapy session logged to $output_file.${NC}"
    else
        scapy
    fi
    
    echo -e "${GREEN}Scapy operation completed.${NC}"
}

# Function to run Wifiphisher
run_wifiphisher() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/wifiphisher_output.txt"
    
    echo -e "${CYAN}Launching Wifiphisher...${NC}"
    
    read -p "Enter the network interface to use (e.g., wlan0): " interface
    read -p "Enter the target Wi-Fi network's ESSID (optional, press Enter to skip): " essid
    
    if [[ -z "$interface" ]]; then
        echo -e "${RED}No interface provided. Exiting.${NC}"
        return
    fi
    
    if [[ "$output_to_file" == "y" ]]; then
        if [[ -n "$essid" ]]; then
            wifiphisher_output=$(sudo wifiphisher -i "$interface" --essid "$essid" > "$output_file" 2>&1)
        else
            wifiphisher_output=$(sudo wifiphisher -i "$interface" > "$output_file" 2>&1)
        fi
        echo -e "${GREEN}Wifiphisher operation completed. Results saved to $output_file.${NC}"
    else
        if [[ -n "$essid" ]]; then
            sudo wifiphisher -i "$interface" --essid "$essid"
        else
            sudo wifiphisher -i "$interface"
        fi
        echo -e "${GREEN}Wifiphisher operation completed.${NC}"
    fi
}

# Function to run Reaver
run_reaver() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/reaver_output.txt"
    
    echo -e "${CYAN}Launching Reaver...${NC}"
    
    read -p "Enter the network interface to use (e.g., wlan0): " interface
    read -p "Enter the target BSSID (MAC address of the router): " bssid
    read -p "Enter the Wi-Fi channel (optional, press Enter to skip): " channel
    
    if [[ -z "$interface" || -z "$bssid" ]]; then
        echo -e "${RED}Network interface and BSSID are required. Exiting.${NC}"
        return
    fi
    
    if [[ "$output_to_file" == "y" ]]; then
        if [[ -n "$channel" ]]; then
            reaver_output=$(sudo reaver -i "$interface" -b "$bssid" -c "$channel" -o "$output_file" 2>&1)
        else
            reaver_output=$(sudo reaver -i "$interface" -b "$bssid" -o "$output_file" 2>&1)
        fi
        echo -e "${GREEN}Reaver operation completed. Results saved to $output_file.${NC}"
    else
        if [[ -n "$channel" ]]; then
            sudo reaver -i "$interface" -b "$bssid" -c "$channel"
        else
            sudo reaver -i "$interface" -b "$bssid"
        fi
        echo -e "${GREEN}Reaver operation completed.${NC}"
    fi
}

# Function to run Ncrack
run_ncrack() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/ncrack_output.txt"

    echo -e "${NC}" 
    read -p "Enter the target ip: " target_ip

    if [[ "$output_to_file" == "y" ]]; then
        ncrack_output=$(ncrack -T4 -p 23 "$target_ip" -oN "$output_file")
    else
        ncrack_output=$(ncrack -T4 -p 23 "$target_ip")
        echo -e "${NC}"
        echo "$ncrack_output"
    fi
    
    generate_ai_insights "$ncrack_output"
    echo -e "${GREEN}Ncrack scan completed. Results saved to $output_file.${NC}"
}
