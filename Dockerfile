# Sử dụng một image cơ bản của Ubuntu để dễ dàng cài đặt cả Java và Python
FROM ubuntu:22.04

# Cập nhật danh sách gói và cài đặt Java (OpenJDK 17), Python 3, và netcat
# Loại bỏ curl vì không còn cần thiết cho việc kiểm tra file JAR nữa
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk python3 netcat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Tải xuống file Lavalink.jar từ GitHub Releases của bạn
# Đảm bảo đường dẫn URL chính xác đến file JAR của bạn (L viết hoa)
ADD https://github.com/Lurz0205/baolavalink/releases/download/v4.1.1/Lavalink.jar Lavalink.jar

# Sao chép file application.yml vào thư mục làm việc (giả sử nó ở thư mục gốc)
COPY application.yml .

# Sao chép script khởi động
COPY start.sh .

# Cấp quyền thực thi cho script khởi động
RUN chmod +x start.sh

# CHỈ MỞ CỔNG 5000 CHO HTTP SERVER.
# Render sẽ coi đây là cổng chính của dịch vụ web.
# Lavalink vẫn sẽ lắng nghe trên 8080 bên trong container.
EXPOSE 5000

# Lệnh để chạy script khởi động khi container khởi động
# Script này sẽ đảm bảo HTTP server khởi động trước và mở cổng
CMD ["./start.sh"]
