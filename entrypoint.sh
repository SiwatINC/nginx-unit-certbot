unitd --no-daemon --control unix:/var/run/control-unit.sock &
curl -X PUT --data-binary @/software/unit.json --unix-socket /var/run/control-unit.sock http://localhost/config &&
certbot certonly --test-cert --webroot --agree-tos -m $EMAIL -n -w /ssl/certbotroot -d $DOMAIN_NAME &&
tail -f /dev/null