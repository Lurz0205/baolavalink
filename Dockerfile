# Sử dụng một image cơ bản của Ubuntu để dễ dàng cài đặt cả Java và Python
FROM ubuntu:22.04

# Cập nhật danh sách gói và cài đặt Java (OpenJDK 17), Python 3, pip
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Tải xuống file javalink.jar từ GitHub Releases của bạn
# Đảm bảo đường dẫn URL chính xác đến file JAR của bạn
ADD https://github.com/Lurz0205/baolavalink/releases/download/v4.1.1/Lavalink.jar Javalink.jar

# Sao chép file application.yml vào thư mục làm việc (giả sử nó ở thư mục gốc)
COPY application.yml .

# Sao chép các file Flask app và script khởi động
COPY app.py .
COPY requirements.txt .
COPY start.sh .

# Cấp quyền thực thi cho script khởi động
RUN chmod +x start.sh

# Cài đặt các thư viện Python từ requirements.txt
RUN pip install -r requirements.txt

# Mở các cổng cần thiết:
# 8080 là cổng của Lavalink
# 5000 là cổng của Flask app (mà UptimeRobot sẽ ping)
EXPOSE 8080
EXPOSE 5000

# Lệnh để chạy script khởi động khi container khởi động
# Script này sẽ đảm bảo Flask app khởi động trước và mở cổng
CMD ["./start.sh"]
