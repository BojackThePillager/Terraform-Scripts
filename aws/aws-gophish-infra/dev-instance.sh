#!/usr/bin/bash
#Downloads, installs golang, gophish, and valid web certs for admin port for the domain specified
sudo apt update
sudo apt install -y gcc
wget -o /usr/local/go1.20.5.linux-amd64.tar.gz https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
rm -rf /usr/local/go 
tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> /home/ubuntu/.bashrc
echo "export PATH=$PATH:/usr/local/go/bin" >> /root/.bashrc
echo "#!/usr/bin/bash" >> /home/ubuntu/builder.sh
echo "/usr/local/go/bin/go install github.com/gophish/gophish@latest" >> /home/ubuntu/builder.sh
echo "cp -R /root/go /home/ubuntu/" >> /home/ubuntu/builder.sh
echo "/usr/local/go/bin/go build -C /home/ubuntu/go/pkg/mod/github.com/gophish/gophish@v0.12.1/" >> /home/ubuntu/builder.sh
echo "chown -R ubuntu /home/ubuntu/go" >> /home/ubuntu/builder.sh
chmod +x /home/ubuntu/builder.sh
sudo sh -c "/home/ubuntu/builder.sh"
sed -i 's/127.0.0.1/0.0.0.0/g' /home/ubuntu/go/pkg/mod/github.com/gophish/gophish@v0.12.1/config.json
export DOMAIN=my.domain.com
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
echo "#/usr/bin/bash" >> /home/ubuntu/cert-builder.sh
echo "sudo certbot certonly --non-interactive --agree-tos --no-eff-email --no-redirect --email 'admin@$DOMAIN' --standalone --domains '$DOMAIN'" >> /home/ubuntu/cert-builder.sh
chmod +x /home/ubuntu/cert-builder.sh
sleep 60 
sudo sh -c "/home/ubuntu/cert-builder.sh"
sleep 10
cp /etc/letsencrypt/live/$DOMAIN/cert.pem /home/ubuntu/go/pkg/mod/github.com/gophish/gophish@v0.12.1/
cp /etc/letsencrypt/live/$DOMAIN/privkey.pem /home/ubuntu/go/pkg/mod/github.com/gophish/gophish@v0.12.1/
sed -i 's/gophish_admin.crt/cert.pem/g' /home/ubuntu/go/pkg/mod/github.com/gophish/gophish@v0.12.1/config.json
sed -i 's/gophish_admin.key/privkey.pem/g' /home/ubuntu/go/pkg/mod/github.com/gophish/gophish@v0.12.1/config.json
