#Start Unit
unitd --no-daemon --control unix:/var/run/control-unit.sock &

#Apply Primary Full Configuration
curl -X PUT --data-binary @/software/unit.json --unix-socket /var/run/control-unit.sock http://localhost/config &&

#Request Certificate
certbot certonly --test-cert --webroot --agree-tos -m $EMAIL -n -w /ssl/certbotroot -d $DOMAIN_NAME &&

#Construct and Upload Certificate to NGINX Unit
cat /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem > fullcert.pem &&
cat /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem >> fullcert.pem &&
curl -X PUT --data-binary @fullcert.pem --unix-socket /var/run/control-unit.sock http://localhost/certificates/primary &&

#Apply SSL Partial Configuration
curl -X PUT --data-binary @/software/listener.json --unix-socket /var/run/control-unit.sock 'http://localhost/config/listener/%2A%3A443' &&

#Idle Forever (IDK why tail -f /dev/null doesn't work so using infinite loop instead.)
while true
do
sleep 1
done
