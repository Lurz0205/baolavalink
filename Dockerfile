# Sử dụng một image cơ bản của Ubuntu để dễ dàng cài đặt cả Java và Python
FROM ubuntu:22.04

# Cập nhật danh sách gói và cài đặt Java (OpenJDK 17), Python 3, pip, curl, và netcat
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk python3 python3-pip curl netcat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Tải xuống file Javalink.jar từ GitHub Releases của bạn
# Đảm bảo đường dẫn URL chính xác đến file JAR của bạn (đã sửa J hoa)
ADD https://github.com/Lurz0205/baolavalink/releases/download/v4.1.1/Lavalink.jar Lavalink.jar

# THÊM BƯỚC KIỂM TRA SAU KHI TẢI JAR
# Kiểm tra xem file Javalink.jar có tồn tại không
RUN ls -lh Javalink.jar || echo "Javalink.jar not found after ADD command!"
# Kiểm tra xem file có thể đọc được không
RUN test -r Javalink.jar || echo "Javalink.jar is not readable!"

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

# CHỈ MỞ CỔNG 5000 CHO FLASK APP.
# Render sẽ coi đây là cổng chính của dịch vụ web.
# Lavalink vẫn sẽ lắng nghe trên 8080 bên trong container.
EXPOSE 5000

# Lệnh để chạy script khởi động khi container khởi động
# Script này sẽ đảm bảo Flask app khởi động trước và mở cổng
CMD ["./start.sh"]
