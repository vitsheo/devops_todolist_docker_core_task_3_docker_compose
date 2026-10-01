version: '3.8'

services:
  db:
    image: mysql:8.0  # Використовуємо офіційний образ замість кастомного Dockerfile
    container_name: mysql-container
    environment:
      MYSQL_ROOT_PASSWORD: root_secure_pass
      MYSQL_DATABASE: app_db
      MYSQL_USER: app_user
      MYSQL_PASSWORD: 1234
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    # Перевірка працездатності: перевіряємо, чи MySQL повністю готовий приймати з'єднання
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "app_user", "-p1234"]
      interval: 5s
      timeout: 5s
      retries: 5
      start_period: 10s

  web:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: django-app
    ports:
      - "8000:8000"
    # Чекаємо не просто старту контейнера db, а саме його повної готовності (healthcheck)
    depends_on:
      db:
        condition: service_healthy
    environment:
      - MYSQL_HOST=db

volumes:
  mysql_data:
