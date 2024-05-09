domain=$(cat /etc/xray/domain)
tls="$(cat ~/log-install.txt | grep -w "Trojan WS TLS" | cut -d: -f2|sed 's/ //g')"
ntls="$(cat ~/log-install.txt | grep -w "Trojan WS none TLS" | cut -d: -f2|sed 's/ //g')"
user=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
uuid=$(cat /proc/sys/kernel/random/uuid)
masaaktif=1
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#trojanws$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

# Getting IP information
ip_info=$(curl -sS https://ipinfo.io/json)
ip=$(echo $ip_info | jq -r '.ip')
country=$(echo $ip_info | jq -r '.country')
region=$(echo $ip_info | jq -r '.region')
isp=$(echo $ip_info | jq -r '.org')

systemctl restart xray
trojanlink1="trojan://${uuid}@${domain}:${tls}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${user}"
trojanlink="trojan://${uuid}@${domain}:${tls}?path=%2Ftrojan-ws&security=tls&host=${domain}&type=ws&sni=isi_bug_disini#${user}"
trojanlink2="trojan://${uuid}@isi_bug_disini:${ntls}?path=%2Ftrojan-ws&security=none&host=${domain}&type=ws#${user}"
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "\E[0;41;36m           TROJAN ACCOUNT           \E[0m" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "Remarks        : ${user}" | tee -a /etc/log-create-trojan.log
echo -e "Host/IP        : ${domain}" | tee -a /etc/log-create-trojan.log
echo -e "IP             : ${ip}" | tee -a /etc/log-create-trojan.log
echo -e "Country        : ${country}" | tee -a /etc/log-create-trojan.log
echo -e "Region         : ${region}" | tee -a /etc/log-create-trojan.log
echo -e "ISP            : ${isp}" | tee -a /etc/log-create-trojan.log
echo -e "Wildcard       : (bug.com).${domain}" | tee -a /etc/log-create-trojan.log
echo -e "Port TLS       : ${tls}" | tee -a /etc/log-create-trojan.log
echo -e "Port none TLS  : ${ntls}" | tee -a /etc/log-create-trojan.log
echo -e "Port gRPC      : ${tls}" | tee -a /etc/log-create-trojan.log
echo -e "Key            : ${uuid}" | tee -a /etc/log-create-trojan.log
echo -e "Path           : /trojan-ws" | tee -a /etc/log-create-trojan.log
echo -e "ServiceName    : trojan-grpc" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "Link TLS       : ${trojanlink}" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "Link none TLS  : ${trojanlink2}" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "Link gRPC      : ${trojanlink1}" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "Expired On     : $exp" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo "" | tee -a /etc/log-create-trojan.log
echo ""
read -n 1 -s -r -p "Press any key to back on menu"

m-trojan
