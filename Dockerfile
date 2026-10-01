# Stage 1: Build Stage
ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION} as builder

# Set the working directory
WORKDIR /app
COPY . .

# Stage 2: Run Stage
FROM python:${PYTHON_VERSION} as run

WORKDIR /app

ENV PYTHONUNBUFFERED=1

COPY --from=builder /app .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

EXPOSE 8000

# Выполнение миграций и запуск Django-сервера при каждом старте контейнера
ENTRYPOINT ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]

