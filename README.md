## Installation For Users
1. **Clone the Repository**:
   ```bash
   git clone -b Tool-Development https://github.com/Siwei502/AppAttack.git
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


## For Devs
You're better off running ./main for testing additions to the tool. Otherwise you have to rebuild it each time to test. Make sure you also reinstall to make sure the install process isn't broken. 

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


