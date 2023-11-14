FROM python:3.11-alpine as builder

WORKDIR /build
COPY requirements.txt .

RUN apk update \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev \
        postgresql-dev \
        python3-dev \
        libffi-dev \
        make \
    && pip install --upgrade pip \
    && pip install -r requirements.txt \
    && rm -rf /root/.cache \
    && apk del .build-deps

FROM python:3.11-alpine
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY . /app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]



