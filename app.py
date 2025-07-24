    import os
    from flask import Flask, jsonify

    app = Flask(__name__)

    @app.route('/')
    def home():
        """
        Endpoint gốc của Flask app. Trả về thông báo đơn giản.
        UptimeRobot sẽ ping endpoint này để giữ cho dịch vụ hoạt động.
        """
        return jsonify(message="Lavalink container is running. This is a dummy Flask app for UptimeRobot."), 200

    if __name__ == '__main__':
        # Flask sẽ chạy trên một cổng khác Lavalink (ví dụ: 5000)
        # Render sẽ phát hiện cổng này và giữ cho dịch vụ hoạt động.
        # Lấy cổng từ biến môi trường PORT, nếu không có thì dùng 5000.
        port = int(os.environ.get("PORT", 5000))
        # Chạy Flask app, lắng nghe trên tất cả các interface (0.0.0.0)
        app.run(debug=False, host='0.0.0.0', port=port)
    
