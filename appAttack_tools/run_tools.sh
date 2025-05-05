#!/bin/bash


# Function to run nmap
run_nmap() {
    OUTPUT_DIR=$1
    isIoTUsage=$2
    output_file="${OUTPUT_DIR}/nmap_output.txt"

    echo -e "${NC}"
    read -p "Enter IP address or network range to scan (e.g., 192.168.1.0/24): " target

    if [[ "$output_to_file" == "y" ]]; then
        if [[ "$isIoTUsage" == "true" ]]; then
            nmap_output=$(nmap --top-ports 100 -v "$target" | tee "$output_file")
        else
            nmap_output=$(nmap -v "$target" | tee "$output_file")
        fi
    else
        if [[ "$isIoTUsage" == "true" ]]; then
            nmap_output=$(nmap --top-ports 100 -v "$target")
        else
            nmap_output=$(nmap -v "$target")
        fi
        echo "$nmap_output"
    fi

    generate_ai_insights "$nmap_output" "$output_to_file" "$output_file" "nmap"
    echo -e "${GREEN}Nmap scan completed.${NC}"
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
    generate_ai_insights "generate_ai_insights "$bandit_output"" "$output_to_file" "$output_file"
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
    generate_ai_insights "generate_ai_insights "$sonarqube_output"" "$output_to_file" "$output_file" "$output_to_file" "$output_file.txt"
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
    generate_ai_insights "generate_ai_insights "$nikto_output"" "$output_to_file" "$output_file"
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
    generate_ai_insights "generate_ai_insights "$legion_output"" "$output_to_file" "$output_file" "$output_to_file" "$output_file"
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
    generate_ai_insights "generate_ai_insights "$zap_output"" "$output_to_file" "$output_file" "$output_to_file" "$output_file"
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
    generate_ai_insights "generate_ai_insights "$john_output"" "$output_to_file" "$output_file" "$output_to_file" "$output_file"
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
    generate_ai_insights "generate_ai_insights "$sqlmap_output"" "$output_to_file" "$output_file" "$output_to_file" "$output_file"
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
    generate_ai_insights "generate_ai_insights "$osv_output"" "$output_to_file" "$output_file"
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
    generate_ai_insights "generate_ai_insights "$snyk_output"" "$output_to_file" "$output_file"
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
    generate_ai_insights "generate_ai_insights "$brakeman_output"" "$output_to_file" "$output_file"
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
        wapiti_output=$(wapiti -u "$url" -o "$output_file")
    else
        # Run Wapiti scan
        wapiti_output=$(wapiti -u "$url")
    fi
    
    generate_ai_insights "generate_ai_insights "$wapiti_output"" "$output_to_file" "$output_file"
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

    if [[ "$output_to_file" == "y" ]]; then
        tshark_output=$(tshark -i "$interface" -c "$packets_limit" 2>&1 | tee "$output_file")
        echo -e "${GREEN}TShark operation completed. Results saved to $output_file.${NC}"
    else
        tshark_output=$(tshark -i "$interface" -c "$packets_limit" 2>&1)
        echo -e "${NC}"
        echo "$tshark_output"
        echo -e "${GREEN}TShark operation completed.${NC}"
    fi

    generate_ai_insights "$tshark_output" "$output_to_file" "$output_file" "wireshark"
}

# Function to run Binwalk
run_binwalk() {
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/binwalk_output.txt"

    echo -e "${NC}"
    read -p "Enter the path to the file you want to scan: " path_to_target

    if [[ ! -f "$path_to_target" ]]; then
        echo -e "${RED}File not found. Please enter a valid path.${NC}"
        return
    fi

    echo -e "${CYAN}Running Binwalk with signature, entropy, and extraction...${NC}"

    if [[ "$output_to_file" == "y" ]]; then
        sudo binwalk --signature -B -e --run-as=root "$path_to_target" > "$output_file"
        binwalk_output=$(cat "$output_file")
    else
        binwalk_output=$(sudo binwalk --signature -B -e --run-as=root "$path_to_target")
        echo -e "${NC}$binwalk_output"
    fi

    generate_ai_insights "generate_ai_insights \"$binwalk_output\"" "$output_to_file" "$output_file"
    echo -e "${GREEN}Binwalk scan complete. Results saved to $output_file.${NC}"
}

