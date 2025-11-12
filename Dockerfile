# مرحلة البناء
FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN apk add --no-cache gcc musl-dev

ENV CGO_ENABLED=1
RUN go build -o server-bin ./server

FROM alpine:latest
RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY --from=builder /app/server-bin ./server-bin
COPY assets ./assets
COPY index.html .
COPY login.html .
COPY about.html .
COPY contact.html .
COPY add-portfolio.html .
COPY portfolio.html .
COPY services.html .
COPY starter-page.html .
COPY server.db .

EXPOSE 8080
CMD ["./server-bin"]
