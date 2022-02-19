# Vaultwarden
  
<p align="left">
  <a href="https://github.com/vdarkobar/Home_Cloud#small-home-cloud">Home</a> |
  <a href="https://github.com/vdarkobar/NextCloud#nextcloud">NextCloud</a> |
  <a href="https://github.com/vdarkobar/WordPress#wordpress">WordPress</a> |
  <a href="https://github.com/vdarkobar/Ghost-blog#ghost-blog">Ghost-blog</a> |
  <a href="https://github.com/vdarkobar/Portainer">Portainer</a>  
  <br><br>
</p>  
  
Login to <a href="https://dash.cloudflare.com/">CloudFlare</a>  and add: *Subdomain* for Vaultwarden, pointing to your root *Domain*.
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
