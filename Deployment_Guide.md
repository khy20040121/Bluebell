# Bluebell 项目部署指南

本指南将指导你如何在 Linux 服务器（CentOS/Ubuntu）上部署 Bluebell 项目。

## 1. 环境准备

在服务器上安装必要的软件：

1.  **Docker & Docker Compose** (用于运行 MySQL 和 Redis)
    ```bash
    # 安装 Docker (以 Ubuntu 为例)
    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    # 安装 Docker Compose
    sudo apt-get install docker-compose
    ```

2.  **Nginx** (用于反向代理和静态资源托管)
    ```bash
    sudo apt-get install nginx
    ```

3.  **Git** (用于拉取代码)
    ```bash
    sudo apt-get install git
    ```

## 2. 数据库与缓存部署

我们使用 Docker Compose 快速启动 MySQL 和 Redis。

1.  将项目代码上传到服务器（或 `git clone`）。
    ```bash
    cd /path/to/bluebell
    ```

2.  启动容器：
    ```bash
    docker-compose up -d
    ```

3.  验证状态：
    ```bash
    docker-compose ps
    ```
    确保 `mysql`, `redis01`, `redis02` 状态均为 `Up`。

## 3. 后端部署 (Go)

1.  **编译二进制文件**
    在本地开发机（如果是同架构）或服务器上进行编译。
    ```bash
    # 如果在本地 Mac/Windows 编译 Linux 目标文件：
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bluebell main.go
    ```
    上传 `bluebell` 二进制文件到服务器的 `/path/to/bluebell` 目录。

2.  **修改配置文件**
    修改 `config/config.yaml`。由于 MySQL/Redis 在 Docker 中运行，如果后端在**宿主机**直接运行，使用 `127.0.0.1` 即可。
    ```yaml
    app:
      mode: "release"  # 修改为 release 模式
      port: 8080
    
    mysql:
      host: "127.0.0.1"
      password: "root_password_here" # 确保与 docker-compose 中一致
    
    redis:
      host: "127.0.0.1"
      password: "redis_password_here"
    ```

3.  **使用 Systemd 管理进程** (推荐)
    创建服务文件：`sudo vim /etc/systemd/system/bluebell.service`
    ```ini
    [Unit]
    Description=Bluebell Backend Service
    After=network.target

    [Service]
    Type=simple
    User=root
    WorkingDirectory=/path/to/bluebell
    ExecStart=/path/to/bluebell/bluebell
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target
    ```

4.  **启动服务**
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl start bluebell
    sudo systemctl enable bluebell
    ```

## 4. 前端部署 (React)

1.  **本地构建**
    在本地项目 `frontend` 目录下执行：
    ```bash
    npm run build
    ```
    这会生成一个 `dist` 文件夹。

2.  **上传文件**
    将 `dist` 文件夹上传到服务器，例如 `/var/www/bluebell/dist`。

## 5. Nginx 配置 (反向代理)

配置 Nginx 让用户可以通过域名访问前端，并将 API 请求转发给后端。

1.  编辑配置文件：`sudo vim /etc/nginx/conf.d/bluebell.conf`

    ```nginx
    server {
        listen 80;
        server_name your_domain.com;  # 替换为你的域名或服务器IP

        # 前端静态文件
        location / {
            root /var/www/bluebell/dist;
            index index.html index.htm;
            try_files $uri $uri/ /index.html; # 解决 React Router 刷新 404 问题
        }

        # 后端 API 转发
        location /api {
            proxy_pass http://127.0.0.1:8080;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
    ```

2.  **重启 Nginx**
    ```bash
    sudo nginx -t  # 测试配置是否正确
    sudo systemctl reload nginx
    ```

## 6. 验证

访问 `http://your_domain.com`，你应该能看到前端页面，并且可以正常注册、登录和发帖。
