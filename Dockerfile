# Sử dụng một image cơ bản của Ubuntu để dễ dàng cài đặt cả Java và Python
FROM ubuntu:22.04

# Cập nhật danh sách gói và cài đặt Java (OpenJDK 17), Python 3, và netcat
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk python3 netcat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Tải xuống file Lavalink.jar từ GitHub Releases của bạn
# Đảm bảo đường dẫn URL chính xác đến file JAR của bạn (L viết hoa)
ADD https://github.com/Lurz0205/baolavalink/releases/download/v4.1.1/Lavalink.jar Lavalink.jar

# Tạo thư mục 'plugins' nơi Lavalink sẽ tìm các plugin
RUN mkdir -p plugins

# Tải xuống plugin YouTube Source vào thư mục 'plugins'
# Đảm bảo URL này là đúng file JAR đã biên dịch của plugin
ADD https://github.com/lavalink-devs/youtube-source/releases/download/1.13.3/youtube-plugin-1.13.3.jar plugins/lavalink-youtube-source.jar

# Sao chép file application.yml vào thư mục làm việc
COPY application.yml .

# Sao chép script khởi động
COPY start.sh .

# Cấp quyền thực thi cho script khởi động
RUN chmod +x start.sh

# Mở cổng 5000 cho HTTP server (cho UptimeRobot)
# Mở cổng 8080 cho Lavalink (đây là cổng nội bộ mà bot sẽ kết nối)
EXPOSE 5000
EXPOSE 8080

# Lệnh để chạy script khởi động khi container khởi động
CMD ["./start.sh"]
