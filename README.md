<p align="left">
  <a href="https://github.com/vdarkobar/home-cloud">Home</a>
  <br><br>
</p> 
  
# Vaultwarden
    
Login to <a href="https://dash.cloudflare.com/">CloudFlare</a> and add: *Subdomain* for *Vaultwarden*, pointing to your *root Domain*.
  
> CNAME | subdomain | @ (or example.com)
  
example:
  
> CNAME | pass | @ (or example.com)
  
  
#### *Decide what you will use for*:
  
> Directory name, Domain name of your website, Vaultwarden Subdomain and Port Number.  
  
### *Run this command*:
```bash
RED='\033[0;31m'; NC='\033[0m'; echo -ne "${RED}Enter directory name: ${NC}"; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/Vaultwarden.git . && \
chmod +x setup.sh && \
./setup.sh
```
  
#### Command will add *ADMIN TOKEN* to *.env* file, used to log in at:
```
https://subdomain.example.com/admin
```
  
### Log:
```bash
sudo docker compose logs vaultwarden
sudo docker logs -tf --tail="50" vaultwarden
```
  
#### Vaultwarden: <i><a href="https://github.com/dani-garcia/vaultwarden/wiki">Features</a></i>  
> *Enable Websockets Support.*  
> *Change: SIGNUPS_ALLOWED=true, to false after first login and rebuild containers.*  

to continue setup > your reverse proxy ...
