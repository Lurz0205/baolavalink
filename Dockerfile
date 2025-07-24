# Sử dụng một image cơ bản của Ubuntu để dễ dàng cài đặt cả Java và Python
FROM ubuntu:22.04

# Cập nhật danh sách gói và cài đặt Java (OpenJDK 17), Python 3, pip và supervisor
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk python3 python3-pip supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Tải xuống file javalink.jar từ GitHub Releases của bạn
# Đảm bảo đường dẫn URL chính xác đến file JAR của bạn
ADD https://github.com/Lurz0205/baolavalink/releases/download/v4.1.1/Lavalink.jar Javalink.jar

# Sao chép file application.yml vào thư mục làm việc (giả sử nó ở thư mục gốc)
COPY application.yml .

# Sao chép các file Flask app và cấu hình Supervisord
COPY app.py .
COPY requirements.txt .
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Cài đặt các thư viện Python từ requirements.txt
RUN pip install -r requirements.txt

# Mở các cổng cần thiết:
# 8080 là cổng của Lavalink
# 5000 là cổng của Flask app (mà UptimeRobot sẽ ping)
EXPOSE 8080
EXPOSE 5000

# Lệnh để chạy Supervisord khi container khởi động
# Supervisord sẽ quản lý việc chạy cả Flask app và Lavalink
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
