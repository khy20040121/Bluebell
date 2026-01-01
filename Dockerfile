# ================== 构建阶段（负责编译 Go 程序） ==================
FROM golang:alpine AS builder

# 设置 Go 编译相关环境变量
# GO111MODULE=on   ：强制使用 Go Modules
# CGO_ENABLED=0    ：关闭 CGO，生成纯静态二进制
# GOOS=linux       ：目标系统为 Linux
# GOARCH=amd64     ：目标架构为 amd64（x86_64）
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# 设置工作目录为 /build
WORKDIR /build

# 先拷贝 go.mod 和 go.sum，用于缓存依赖
COPY go.mod .
COPY go.sum .

# 下载 Go 依赖
RUN go mod download

# 拷贝项目全部源码到容器中
COPY . .

# 编译项目，生成名为 bluebell 的可执行文件
RUN go build -o bluebell .

# 切换到产物目录，用于存放最终编译结果
WORKDIR /dist

# 将编译好的二进制文件复制到 /dist 目录
RUN cp /build/bluebell .

# ================== 运行阶段（只负责运行程序） ==================
FROM alpine:latest

# 安装运行期所需依赖
# tzdata           ：时区支持（日志时间）
# ca-certificates  ：HTTPS / TLS 证书支持
RUN apk add --no-cache tzdata ca-certificates

# 设置运行时工作目录
WORKDIR /app

# 从构建阶段拷贝编译好的二进制文件
COPY --from=builder /dist/bluebell .

# 拷贝配置文件目录
# 假设配置文件路径为 ./config/config.yaml
COPY config ./config

# 声明容器监听端口
EXPOSE 8080

# 容器启动时执行的命令
CMD ["./bluebell"]
