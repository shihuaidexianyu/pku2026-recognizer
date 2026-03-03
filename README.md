# PKU2026 Recognizer

独立的验证码识别 API 服务，内部使用 `PKUAutoElective2026-Master` 的原始 TensorFlow 识别链路。

这个目录可以直接作为单独仓库使用。

## API

- `GET /healthz`
- `POST /recognize`

成功返回：

```json
{"ok": true, "code": "abcd"}
```

失败返回：

```json
{"ok": false, "error": "reason"}
```

## 本地启动

```bash
chmod +x start.sh
./start.sh
```

要求本机已安装 `uv`。脚本会用 `uv` 管理 `.venv`，并在需要时自动准备兼容的 Python 版本。

默认监听：

- `http://127.0.0.1:8799/healthz`
- `http://127.0.0.1:8799/recognize`

## Docker

```bash
bash build_docker_image.sh
docker run -d --name pku2026-recognizer --restart unless-stopped -p 8799:8799 pku2026-recognizer
```

也可以直接：

```bash
bash run_docker_container.sh
```

## 与主项目对接

主项目中设置：

- `provider = pku2026`
- `endpoint = http://127.0.0.1:8799/recognize`

## 目录说明

- `app.py`: API 入口
- `autoelective/captcha/`: 从上游项目复制的识别链路及模型文件
- `pyproject.toml`: 由 `uv` 管理的服务依赖定义
- `uv.lock`: `uv` 生成的锁文件，保证依赖版本可复现
- `build_docker_image.sh`: Docker 镜像打包脚本
- `run_docker_container.sh`: Docker 容器启动脚本
- `UPSTREAM_LICENSE`: 上游许可证副本
