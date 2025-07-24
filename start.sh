#!/bin/bash

# Thoát ngay lập tức nếu bất kỳ lệnh nào thất bại
set -e

echo "Starting Flask app in background..."

# Chạy Flask app ở chế độ nền.
# Sử dụng nohup để đảm bảo nó không bị dừng khi shell thoát.
# Ghi output vào /dev/null để tránh làm đầy nhật ký.
nohup python3 app.py > /dev/null 2>&1 &

FLASK_PORT=5000
MAX_RETRIES=30
RETRY_INTERVAL=2

echo "Waiting for Flask app to bind to port ${FLASK_PORT}..."

# Vòng lặp kiểm tra xem cổng Flask đã mở chưa
for i in $(seq 1 $MAX_RETRIES); do
    if nc -z localhost ${FLASK_PORT}; then
        echo "Flask app port ${FLASK_PORT} is open!"
        break
    else
        echo "Port ${FLASK_PORT} not open yet. Retrying in ${RETRY_INTERVAL} seconds... (Attempt $i/$MAX_RETRIES)"
        sleep ${RETRY_INTERVAL}
    fi

    if [ $i -eq $MAX_RETRIES ]; then
        echo "Timed out waiting for Flask app to open port ${FLASK_PORT}. Exiting."
        exit 1
    fi
done

echo "Flask app is confirmed running. Starting Lavalink in foreground..."
# Chạy Lavalink ở chế độ tiền cảnh.
# Lệnh 'exec' sẽ thay thế tiến trình shell hiện tại bằng tiến trình Lavalink,
# đảm bảo rằng container Docker vẫn hoạt động miễn là Lavalink chạy.
exec java -jar javalink.jar
