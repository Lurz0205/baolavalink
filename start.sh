#!/bin/bash
set -ex # Bật chế độ gỡ lỗi và thoát nếu có lỗi

HTTP_SERVER_PORT=5000 # Cổng cố định cho HTTP server (cho UptimeRobot)

echo "--- Bắt đầu HTTP server đơn giản trên cổng ${HTTP_SERVER_PORT} (cho UptimeRobot) ---"

# Chạy HTTP server của Python ở chế độ nền.
# Nó sẽ phục vụ các file trong thư mục hiện tại.
# Sử dụng nohup để đảm bảo nó không bị dừng khi shell thoát.
# Chuyển hướng tất cả output vào /dev/null để không làm đầy nhật ký.
nohup python3 -m http.server ${HTTP_SERVER_PORT} > /dev/null 2>&1 &
HTTP_SERVER_PID=$! # Lấy ID tiến trình của HTTP server

echo "HTTP server đã được khởi động với PID ${HTTP_SERVER_PID}"

MAX_RETRIES=30
RETRY_INTERVAL=2

echo "Đang chờ HTTP server lắng nghe trên cổng ${HTTP_SERVER_PORT}..."

# Vòng lặp kiểm tra xem cổng HTTP server đã mở chưa
for i in $(seq 1 $MAX_RETRIES); do
    if nc -z localhost ${HTTP_SERVER_PORT}; then
        echo "Cổng ${HTTP_SERVER_PORT} của HTTP server đã mở!"
        break
    else
        echo "Cổng ${HTTP_SERVER_PORT} chưa mở. Thử lại sau ${RETRY_INTERVAL} giây... (Lần $i/${MAX_RETRIES})"
        sleep ${RETRY_INTERVAL}
    fi

    if [ $i -eq $MAX_RETRIES ]; then
        echo "Hết thời gian chờ HTTP server mở cổng ${HTTP_SERVER_PORT}. Thoát."
        exit 1 # Thoát với mã lỗi
    fi
done

echo "--- HTTP server đã được xác nhận đang chạy. ---"
echo "--- Bắt đầu Lavalink trên cổng được cấp phát bởi Render ---"

# Render sẽ cấp phát một biến môi trường $PORT (ví dụ: 10000 hoặc 10001).
# Chúng ta sẽ buộc Lavalink lắng nghe trên cổng đó bằng tham số --server.port.
# Lệnh 'exec' sẽ thay thế tiến trình shell hiện tại bằng tiến trình Lavalink,
# đảm bảo rằng container Docker vẫn hoạt động miễn là Lavalink chạy.
exec java -jar Lavalink.jar --server.port=$PORT
