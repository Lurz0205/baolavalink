#!/bin/bash
set -ex # Bật chế độ gỡ lỗi (in ra từng lệnh) và thoát nếu có lỗi

echo "--- Bắt đầu Flask app ---"

# Chạy Flask app ở chế độ nền.
# Chuyển hướng tất cả output (stdout và stderr) vào file flask_app.log
# Sử dụng 'python3 -u' để đảm bảo output không bị đệm, giúp xem log theo thời gian thực.
python3 -u app.py > flask_app.log 2>&1 &
FLASK_PID=$! # Lấy ID tiến trình của Flask app

echo "Flask app đã được khởi động với PID ${FLASK_PID}"

FLASK_PORT=5000
MAX_RETRIES=30
RETRY_INTERVAL=2

echo "Đang chờ Flask app lắng nghe trên cổng ${FLASK_PORT}..."

# Vòng lặp kiểm tra xem cổng Flask đã mở chưa
for i in $(seq 1 $MAX_RETRIES); do
    if nc -z localhost ${FLASK_PORT}; then
        echo "Cổng ${FLASK_PORT} của Flask app đã mở!"
        break
    else
        echo "Cổng ${FLASK_PORT} chưa mở. Thử lại sau ${RETRY_INTERVAL} giây... (Lần $i/${MAX_RETRIES})"
        sleep ${RETRY_INTERVAL}
    fi

    if [ $i -eq $MAX_RETRIES ]; then
        echo "Hết thời gian chờ Flask app mở cổng ${FLASK_PORT}. Đang xuất log của Flask app và thoát."
        cat flask_app.log # In ra nội dung log của Flask app để gỡ lỗi
        exit 1 # Thoát với mã lỗi
    fi
done

echo "--- Flask app đã được xác nhận đang chạy. ---"
echo "--- Bắt đầu Lavalink ở chế độ tiền cảnh ---"

# Chạy Lavalink ở chế độ tiền cảnh.
# Lệnh 'exec' sẽ thay thế tiến trình shell hiện tại bằng tiến trình Lavalink,
# đảm bảo rằng container Docker vẫn hoạt động miễn là Lavalink chạy.
exec java -jar Javalink.jar # Đảm bảo tên file JAR chính xác (Javalink.jar)
