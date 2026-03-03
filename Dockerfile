FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV UV_LINK_MODE=copy
ENV UV_PROJECT_ENVIRONMENT=/app/.venv
ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:0.9.6 /uv /uvx /bin/
COPY pyproject.toml /app/pyproject.toml
COPY uv.lock /app/uv.lock

RUN uv sync --frozen --no-install-project --no-dev

COPY autoelective /app/autoelective
COPY app.py /app/app.py
COPY UPSTREAM_LICENSE /app/UPSTREAM_LICENSE

EXPOSE 8799

CMD ["python", "app.py"]
