#!/bin/bash
set -ex # Bật chế độ gỡ lỗi (in ra từng lệnh) và thoát nếu có lỗi

echo "--- Bắt đầu HTTP server đơn giản (cho Render/UptimeRobot) ---"

FLASK_PORT=5000 # Vẫn sử dụng biến này để nhất quán
# Chạy HTTP server của Python ở chế độ nền.
# Nó sẽ phục vụ các file trong thư mục hiện tại.
# Sử dụng nohup để đảm bảo nó không bị dừng khi shell thoát.
# Chuyển hướng tất cả output vào /dev/null để không làm đầy nhật ký.
nohup python3 -m http.server ${FLASK_PORT} > /dev/null 2>&1 &
HTTP_SERVER_PID=$! # Lấy ID tiến trình của HTTP server

echo "HTTP server đã được khởi động với PID ${HTTP_SERVER_PID}"

MAX_RETRIES=30
RETRY_INTERVAL=2

echo "Đang chờ HTTP server lắng nghe trên cổng ${FLASK_PORT}..."

# Vòng lặp kiểm tra xem cổng HTTP server đã mở chưa
for i in $(seq 1 $MAX_RETRIES); do
    if nc -z localhost ${FLASK_PORT}; then
        echo "Cổng ${FLASK_PORT} của HTTP server đã mở!"
        break
    else
        echo "Cổng ${FLASK_PORT} chưa mở. Thử lại sau ${RETRY_INTERVAL} giây... (Lần $i/${MAX_RETRIES})"
        sleep ${RETRY_INTERVAL}
    fi

    if [ $i -eq $MAX_RETRIES ]; then
        echo "Hết thời gian chờ HTTP server mở cổng ${FLASK_PORT}. Thoát."
        exit 1 # Thoát với mã lỗi
    fi
done

echo "--- HTTP server đã được xác nhận đang chạy. ---"
echo "--- Bắt đầu Lavalink ở chế độ tiền cảnh ---"

# Chạy Lavalink ở chế độ tiền cảnh.
# Lệnh 'exec' sẽ thay thế tiến trình shell hiện tại bằng tiến trình Lavalink,
# đảm bảo rằng container Docker vẫn hoạt động miễn là Lavalink chạy.
exec java -jar Lavalink.jar # Đảm bảo tên file JAR chính xác (Lavalink.jar)
