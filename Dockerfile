# ================== 构建阶段（负责编译 Go 程序） ==================
FROM golang:1.22-alpine AS builder

# 换 Alpine 国内源（关键提速点 1）
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 安装基础依赖
RUN apk add --no-cache git ca-certificates

# 设置 Go 编译相关环境变量
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GOPROXY=https://goproxy.cn,direct

# 设置工作目录
WORKDIR /build

# 先拷贝 go.mod 和 go.sum（利用缓存）
COPY go.mod .
COPY go.sum .

# 下载 Go 依赖（现在会非常快）
RUN go mod download

# 拷贝项目全部源码
COPY . .

# 编译
RUN go build -o bluebell .

# ================== 运行阶段（最小镜像） ==================
FROM alpine:latest

# 安装 ca 证书
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /build/bluebell .

EXPOSE 8080

CMD ["./bluebell"]
