import sys
import re
import json

# Strip ANSI color codes
def remove_ansi_codes(text):
    ansi_escape = re.compile(r'\x1B[@-_][0-?]*[ -/]*[@-~]')
    return ansi_escape.sub('', text)

# Extract module stats from clean output
def parse_metasploit_output(text):
    data = {}

    clean_text = remove_ansi_codes(text)

    filtered_lines = []
    for line in clean_text.splitlines():
        # Remove trailing/leading whitespace
        line = line.strip()

        # Skip file listings or garbage
        if not line:
            continue
        if re.search(r"\.(sh|md|txt|zip|LICENSE|log|json)", line, re.IGNORECASE):
            continue
        if re.search(r"john_.*|nmap_.*|README|update-golang", line, re.IGNORECASE):
            continue

        # Only keep lines that look like useful Metasploit output
        if re.search(r'(exploits|payloads|evasion|Metasploit Documentation|SSH|Scanned|module execution)', line):
            filtered_lines.append(line)

    core_output = "\n".join(filtered_lines)

    # Extract statistics like before
    match1 = re.search(r'(\d+)\s+exploits\s+-\s+(\d+)\s+auxiliary\s+-\s+(\d+)\s+post', core_output)
    match2 = re.search(r'(\d+)\s+payloads\s+-\s+(\d+)\s+encoders\s+-\s+(\d+)\s+nops', core_output)
    match3 = re.search(r'(\d+)\s+evasion', core_output)

    if match1:
        data['exploits'] = int(match1.group(1))
        data['auxiliary'] = int(match1.group(2))
        data['post'] = int(match1.group(3))
    if match2:
        data['payloads'] = int(match2.group(1))
        data['encoders'] = int(match2.group(2))
        data['nops'] = int(match2.group(3))
    if match3:
        data['evasion'] = int(match3.group(1))

    return data


# Create a user-friendly AI prompt
def generate_prompt(data):
    prompt = "This is a summary of the available modules in Metasploit Framework:\n\n"
    prompt += f"- {data.get('exploits', 0)} exploits\n"
    prompt += f"- {data.get('auxiliary', 0)} auxiliary modules\n"
    prompt += f"- {data.get('post', 0)} post-exploitation modules\n"
    prompt += f"- {data.get('payloads', 0)} payloads\n"
    prompt += f"- {data.get('encoders', 0)} encoders\n"
    prompt += f"- {data.get('nops', 0)} NOP generators\n"
    prompt += f"- {data.get('evasion', 0)} evasion modules\n\n"

    prompt += (
        "Please explain in simple, beginner-friendly language what each of these modules does, "
        "how they are typically used in penetration testing, and what someone new to Metasploit should know about them."
    )
    return prompt

# Main execution
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python metasploit_parser.py <metasploit_output_file>")
        sys.exit(1)

    with open(sys.argv[1], "r", encoding="utf-8") as f:
        raw_text = f.read()

    parsed_data = parse_metasploit_output(raw_text)
    prompt = generate_prompt(parsed_data)

    output = {
        "prompt": prompt,
        "parsed_data": parsed_data
    }

    print(json.dumps(output, indent=2))
