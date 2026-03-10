# OpenClaw 云端部署方案



## 1.服务器环境搭建 （Aliyun Linux）

### 第一步安装 Moby（阿里云官方维护的 Docker 兼容版本）
```
sudo yum install -y moby
```

### 第二步启动服务
```
sudo systemctl start docker
sudo systemctl enable docker
```

### 第三步验证安装
docker --version
docker run hello-world

以上就完成了服务器环境的搭建

## 2.准备部署文件
文件下载到服务器
- docker-compose.yml
- nginx.conf
- .env

## 3.启动并配置应用

1. 首次启动需要生成HTTPS证书，运行命令如下：
```
docker compose run --rm certbot certonly --webroot \
  -w /var/www/certbot \
  -d your-domain.com -d www.your-domain.com \
  --email your@email.com --agree-tos --non-interactive
```

2. 证书生成后，启动应用
```
# 首次时间较长，下一次就会很快
docker compose up -d
```

3. 获取地址，用浏览器访问
```
# 运行命令
docker-compose exec openclaw-gateway openclaw dashboard --no-open
```
```
# 控制台打印
Dashboard URL: http://127.0.0.1:18789/#token=fsdfsdfsdfsdfsdfsfsdfsfsdfsdfs
Copy to clipboard unavailable.
Browser launch disabled (--no-open). Use the URL above.
```
浏览器访问该地址（还不能正常使用，需要进行设备信任进入第六步）

6. 在服务器查看应用信任设备
```
# 运行命令
docker-compose exec openclaw-gateway openclaw devices list
```
```
# 控制台打印
Pending (1)
┌──────────────────────────────────────┬────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┬──────────┬────────────┬──────────┬────────┐
│ Request                              │ Device                                                                                                                         │ Role     │ IP         │ Age      │ Flags  │
├──────────────────────────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼──────────┼────────────┼──────────┼────────┤
│ 12b6be94-0a84-12b6be9412b6be9412b6be │ 41da7bd68481bc41da7bd68481bc41da7bd68481bc41da7bd68481bc41da7bd6                                                               │ operator │            │ just now │        │
└──────────────────────────────────────┴────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴──────────┴────────────┴──────────┴────────┘
Paired (1)
......

```
```
# 运行命令

docker-compose exec openclaw-gateway openclaw devices approve 12b6be94-0a84-12b6be9412b6be9412b6be
```

## 设备信任成功，可以养🦞了！！！！


ollama 私有化部署的使用方式
```
# 查看ollama 大模型镜像
docker-compose exec ollama ollama list

# 根据需要拉取
docker-compose exec ollama ollama pull qwen2.5:14b

# 然后配置到 openclaw.json
   "models": {
     "mode": "merge",
     "providers": {
       "ollama": {
        "baseUrl": "http://ollama:11434/v1",   // Docker 容器内用 ollama:11434；本地单机用 http://127.0.0.1:11434/v1
        "api": "openai-responses",
        "apiKey": "ollama",
        "models": [
         {
          "id": "qwen2.5:14b",
          "name": "Qwen2.5 14B"
         }
       ]
      }
    }

```
````
# 配置能力
docker-compose exec openclaw-gateway openclaw onboard
```



