#!/bin/bash

# Configuration
API_KEY="AIzaSyBAR-3N6lr-XtE-faIfprOIVEy0_ybbvlA"
API_URL="https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
LOG_FILE="./debug.log"

# Prompt generator (accuracy-focused)
generate_gemini_prompt() {
    local tool_name="$1"
    local description="$2"
    local scan_output="$3"

    cat <<EOF
{
    "contents": [
        {
            "parts": [
                {
                    "text": "You are a cybersecurity analyst assistant. Your task is to summarize real scan results from the tool below. Do not guess, add assumptions, or invent data.\n\nTool Used: $tool_name\nDescription: $description\n\nScan Output:\n$scan_output\n\nPlease respond in **this exact plain text format**, no bold or formatting:\n\nThreats: <summary of threats>\nWhy it Matters: <summary of risk>\nAction Needed: <summary of recommendation>\n\nImportant:\n- DO NOT use any formatting like markdown (**), colors, or escape codes\n- DO NOT return any \\\\033[...], \\\\x1B, or ANSI color\n- Just return clean plain text, 1 line per section"
                }
            ]
        }
    ]
}
EOF
}

# Gemini API call
generate_ai_insights() {
    local tool="$1"
    local description="$2"
    local scan_output="$3"

    # Style definitions
    BOLD=$(tput bold)
    NORMAL=$(tput sgr0)
    GREEN="\033[1;32m"
    CYAN="\033[1;36m"
    YELLOW="\033[1;33m"
    RESET="\033[0m"

    echo "[INFO] Preparing prompt for Gemini ($tool)" >> "$LOG_FILE"

    PROMPT=$(generate_gemini_prompt "$tool" "$description" "$scan_output")

    RESPONSE=$(curl -s -X POST "$API_URL?key=$API_KEY" \
        -H "Content-Type: application/json" \
        -d "$PROMPT")

    echo "[DEBUG] Gemini API response:" >> "$LOG_FILE"
    echo "$RESPONSE" >> "$LOG_FILE"

    INSIGHTS=$(echo "$RESPONSE" | jq -r '.candidates[0].content.parts[0].text')
    [[ -z "$INSIGHTS" || "$INSIGHTS" == "null" ]] && INSIGHTS="No actionable insights."

    # Print formatted AI insight block
    echo -e "\n${CYAN}+-----------------------------+"
    echo -e "|        ${BOLD}AI Insights${NORMAL}${CYAN}          |"
    echo -e "+-----------------------------+${RESET}"
    echo -e "${BOLD}Tool Used:${NORMAL} $tool"
    echo -e "${BOLD}Description:${NORMAL} $description"
    echo -e "\n${YELLOW}${BOLD}Generated Insights:${NORMAL}${RESET}"

    # Highlight markdown-style sections
    echo -e "$INSIGHTS" | sed -E "s/\*\*Threats:\*\*/${BOLD}${GREEN}Threats:${RESET}/g" \
                   | sed -E "s/\*\*Why it Matters:\*\*/${BOLD}${CYAN}Why it Matters:${RESET}/g" \
                   | sed -E "s/\*\*Action Needed:\*\*/${BOLD}${YELLOW}Action Needed:${RESET}/g"

    echo -e "${CYAN}+-----------------------------+${RESET}"
}
