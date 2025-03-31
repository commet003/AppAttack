<<<<<<< HEAD
=======
Test file

>>>>>>> b71ccc8 (ReadMe Test File)
## Installation For Users
1. **Clone the Repository**:
   ```bash
   git clone -b Tool-Development https://github.com/Hardhat-Enterprises/AppAttack.git
   ```
2. **Move into the appAttack_tools directory**:
   ```bash
   cd AppAttack/appAttack_tools
   ```
3. **Run the install script as sudo**:
   ```bash
   sudo ./install.sh
   ```
4. **You can now start the tool using**:
   ```bash
   appAttack_toolkit
   ```

<<<<<<< HEAD
- The Learning resources are available under the Documentation Branch.
- All the Company Tasks for T2 2024 are under Company Task Branch.
- All the vulnerabilities ready for verification are under the Workflow Verify Finding Branch.
- All the verified vulnerabilities needing minor changes are under the Workflow Ensure Presentability Branch.
- All the verified vulnerabilities part of the Mid-Trimester Report are under the Workflow Ready for Final Report Branch.
=======
>>>>>>> 2375ebe0766b4122353fa8c4315b5ed325562057

## For Devs
You're better off running ./main.sh for testing additions to the tool. Otherwise you have to rebuild it each time to test. Make sure you also reinstall to make sure the install process isn't broken. 

### To reinstall 
1. **Remove the original installation**:
   > *This isn't strictly necessary all the time, but it's just simpler to always do it.*
   ```bash
   sudo rm -rf /opt/appAttack_toolkit
   sudo rm /usr/local/bin/appAttack_toolkit

2. **Reinstall**:
   ```bash
   sudo ./install.sh
   ```

<br />
<br />

**FLOW**

1. Run the tool by following the instructions above.
2. The script will download all necessary files.
3. When prompted, indicate whether you want to update by typing y (yes) or n (no).
4. Specify the tool you want to run when asked.
5. Provide the path to the folder containing the code that needs to be tested.
6. The generated results will be stored in a text file located at /home/kali.

<br />

**Available Tools**

1. osv-scanner: A tool that scans your project dependencies for known vulnerabilities using the Open Source Vulnerability database.
2. Snyk: A tool that scans your projects for vulnerabilities and provides fixes to enhance security in code, dependencies, containers, and infrastructure as code.
3. Brakeman:  It detect security vulnerabilities, providing detailed reports to help developers fix issues before deployment.
4. Nmap : It is a network scanning tool used for discovering hosts, services, and vulnerabilities on a network.
5. Nikto : It is a web server scanner that checks for vulnerabilities, outdated software, and misconfigurations.
6. Owasp zap : Its a web application security scanner used to find vulnerabilities in web applications during development and testing.
7. Aircrack-ng: Used for WEP, WPA PSK cracking, de-authentication and replay attacks.
8. Bettercap: A WiFi, BLE, HID, and Ethernet reconnaissance tool.
9. Binwalk: Use to analyse or extract firmware from an IoT device.
10. Hashcat: A fast password recovery and cracking tool.
11. Miranda: A tool used to attack UPnP devices.
12. Ncrack: A network authentication cracking tool.
13. Reaver: Used to conduct brute force attacks against WPS PINs.
14. Scapy: A tool for crafting, decoding, and forging packets for a variety of network protocols.
15. Umap: Used to attack UPnP devices via the WAN interface.
16. Wifiphisher: Rouge access point framework used to conduct man-in-the-middle attacks.
17. Wireshark: A network packet capture and analysis tool.
