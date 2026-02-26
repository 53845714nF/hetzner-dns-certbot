#!/bin/env bash

if [ -n "$TOKEN" ]; then
  token=$TOKEN
else
  token=$(cat /etc/hetzner-dns-token)
fi

domain_name=$(echo "$CERTBOT_DOMAIN" | rev | cut -d'.' -f 1,2 | rev)

data=$(cat <<EOF
{
  "name": "_acme-challenge.${CERTBOT_DOMAIN%.$domain_name}",
  "type": "TXT",
  "ttl": 60,
  "records": [
    {
      "value": "\"${CERTBOT_VALIDATION}\""
    }
  ]
}
EOF
)

curl -Ss -X "POST" "https://api.hetzner.cloud/v1/zones/${domain_name}/rrsets" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer ${token}" \
     -d "$data"

# Wartezeit für DNS-Propagation
sleep 30
