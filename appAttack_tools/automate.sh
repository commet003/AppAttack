#!/bin/bash


# Function to run Nmap
auto_nmap() {
    echo "Running Nmap..."
    #this is the nmap scan we want to use, but its slow for testing
    #ai_output=$(nmap -p "$port" --script=http-enum,http-title,http-methods,http-headers,http-server-header -A -T4 "$ip")
    nmap_ai_output=$(nmap "$ip")
    nmap "$ip"
    echo "Nmap scan completed."

}

#Function to run Nikto
auto_nikto() {
    echo "Running Nikto..."
    nikto_ai_output=$(nikto -h "$ip:$port")
    nikto -h "$ip"
    echo "Nikto scan completed."
}

# Function to run OWASP ZAP
auto_zap() {
    echo "Running OWASP ZAP..."
    #this scan is really resource heavy, maybe try rate limit somehow
    zap_ai_output=$(zap -quickurl "http://$ip:$port" -cmd)
    echo "zap_ai_output"
    echo "OWASP ZAP scan completed."
}

# Function to run Wapiti
auto_wapiti() {
    echo "Running Wapiti..."
    wapiti_ai_output=$(wapiti -u "http://$ip:$port")
    echo "Wapiti scan completed."
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
    echo "Starting automated scans for IP: $ip and Port: $port"

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

