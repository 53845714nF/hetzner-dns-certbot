# Let’s Encrypt × Hetzner: Certbot DNS-01 challenge

## Requirements

```bash
apt install curl jq certbot
```

## Setup

Create the following files:

- /usr/local/bin/certbot-hetzner-auth.sh
- /usr/local/bin/certbot-hetzner-cleanup.sh

And copy the contents of the respective files from this repository into them.

And make them executable:

```bash
chmod +x /usr/local/bin/certbot-hetzner-auth.sh
chmod +x /usr/local/bin/certbot-hetzner-cleanup.sh
```

Put your Hetzner API token in `/etc/hetzner-dns-token`:

```bash
echo ********************* > /etc/hetzner-dns-token
```

## Create a certificate

```bash
certbot certonly \
-n \
--agree-tos \
--no-eff-email \
-m '<your-email>' \
--manual \
--preferred-challenges=dns \
--manual-auth-hook /usr/local/bin/certbot-hetzner-auth.sh \
--manual-cleanup-hook /usr/local/bin/certbot-hetzner-cleanup.sh \
-d <example.com> \
-d *.<example.com>
```

You get the following output:

```bash
Certificate is saved at: /etc/letsencrypt/live/<example.com>/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/<example.com>/privkey.pem
```

Configure your web server to use the certificate.

Settle the certificate in your web server configuration.

```bash
43 6 * * * certbot renew --post-hook "systemctl reload nginx"
```
