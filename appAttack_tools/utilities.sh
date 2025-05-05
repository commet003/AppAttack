#!/bin/bash
# Define the log file path where the script logs messages
LOG_FILE="$HOME/security_tools.log"

install_generate_ai_insights_dependencies() {
    # Check if jq is installed
    if ! command -v jq &> /dev/null; then
        echo -e "${MAGENTA}Intalling generate AI insights dependencies...${NC}"
        
        # Update package list and install jq
        sudo apt-get update
        sudo apt-get install -y jq
    else
        echo -e "${GREEN}Generate AI insights dependencies are already installed.${NC}"
    fi
}

# Function to save vulnerabilities found by various tools to a file
save_vulnerabilities() {
    # Set the tool name to the first argument
    local tool=$1
    # Set the output file name based on the tool name
    local output_file="$tool-vulnerabilities.txt"
    # Determine the command to run based on the tool name
    case $tool in
        "osv-scanner")
            # Scan the directory using osv-scanner and save output to the file
            osv-scanner scan "./$directory" > "$output_file"
        ;;
        "snyk")
            # Run snyk code scan and save output to the file
            snyk code scan > "$output_file"
        ;;
        "brakeman")
            # Run brakeman scan and save output to the file
            sudo brakeman --force > "$output_file"
        ;;
        "nmap")
            # Run nmap scan and save output to the file
            nmap -v -A "$url" > "$output_file"
        ;;
        "nikto")
            # Run nikto scan and save output to the file
            nikto -h "$url" > "$output_file"
        ;;
        "legion")
            # Run legion scan and save output to the file
            legion "$url" > "$output_file"
        ;;
        "john")
            # Run John the Ripper and save output to the file
            john --show --format=raw-md5 "$input_file" > "$output_file"
        ;;
        "sqlmap")
            # Run SQLmap scan and save output to the file
            sqlmap -u "$url" --batch --output-dir="$output_dir" > "$output_file"
        ;;
        "metasploit")
            # Run Metasploit scan and save output to the file
            msfconsole -x "use auxiliary/scanner/portscan/tcp; set RHOSTS $url; run; exit" > "$output_file"
        ;;
	"wapiti")
            # Run Wapiti scan and save output to the file
            wapiti -u "$url" -o "$output_file"
        ;;
        *)
            echo -e "${RED}Unsupported tool: $tool${NC}"
            return 1
        ;;
    esac
    # Display the found vulnerabilities
    echo -e "${GREEN}Vulnerabilities found:${NC}"
    cat "$output_file"
    # Prompt user to save the vulnerabilities to a file
    read -p "Do you want to save the vulnerabilities to a file? (y/n) " save_to_file
    if [[ "$save_to_file" == "y" ]]; then
        # Display message indicating the file has been saved
        echo -e "${GREEN}Vulnerabilities saved to $output_file${NC}"
    else
        # Display message indicating the file was not saved
        echo -e "${GREEN}Vulnerabilities not saved to a file.${NC}"
    fi
}

# Function to get and print AI-generated insights based on tool outputs
generate_ai_insights() {
    local output="$1" # Tool output
    local output_to_file="$2" # Output to file (either y or n)
    local output_file="$3" # Output file directory
    
    read -p "Do you want to get AI-generated insights on the scan? (y/n): " ai_insights

    if [[ "$ai_insights" == "y" ]]; then
        # Use existing Google Gemini API key or replace with your own one
        API_KEY="AIzaSyD2T9-vTk4Qf_LCx6kw1oNgHuGbKvGoNQ8"

        # Escape special characters in the output to safely include it in JSON
        escaped_output=$(echo "$output" | sed 's/"/\\"/g' | sed "s/'/\\'/g")

        # Format the data for the Gemini API
        PROMPT="Analyze this output and provide insights: $escaped_output"
        
        # Call Gemini API using curl
        RESPONSE=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
            "contents": [
              {
                "parts": [
                  {
                    "text": "'"$PROMPT"'"
                  }
                ]
              }
            ]
        }')
        
        # Uncomment below for debugging
        #echo "Response:"
        #echo "$RESPONSE"
        
        # Extract the insights from the API response
        INSIGHTS=$(echo $RESPONSE | jq -r '.candidates[0].content.parts[0].text')
        
        # Append the AI-generated insights to the output file if saved to file
        if [[ "$output_to_file" == "y" ]]; then
            echo -e "\nAI-Generated Insights:\n$INSIGHTS" >> "$output_file"
        else
            # Display the AI-generated insights
            #display_asterisk
            echo -e "${YELLOW}"
            echo -e "+-----------------------------+"
            echo -e "|          Insights           |"
            echo -e "+-----------------------------+"
            echo -e "${BLUE}"
            echo -e "$INSIGHTS"
            echo -e "${NC}"
            echo -e "${YELLOW}"
            echo -e "+-----------------------------+"

            #display_asterisk
        fi
    fi
}
