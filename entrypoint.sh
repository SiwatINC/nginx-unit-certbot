#Start Unit
unitd --no-daemon --control unix:/var/run/control-unit.sock &

#Apply Primary Full Configuration
curl -X PUT --data-binary @/software/unit.json --unix-socket /var/run/control-unit.sock http://localhost/config &&

#Request Certificate
certbot certonly --test-cert --webroot --agree-tos -m $EMAIL -n -w /ssl/certbotroot -d $DOMAIN_NAME &&

#Upload Certificate to NGINX Unit
curl -X PUT --data-binary @/etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem --unix-socket /var/run/control-unit.sock http://localhost/certificates/primary

#Apply SSL Partial Configuration
curl -X PUT --data-binary @/software/ssl-listener.json --unix-socket /var/run/control-unit.sock 'http://localhost/config/listener/*:443' &&

#Idle Forever
tail -f /dev/null
