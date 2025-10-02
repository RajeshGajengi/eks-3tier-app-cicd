# Stage 1: Build
FROM node:24-alpine AS builder

WORKDIR /app

COPY . .

RUN npm install && npm run build

# Stage 2: Serve with Apache
FROM httpd:alpine

RUN rm -rf /usr/local/apache2/htdocs/*

COPY --from=builder /app/dist/ /usr/local/apache2/htdocs/

EXPOSE 80

CMD ["httpd-foreground"]
