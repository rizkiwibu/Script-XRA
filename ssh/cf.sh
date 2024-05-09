#!/bin/bash

apt install jq curl -y
rm -rf /root/xray/scdomain
mkdir -p /root/xray
clear
sub=$(</dev/urandom tr -dc a-z0-9 | head -c5)
DOMAIN=catlfy.my.id
SUB_DOMAIN=vpn-${sub}.catlfy.my.id
CF_ID=marcelliano101@gmail.com
CF_KEY=359adcaa2f9c8c37e5841dd06e96636441223
set -euo pipefail
IP=$(wget -qO- ipinfo.io/ip);
echo "Record DNS ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
     
     RECORD2=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"CNAME","name":"'*.${SUB_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' > /dev/null


curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD2}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"CNAME","name":"'*.${SUB_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}' > /dev/null

echo "Host : $SUB_DOMAIN"
echo "IP=$SUB_DOMAIN" > /var/lib/ipvps.conf
echo "$SUB_DOMAIN" > /root/domain
echo "$SUB_DOMAIN" > /etc/xray/domain
echo "$SUB_DOMAIN" > /etc/v2ray/domain
echo "$SUB_DOMAIN" > /root/scdomain
echo "$SUB_DOMAIN" > /root/xray/scdomain
echo -e "Done Record Domain= ${SUB_DOMAIN} For VPS"
rm -rf cf
sleep 1
