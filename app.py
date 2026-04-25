import os
from flask import Flask

app = Flask(__name__)


@app.route("/")
def home():
    return """
    <html>
    <head><title>DT_Claude</title></head>
    <body style="font-family:Arial;display:flex;align-items:center;justify-content:center;height:100vh;margin:0;background:#0f0f0f;color:#e8e0d0;">
      <div style="text-align:center;">
        <h1 style="color:#b8933a;font-size:48px;margin-bottom:8px;">DT_Claude</h1>
        <p style="color:#8a8070;font-size:18px;">Hello World — online e funcionando.</p>
      </div>
    </body>
    </html>
    """


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
