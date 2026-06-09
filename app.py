import os
import json
import threading
import sys
from flask import Flask, send_from_directory, jsonify

app = Flask(__name__, template_folder="templates")

BASE_DIR    = os.path.dirname(os.path.abspath(__file__))
DADOS_DIR   = os.path.join(BASE_DIR, "dados_diario")
JSON_PATH   = os.path.join(DADOS_DIR, "bdm_noticias.json")
SCRIPTS_DIR = os.path.join(BASE_DIR, "scripts_py")

# Evita rodar dois scrapers ao mesmo tempo
_scraper_rodando = False


@app.route("/")
def home():
    return """
    <html>
    <head><title>DT_Claude</title></head>
    <body style="font-family:Arial;display:flex;align-items:center;justify-content:center;height:100vh;margin:0;background:#0f0f0f;color:#e8e0d0;">
      <div style="text-align:center;">
        <h1 style="color:#b8933a;font-size:48px;margin-bottom:8px;">DT_Claude</h1>
        <p style="color:#8a8070;font-size:18px;">Hello World — online e funcionando.</p>
        <p style="margin-top:24px;"><a href="/bdm" style="color:#58a6ff;font-size:16px;">📰 Painel BDM</a></p>
        <p style="margin-top:12px;"><a href="/evolucao" style="color:#58a6ff;font-size:16px;">📊 Evolução Financeira</a></p>
        <p style="margin-top:12px;"><a href="/matriz-rifa" style="color:#58a6ff;font-size:16px;">🎯 Matriz Rifa — R$ 125k</a></p>
      </div>
    </body>
    </html>
    """


@app.route("/bdm")
def painel_bdm():
    """Serve o painel de notícias BDM."""
    return send_from_directory("templates", "painel_bdm.html")


@app.route("/evolucao")
def painel_evolucao():
    """Serve o dashboard de evolução financeira."""
    return send_from_directory("templates", "evolucao.html")


@app.route("/matriz-rifa")
def matriz_rifa():
    """Quadro estilo rifa com depósitos diários aleatórios até R$ 125k."""
    return send_from_directory("templates", "matriz_rifa.html")


@app.route("/api/bdm")
def api_bdm():
    """Retorna o JSON de notícias gerado pelo scraper."""
    if not os.path.exists(JSON_PATH):
        return jsonify({"erro": "Dados ainda não disponíveis. Clique em Atualizar."}), 404
    with open(JSON_PATH, encoding="utf-8") as f:
        dados = json.load(f)
    return jsonify(dados)


@app.route("/api/atualizar", methods=["POST"])
def api_atualizar():
    """Dispara o scraper em background e retorna imediatamente."""
    global _scraper_rodando

    if _scraper_rodando:
        return jsonify({"status": "em_andamento", "msg": "Atualização já em andamento..."}), 202

    def rodar_scraper():
        global _scraper_rodando
        _scraper_rodando = True
        try:
            if SCRIPTS_DIR not in sys.path:
                sys.path.insert(0, SCRIPTS_DIR)
            import importlib
            import bdm_scraper
            importlib.reload(bdm_scraper)
            bdm_scraper.executar()
        except Exception as e:
            print(f"[ATUALIZAR] Erro: {e}")
        finally:
            _scraper_rodando = False

    t = threading.Thread(target=rodar_scraper, daemon=True)
    t.start()

    return jsonify({"status": "iniciado", "msg": "Coletando notícias... aguarde ~30 segundos."})


@app.route("/api/status")
def api_status():
    """Informa se o scraper está rodando."""
    return jsonify({"scraper_rodando": _scraper_rodando})


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=False)
