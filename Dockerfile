# Sử dụng một image cơ bản của Java (OpenJDK 17)
FROM openjdk:17-jdk-slim

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Tải xuống file Lavalink.jar từ GitHub Releases của bạn
# Đảm bảo đường dẫn URL chính xác đến file JAR của bạn (L viết hoa)
ADD https://github.com/Lurz0205/baolavalink/releases/download/v4.1.1/Lavalink.jar Lavalink.jar

# Tạo thư mục 'plugins' nơi Lavalink sẽ tìm các plugin
RUN mkdir -p plugins

# Tải xuống plugin YouTube Source vào thư mục 'plugins'
# Đã cập nhật URL tải xuống plugin YouTube Source để sử dụng file JAR đã biên dịch
ADD https://github.com/lavalink-devs/youtube-source/releases/download/1.13.3/youtube-plugin-1.13.3.jar plugins/lavalink-youtube-source.jar

# Sao chép file application.yml vào thư mục làm việc
COPY application.yml .

# Sao chép script khởi động
COPY start.sh .

# Cấp quyền thực thi cho script khởi động
RUN chmod +x start.sh

# Lavalink mặc định lắng nghe trên 8080.
# Render sẽ cấp phát một cổng thông qua $PORT và chúng ta sẽ dùng nó.
EXPOSE 8080

# Lệnh để chạy script khởi động khi container khởi động
CMD ["./start.sh"]
