#!/bin/bash

#Define the log file location
LOG_FILE="$HOME/automated_scan.log"

> $LOG_FILE

# Function to run Nmap
auto_nmap() {
    echo "Running Nmap..." >> $LOG_FILE
    #this is the nmap scan we want to use, but its slow for testing
    #ai_output=$(nmap -p "$port" --script=http-enum,http-title,http-methods,http-headers,http-server-header -A -T4 "$ip")
    nmap_output_file="$HOME/nmap_scan_output.txt"
    nmap_ai_output=$(nmap "$ip")
    echo "$nmap_ai_output" > "$nmap_output_file"
    echo "$nmap_ai_output" >> $LOG_FILE
    echo "Nmap scan completed." >> $LOG_FILE

}

#Function to run Nikto
auto_nikto() {
    echo "Running Nikto..." >>$LOG_FILE
    nikto_output_file="$HOME/nikto_scan_output.txt"
    nikto_ai_output=$(nikto -h "$ip:$port")
    echo "$nikto_ai_output" > "$nikto_output_file"
    echo "Nikto output saved to $nikto_output_file" >> $LOG_FILE
    echo "Nikto scan completed." >> $LOG_FILE
}

# Function to run OWASP ZAP
auto_zap() {
    echo "Running OWASP ZAP..." >> $LOG_FILE
    #this scan is really resource heavy, maybe try rate limit somehow

    zap_output_file="$HOME/zap_scan_output.txt"
    zap_ai_output=$(zap -quickurl "http://$ip:$port" -cmd)
    echo "zap_ai_output" > "$zap_output_file"
    echo "OWASP ZAP output saved to $zap_output_file" >> $LOG_FILE
    echo "OWASP ZAP scan completed." >> $LOG_FILE
}

# Function to run Wapiti
auto_wapiti() {
    echo "Running Wapiti..." >> $LOG_FILE 
    wapiti_output_file="$HOME/wapiti_scan_output.txt"
    wapiti_ai_output=$(wapiti -u "http://$ip:$port")
    echo "$wapiti_ai_output" > "$wapiti_output_file"
    echo "Wapiti output saved to $wapiti_output_file" >> $LOG_FILE
    echo "Wapiti scan completed." >> $LOG_FILE
}


## we are getting debug output from the ai insights as well                         ##
## to turn this off, find the generate_ai_insights function in the utilities folder ##
## comment out the two lines:                                                       ##
##        echo "Response:"                                                          ##
##        echo "$RESPONSE"                                                          ##

# Run automated scans
run_automated_scan() {
    ## add some input validation here, re prompt user if ip/port are invalid characters or blank
    read -p "Enter the target IP address: " ip
    read -p "Enter the target port: " port
    echo "Starting automated scans for IP: $ip and Port: $port" >> $LOG_FILE

    auto_nmap
    auto_nikto
    ## Uncomment to run zap and wapiti scans, commented out for faster testing ##
    # auto_zap
    # auto_wapiti
    echo "y" | generate_ai_insights "$nmap_ai_output" 
    echo "y" | generate_ai_insights "$nikto_ai_output"
    ## Uncomment to run ai insights on zap and wapiti scans. Currently they dont work ##
    # echo "y" | generate_ai_insights "$zap_ai_output"
    # echo "y" | generate_ai_insights "$wapiti_ai_output"
}

