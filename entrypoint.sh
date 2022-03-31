unitd --no-daemon --control unix:/var/run/control-unit.sock &
curl -X PUT --data-binary @/software/unit.json --unix-socket /var/run/control-unit.sock http://localhost/config &&
certbot certonly --test-cert --webroot --agree-tos -m $EMAIL -n -w /ssl/certbotroot -d $DOMAIN_NAME &&

#Upload Certificate to NGINX Unit
curl -X PUT --data-binary @/etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem --unix-socket /var/run/control-unit.sock http://localhost/certificates/primary

curl -X PUT --data-binary @/software/ssl-config.json --unix-socket /var/run/control-unit.sock http://localhost/config/ssl &&

#Idle Forever
tail -f /dev/null
