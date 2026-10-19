
# Build stage
FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY go.mod ./
COPY main.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o vault-go-app main.go

# Runtime stage
FROM alpine:3.22

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /app/vault-go-app /app/vault-go-app

# Run as a non-root user
USER 10001:10001

ENTRYPOINT ["/app/vault-go-app"]
