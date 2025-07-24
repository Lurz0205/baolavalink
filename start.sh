#!/bin/bash
set -ex # Bật chế độ gỡ lỗi (in ra từng lệnh) và thoát nếu có lỗi

echo "--- Bắt đầu Lavalink ở chế độ tiền cảnh ---"

# Render sẽ cung cấp cổng qua biến môi trường PORT.
# Lavalink cần lắng nghe trên cổng này để Render có thể chuyển tiếp lưu lượng.
# Ghi đè cài đặt 'port' trong application.yml bằng biến môi trường $PORT.
exec java -jar Lavalink.jar --server.port=$PORT
