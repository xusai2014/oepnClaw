# 1. 先清理之前的错误配置
sudo rm -f /etc/yum.repos.d/docker*.repo
sudo dnf clean all

# 2. 直接安装 Moby（阿里云官方维护的 Docker 兼容版本）
sudo yum install -y moby

# 3. 启动服务
sudo systemctl start docker
sudo systemctl enable docker

# 4. 验证安装
docker --version
docker run hello-world


# 首次执行（替换为你的域名）
docker-compose run --rm certbot \
  certonly --webroot \
  --webroot-path=/var/www/certbot \
  -d flygpt.cc -d www.flygpt.cc \
  --email jerryxu521@gmail.com --agree-tos --no-eff-email