# Function to run Hashcat
run_hashcat() {
    OUTPUT_DIR="$1"
    mkdir -p "$OUTPUT_DIR"
    output_file="${OUTPUT_DIR}/hashcat_output.txt"

    echo -e "${NC}"
    read -p "Enter the hash mode (e.g., 0 for MD5, 1000 for NTLM): " hash_mode
    read -p "Enter the attack mode (0 = dictionary, 3 = brute-force): " attack_mode
    read -p "Enter the path to the hash file: " hash_file_path

    if [[ ! -f "$hash_file_path" ]]; then
        echo -e "${RED}Hash file not found. Please check the path and try again.${NC}"
        return
    fi

    read -p "Do you want to save the output to a file? (y/n): " save_to_file

    echo -e "${BCyan}Starting Hashcat...${NC}"

    if [[ "$attack_mode" == "0" ]]; then
        read -p "Enter the path to your wordlist: " wordlist
        if [[ ! -f "$wordlist" ]]; then
            echo -e "${RED}Wordlist not found. Please check the path and try again.${NC}"
            return
        fi

        if [[ "$save_to_file" == "y" ]]; then
            hashcat_output=$(hashcat -m "$hash_mode" -a 0 "$hash_file_path" "$wordlist")
            echo "$hashcat_output" > "$output_file"
        else
            hashcat_output=$(hashcat -m "$hash_mode" -a 0 "$hash_file_path" "$wordlist")
            echo -e "${NC}"
            echo "$hashcat_output"
        fi

    elif [[ "$attack_mode" == "3" ]]; then
        read -p "Enter the brute-force mask (e.g., ?a?a?a?a): " mask

        if [[ "$save_to_file" == "y" ]]; then
            hashcat_output=$(hashcat -m "$hash_mode" -a 3 "$hash_file_path" "$mask")
            echo "$hashcat_output" > "$output_file"
        else
            hashcat_output=$(hashcat -m "$hash_mode" -a 3 "$hash_file_path" "$mask")
            echo -e "${NC}"
            echo "$hashcat_output"
        fi

    else
        echo -e "${RED}Unsupported attack mode. Currently only 0 (dictionary) and 3 (brute-force) are supported.${NC}"
        return
    fi

    generate_ai_insights "$hashcat_output" "$save_to_file" "$output_file" "hashcat"
    echo -e "${GREEN}Hashcat operation complete. Results saved to $output_file.${NC}"
}

# Function to run Aircrack-ng
run_aircrack(){
    OUTPUT_DIR=$1
    output_file="${OUTPUT_DIR}/aircrack_output.txt"

    read -p "Enter the path to the .cap file: " cap_file
    read -p "Enter the path to the wordlist: " wordlist
    read -p "Enter the Wi-Fi network's ESSID (optional, press Enter to skip): " essid

    if [[ "$output_to_file" == "y" ]]; then
        if [[ -n "$essid" ]]; then
            aircrack_output=$(aircrack-ng -w "$wordlist" -e "$essid" -l "$output_file" "$cap_file")
        else
            aircrack_output=$(aircrack-ng -w "$wordlist" -l "$output_file" "$cap_file")
        fi
        echo "$aircrack_output" > "$output_file"
    else
        if [[ -n "$essid" ]]; then
            aircrack_output=$(aircrack-ng -w "$wordlist" -e "$essid" "$cap_file")
        else
            aircrack_output=$(aircrack-ng -w "$wordlist" "$cap_file")
        fi
        echo -e "${NC}"
        echo "$aircrack_output"
    fi

    generate_ai_insights "$aircrack_output" "$output_to_file" "$output_file"
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
    
    generate_ai_insights "generate_ai_insights "$miranda_output"" "$output_to_file" "$output_file"
    echo -e "${GREEN}Miranda testing complete. Results saved to $output_file.${NC}"
}

# Function to run Umap
run_umap() {
    OUTPUT_DIR=$1   #umap is currrently using outdated python 2
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
    
    generate_ai_insights "generate_ai_insights "$umap_output"" "$output_to_file" "$output_file"
    echo -e "${GREEN}Umap testing complete. Results saved to $output_file.${NC}"
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
            wifiphisher_output=$(sudo wifiphisher -i "$interface" --essid "$essid" 2>&1 | tee "$output_file")
        else
            wifiphisher_output=$(sudo wifiphisher -i "$interface" 2>&1 | tee "$output_file")
        fi
        echo -e "${GREEN}Wifiphisher operation completed. Results saved to $output_file.${NC}"
    else
        if [[ -n "$essid" ]]; then
            wifiphisher_output=$(sudo wifiphisher -i "$interface" --essid "$essid" 2>&1)
        else
            wifiphisher_output=$(sudo wifiphisher -i "$interface" 2>&1)
        fi
        echo "$wifiphisher_output"
        echo -e "${GREEN}Wifiphisher operation completed.${NC}"
    fi
    generate_ai_insights "$wifiphisher_output" "$output_to_file" "$output_file" "wifiphisher"
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
    output_file="$HOME/Documents/ncrack_output.txt"

    echo -e "${NC}"
    read -p "Enter the target IP: " target_ip
    if [[ -z "$target_ip" ]]; then
        echo -e "${RED}Target IP cannot be empty.${NC}"
        return
    fi

    read -p "Enter the service port (e.g., 22 for SSH, 21 for FTP): " service_port
    if [[ -z "$service_port" ]]; then
        echo -e "${RED}Service port cannot be empty.${NC}"
        return
    fi

    read -p "Enter the username to try: " username
    if [[ -z "$username" ]]; then
        echo -e "${RED}Username cannot be empty.${NC}"
        return
    fi

    read -p "Enter the password to try: " password
    if [[ -z "$password" ]]; then
        echo -e "${RED}Password cannot be empty.${NC}"
        return
    fi

    echo -e "${CYAN}Running Ncrack against $target_ip on port $service_port...${NC}"

    ncrack_output=$(sudo ncrack -p "$service_port" --user "$username" --pass "$password" -oN "$output_file" "$target_ip")

    echo "$ncrack_output"

    generate_ai_insights "generate_ai_insights \"$ncrack_output\"" "y" "$output_file"

    echo -e "${GREEN}Ncrack scan completed. Results saved to $output_file.${NC}"
}