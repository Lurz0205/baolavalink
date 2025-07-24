#!/bin/bash
set -ex # Bật chế độ gỡ lỗi và thoát nếu có lỗi

echo "--- Bắt đầu Lavalink trên cổng được cấp phát bởi Render ---"

# Render sẽ cấp phát một biến môi trường $PORT (ví dụ: 10000 hoặc 10001).
# Chúng ta sẽ buộc Lavalink lắng nghe trên cổng đó bằng tham số --server.port.
# Lệnh 'exec' sẽ thay thế tiến trình shell hiện tại bằng tiến trình Lavalink,
# đảm bảo rằng container Docker vẫn hoạt động miễn là Lavalink chạy.
exec java -jar Lavalink.jar --server.port=$PORT
