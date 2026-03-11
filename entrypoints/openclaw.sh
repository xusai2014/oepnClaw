!/bin/sh
set -e

CONFIG_DIR="/home/node/.openclaw"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"

# 创建配置目录
mkdir -p "$CONFIG_DIR"

# 只在配置文件不存在时才创建（避免覆盖用户修改）
if [ ! -f "$CONFIG_FILE" ]; then
    echo "📝 首次启动，创建默认配置文件..."

    # 使用环境变量或默认值

    cat > "$CONFIG_FILE" <<EOF
{
    "gateway": {
            "mode": "local",
            "bind": "lan",
            "port": 18789,
            "auth": {
              "mode": "token",
              "token": "ENV_TOKEN_PLACEHOLDER"
            },
            "controlUi": {
              "enabled": true,
              "allowInsecureAuth": true,
              "allowedOrigins": [
                "https://example.cc",
                "https://www.example.cc",
                "http://example.cc",
                "http://www.example.cc",
                "http://localhost:18789",
                "http://127.0.0.1:18789"
              ]
            }
          },
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
  }


        }
EOF
    echo "✅ 配置文件已创建: $CONFIG_FILE"
    echo "🔑 Token: ${AUTH_TOKEN}"
else
    echo "📂 检测到已有配置文件，跳过生成步骤: $CONFIG_FILE"
fi

sed -i "s/ENV_TOKEN_PLACEHOLDER/${OPENCLAW_GATEWAY_TOKEN}/g" /home/node/.openclaw/openclaw.json
exec node dist/index.js gateway
