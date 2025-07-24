#!/bin/bash

# Ghi nhật ký để theo dõi quá trình khởi động
echo "Starting Flask app in background..."

# Chạy Flask app ở chế độ nền.
# Sử dụng nohup để đảm bảo nó không bị dừng khi shell thoát.
# Ghi output vào file log riêng hoặc /dev/null nếu không muốn log quá nhiều.
nohup python3 app.py > /dev/null 2>&1 & # Đã thay đổi 'python' thành 'python3'

echo "Flask app started. Giving it a moment to bind port..."
sleep 5 # Đợi 5 giây để Flask app chắc chắn đã khởi động và mở cổng

echo "Starting Lavalink in foreground..."
# Chạy Lavalink ở chế độ tiền cảnh.
# Lệnh 'exec' sẽ thay thế tiến trình shell hiện tại bằng tiến trình Lavalink,
# đảm bảo rằng container Docker vẫn hoạt động miễn là Lavalink chạy.
exec java -jar javalink.jar
