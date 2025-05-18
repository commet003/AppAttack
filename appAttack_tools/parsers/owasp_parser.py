import sys
import re
import json

# Parses OWASP ZAP text output to extract basic info and alerts
def parse_zap_output(text):
    alerts = []
    scanned_url = ""

    lines = text.splitlines()
    current_alert = None

    for line in lines:
        line = line.strip()

        # Extract scanned URL
        if line.startswith("URL:"):
            scanned_url = line.split("URL:")[-1].strip()

        # Start of a new alert block
        if line.startswith("Alert:"):
            if current_alert:
                alerts.append(current_alert)
            current_alert = {"alert": line.split("Alert:")[-1].strip()}
        elif current_alert:
            # Add details to current alert
            if line.startswith("Risk:"):
                current_alert["risk"] = line.split("Risk:")[-1].strip()
            elif line.startswith("Description:"):
                current_alert["description"] = line.split("Description:")[-1].strip()
            elif line.startswith("Solution:"):
                current_alert["solution"] = line.split("Solution:")[-1].strip()

    # Append the last alert
    if current_alert:
        alerts.append(current_alert)

    parsed = {
        "scanned_url": scanned_url,
        "alerts": alerts
    }
    return parsed

# Generates a prompt from parsed ZAP data
def generate_prompt(data):
    prompt = f"Analyze this OWASP ZAP scan report for the web application at {data.get('scanned_url', 'unknown')}:\n"

    if not data["alerts"]:
        prompt += "- No vulnerabilities or alerts were found.\n"
    else:
        prompt += "- The following alerts were detected:\n"
        for alert in data["alerts"]:
            prompt += f"  - Alert: {alert.get('alert')}\n"
            prompt += f"    - Risk Level: {alert.get('risk')}\n"
            if 'description' in alert:
                prompt += f"    - Description: {alert.get('description')}\n"
            if 'solution' in alert:
                prompt += f"    - Suggested Fix: {alert.get('solution')}\n"

        prompt += "\nPlease provide security insights, possible exploit impacts, and mitigation recommendations."

    return prompt

# Main execution block
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python zap_parser.py <zap_output_file>")
        sys.exit(1)

    with open(sys.argv[1], "r", encoding="utf-8") as f:
        content = f.read()

    parsed_data = parse_zap_output(content)
    prompt = generate_prompt(parsed_data)

    print(json.dumps({
        "prompt": prompt,
        "parsed_data": parsed_data
    }, indent=2))
