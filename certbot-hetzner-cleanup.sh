#!/bin/env bash

if [ -n "$TOKEN" ]; then
  # To use this run 'export $TOKEN=foo'before runing certbot
  token=$TOKEN
else
  token=$(cat /etc/hetzner-dns-token)
fi

domain_name=$( echo $CERTBOT_DOMAIN | rev | cut -d'.' -f 1,2 | rev)
rr_name=_acme-challenge.${CERTBOT_DOMAIN%$domain_name}

curl -X "DELETE" "https://api.hetzner.cloud/v1/zones/${domain_name}/rrsets/${rr_name%.}/TXT" \
     -H "Authorization: Bearer ${token}" >/dev/null 2>/dev/null