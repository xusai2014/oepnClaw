docker-compose run --rm certbot certonly --webroot \
  -w /var/www/certbot \
  -d flygpt.cc -d www.flygpt.cc \
  --email jerryxu521@gmail.com \
  --agree-tos --non-interactive
