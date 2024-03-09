#!/bin/bash

clear

######################################################
# Define ANSI escape sequences for colors and reset  #
######################################################

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


#################
# Intro message #
#################

echo
echo -e "${GREEN} Before you begin:${NC}"
echo
echo -e "${GREEN} Login to${NC} CloudFlare ${GREEN}and set Subdomain for your Vaultwarden:${NC}"
echo
echo "      CNAME |  subdomain  | @ (or example.com)"
echo
echo 
echo -e "${GREEN} Decide what you will use for:${NC}"
echo
echo "      - Domain name of your website, Vaultwarden Subdomain and Port Number"
echo
echo

while true; do
    echo -e "${GREEN} Continue? ${NC} (yes/no)"
    echo
    read choice
    echo

    # Convert choice to lowercase
    choice=${choice,,} # This makes the script case insensitive

    # Check if user entered "yes"
    if [[ "$choice" == "yes" || "$choice" == "y" ]]; then

        # Execute first command and echo -e message when done
        echo
        clear
        echo -e "${GREEN} Executing script... ${NC}"
        echo
        break

    # If user entered "no"
    elif [[ "$choice" == "no" || "$choice" == "n" ]]; then
        echo -e "${RED} Aborting script. ${NC}"
        exit

    # If user entered anything else, ask them to correct it
    else
        echo
        echo -e "${YELLOW} Invalid input. Please enter${NC} 'yes' or 'no'"
    fi
done

###########################################
# Function for displaying status messages #
###########################################

status_message() {
  local status="$1"  # "success", "error"
  local message="$2"
  local color="${GREEN}" # Default to success (green)

  if [[ $status == "error" ]]; then
    color="${RED}"
  fi

  echo -e "${color}${message}${NC}"
}


#########################################
# Function to check command exit status #
#########################################

check_exit_status() {
  if [[ $1 -ne 0 ]]; then
    status_message "error" "$2"
    exit 1
  fi
}


#######################################################
# Start the installation of Docker and Docker Compose #
#######################################################

echo
echo -e "${GREEN}Starting the installation of Docker and Docker Compose (v2)...${NC}"
echo

# Update apt package index
sudo apt-get update
check_exit_status $? "Failed to update apt package index."

# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg lsb-release
check_exit_status $? "Failed to install prerequisites."

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
check_exit_status $? "Failed to add Docker GPG key."

# Set up the Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
check_exit_status $? "Failed to set up the Docker repository."

# Update the apt package index again
sudo apt-get update
check_exit_status $? "Failed to update package index after setting up the repository."

# Install Docker Engine, CLI, containerd, and Compose plugin
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
check_exit_status $? "Failed to install Docker."

# Verify installation
sudo docker --version && docker compose version
check_exit_status $? "Docker installation might have issues."

clear
echo
echo -e "${GREEN}Docker and Docker Compose(v2) installation completed successfully.${NC}"
echo


###############
# Vaultwarden #
###############

echo -ne "${GREEN}Enter Domain name (e.g. example.com): ${NC}"; read DNAME
echo

echo -ne "${GREEN}Enter Vaultwarden Subdomain:${NC} "; read SDNAME
echo

echo -ne "${GREEN}Enter Vaultwarden Port Number(49152-65535):${NC} "; read VWPORTN;
# Check if the port number is within the specified range
while [[ $VWPORTN -lt 49152 || $VWPORTN -gt 65535 ]]; do
    echo -e "${RED}Port number is out of the allowed range. Please enter a number between 49152 and 65535.${NC}"
    echo -ne "${GREEN}Enter valid Vaultwarden Port Number(49152-65535):${NC} "; read VWPORTN;
done

echo

#echo -ne "${RED}Enter Domain name: "; read DNAME; \
#echo -ne "${RED}Enter Vaultwarden Subdomain: "; read SDNAME; \
#echo -ne "${RED}Enter Vaultwarden Port Number (VWPORTN:80): "; read VWPORTN; \

sed -i "s|01|${DNAME}|" .env && \
sed -i "s|02|${SDNAME}|" .env && \
sed -i "s|03|${VWPORTN}|" .env && \
rm README.md && \
TOKEN=$(openssl rand -base64 48); sed -i "s|CHANGE_ADMIN_TOKEN|${TOKEN}|" .env

# Main loop for docker compose up command
while true; do
    echo -ne "${GREEN}Execute docker compose now?${NC} (yes/no) "; read yn
    echo
    yn=$(echo "$yn" | tr '[:upper:]' '[:lower:]') # Convert input to lowercase
    case $yn in
        yes )
            if ! sudo docker compose up -d; then
                echo -e "${RED}Docker compose up failed. Check docker and docker compose installation.${NC}";
                exit 1;
            fi
            break;;
        no ) exit;;
        * ) echo -e "${RED}Please answer${NC} yes or no";;
    esac
done


#######
# UFW #
#######
echo
echo -e "${GREEN}Preparing firewall for local access...${NC}"
sleep 0.5 # delay for 0.5 seconds
echo

# Use the PORTN variable for the UFW rule
sudo ufw allow "${VWPORTN}/tcp" comment "Vaultwarden custom port"
sudo systemctl restart ufw
echo


##########
# Access #
##########
clear
echo -e "${GREEN}Access Vaultwarden instance at${NC}"
sleep 0.5 # delay for 0.5 seconds

# Get the primary local IP address of the machine more reliably
LOCAL_IP=$(ip route get 1.1.1.1 | awk '{print $7; exit}')
# Get the short hostname directly
HOSTNAME=$(hostname -s)
# Use awk more efficiently to extract the domain name from /etc/resolv.conf
DOMAIN_LOCAL=$(awk '/^search/ {print $2; exit}' /etc/resolv.conf)
# Directly concatenate HOSTNAME and DOMAIN, leveraging shell parameter expansion for conciseness
LOCAL_DOMAIN="${HOSTNAME}${DOMAIN_LOCAL:+.$DOMAIN_LOCAL}"

# Display access instructions
echo
echo -e "${GREEN} Local access:${NC} $LOCAL_IP:$VWPORTN"
echo -e "${GREEN}             :${NC} $LOCAL_DOMAIN:$VWPORTN"
echo
echo -e "${GREEN} External access:${NC} $SDNAME.$DNAME"
echo
echo
echo -e "${GREEN} Set Vaultwarden external url in the Vaultwarden browser extension:${NC}"
echo -e "${RED} Configure Reverse proxy (NPM) for external access.${NC}"
echo


#####################################
# Remove the Script from the system #
#####################################
echo
echo -e "${RED} This Script Will Self Destruct!${NC}"
echo
# VERY LAST LINE OF THE SCRIPT:
sudo rm "$0"
