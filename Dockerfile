# Sử dụng Java Runtime Environment (JRE) phiên bản 17 làm nền
FROM openjdk:17-jre-slim

# Thiết lập thư mục làm việc bên trong container
WORKDIR /app

# Tải Lavalink JAR từ trang Releases chính thức của GitHub
# Biến LAVALINK_VERSION sẽ được truyền từ GitHub Actions
ARG LAVALINK_VERSION
ADD https://github.com/lavalink-devs/Lavalink/releases/download/v${LAVALINK_VERSION}/Lavalink.jar Lavalink.jar

# Tạo file application.yml với cấu hình cơ bản
# LƯU Ý: Mật khẩu sẽ được đặt thông qua biến môi trường trên Render.com để bảo mật hơn
# Port mặc định 8080 cho Lavalink khi chạy trong Docker
RUN echo "server:\n  port: 8080\n  address: 0.0.0.0\n\nlavalink:\n  server:\n    password: \"DUMMY_PASSWORD\"\n    sources:\n      youtube: true\n      soundcloud: true: true\n      bandcamp: true\n      twitch: true\n      vimeo: true" > application.yml

# Khai báo cổng mà Lavalink sẽ lắng nghe
EXPOSE 8080

# Lệnh để chạy Lavalink khi container khởi động
CMD ["java", "-jar", "Lavalink.jar"]
