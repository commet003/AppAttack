import sys
import re
import json

# Parses Nmap text output to extract host and open ports
def parse_nmap_output(text):
    ports = []
    host = ""

    lines = text.splitlines()
    for line in lines:
        # Extract hostname/IP from the report line
        if "Nmap scan report for" in line:
            host = line.split("for")[-1].strip()

        # Use regex to find lines indicating open TCP ports
        match = re.match(r"^(\d+/tcp)\s+open\s+(\S+)", line)
        if match:
            port, service = match.groups()
            ports.append({
                "port": port,
                "service": service
            })

    # Structure the parsed data
    parsed = {
        "host": host,
        "open_ports": ports
    }

    return parsed

# Generates a text prompt based on the parsed Nmap data
def generate_prompt(data):
    prompt = f"Analyze this Nmap scan report for host {data.get('host', 'unknown')}:\n"
    if not data["open_ports"]:
        prompt += "- No open ports were found.\n"
    else:
        prompt += "- The following ports are open:\n"
        # List each open port and its service
        for p in data["open_ports"]:
            prompt += f"  - Port: {p['port']}, Service: {p['service']}\n"
        prompt += "\nPlease provide insights, possible vulnerabilities, and recommendations."

    return prompt

# Main execution block
if __name__ == "__main__":
    # Check for command-line argument (filename)
    if len(sys.argv) < 2:
        print("Usage: python nmap_parser.py <nmap_output_file>")
        sys.exit(1)

    # Read the Nmap output file
    with open(sys.argv[1], "r") as f:
        content = f.read()

    # Parse the file content
    parsed_data = parse_nmap_output(content)
    # Generate the analysis prompt
    prompt = generate_prompt(parsed_data)

    # Print the generated prompt and parsed data as JSON
    print(json.dumps({
        "prompt": prompt,
        "parsed_data": parsed_data
    }, indent=2))