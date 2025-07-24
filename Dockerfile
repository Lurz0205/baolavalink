# Sử dụng một image cơ bản của Java (ví dụ: OpenJDK 17)
FROM openjdk:17-jdk-slim

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Tải xuống file javalink.jar từ GitHub Releases của bạn
# Đảm bảo đường dẫn URL chính xác đến file JAR của bạn
# Bạn đã cung cấp link: https://github.com/Lurz0205/baolavalink/releases/tag/v4.1.1
# File JAR thực tế là https://github.com/Lurz0205/baolavalink/releases/download/v4.1.1/javalink.jar
ADD https://github.com/Lurz0205/baolavalink/releases/download/v4.1.1/javalink.jar javalink.jar

# Sao chép file application.yml vào thư mục làm việc
# Giả sử application.yml nằm ở thư mục gốc của repo
COPY application.yml .
# Nếu application.yml nằm trong thư mục con, ví dụ: 'config', thì dùng lệnh sau:
# COPY config/application.yml .

# Đặt cổng mà Lavalink sẽ lắng nghe
EXPOSE 8080

# Lệnh để chạy Lavalink khi container khởi động
ENTRYPOINT ["java", "-jar", "javalink.jar"]

# Nếu bạn muốn chỉ định file config location:
# ENTRYPOINT ["java", "-jar", "javalink.jar", "--spring.config.location=./application.yml"]
