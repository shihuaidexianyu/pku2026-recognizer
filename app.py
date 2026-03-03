#!/usr/bin/env python3

import os

from flask import Flask, jsonify, request

from autoelective.captcha import CaptchaRecognizer


MODEL_NAME = "recognizer_v11-CNN5-GRU-H128-CTC-C1"

app = Flask(__name__)
recognizer = CaptchaRecognizer(MODEL_NAME)


@app.get("/healthz")
def healthz():
    return jsonify({"ok": True})


@app.post("/recognize")
def recognize():
    image_file = request.files.get("image")
    if image_file is None:
        return jsonify({"ok": False, "error": "missing image file"}), 400

    raw = image_file.read()
    if not raw:
        return jsonify({"ok": False, "error": "empty image"}), 400

    try:
        captcha = recognizer.recognize(raw)
    except Exception as e:
        return jsonify({"ok": False, "error": str(e)}), 502

    code = str(getattr(captcha, "code", "")).strip()
    if not code:
        return jsonify({"ok": False, "error": "empty recognition result"}), 502

    return jsonify({"ok": True, "code": code})


if __name__ == "__main__":
    host = os.environ.get("PKU2026_RECOGNIZER_HOST", "127.0.0.1")
    port = int(os.environ.get("PKU2026_RECOGNIZER_PORT", "8799"))
    app.run(host=host, port=port)
