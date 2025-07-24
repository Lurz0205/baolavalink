# Sử dụng một image cơ bản của Java (OpenJDK 17)
# Đây là image nhẹ nhất và chỉ chứa những gì cần thiết để chạy Java
FROM openjdk:17-jdk-slim

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Tải xuống file Lavalink.jar từ GitHub Releases của bạn
# Đảm bảo đường dẫn URL chính xác đến file JAR của bạn (L viết hoa)
ADD https://github.com/Lurz0205/baolavalink/releases/download/v4.1.1/Lavalink.jar Lavalink.jar

# Sao chép file application.yml vào thư mục làm việc
COPY application.yml .

# Sao chép script khởi động
COPY start.sh .

# Cấp quyền thực thi cho script khởi động
RUN chmod +x start.sh

# Lavalink mặc định lắng nghe trên 8080.
# Render sẽ cấp phát một cổng thông qua $PORT và chúng ta sẽ dùng nó.
# EXPOSE ở đây chỉ là thông tin, Render sẽ tìm cổng mà ứng dụng bind tới $PORT.
EXPOSE 8080

# Lệnh để chạy script khởi động khi container khởi động
CMD ["./start.sh"]
