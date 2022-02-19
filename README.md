# Vaultwarden
    
Login to <a href="https://dash.cloudflare.com/">CloudFlare</a>  and add: *Subdomain* for *Vaultwarden*, pointing to your root *Domain*.
```
    A | example.com | YOUR WAN IP
```
```
    CNAME | subdomain | @ (or example.com)
```
---
  
### *Run this command*:
```
RED='\033[0;31m'; echo -ne "${RED}Enter directory name: "; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/Bitwarden.git . && \
chmod +x setup.sh && \
./setup.sh
```
  
#### *Decide what you will use for*:
```
Subdomain for Vaultwarden,
Vaultwarden Port Number.
```
  
#### Command will add *ADMIN_TOKEN* to *.env* file, log in at:
```
https://subdomain.example.com/admin
```
  
### Log:
```
sudo docker-compose logs vaultwarden
sudo docker logs -tf --tail="50" vaultwarden
```
