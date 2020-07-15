# First define a 'builder' container with all requirements installed.
FROM golang:1.14 as builder

LABEL maintainer="Anastasiia <anastasiial@noogler.google.com>"

WORKDIR /app
COPY go.mod go.sum ./

RUN go mod download
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o main .


# Create a smaller, 'production' container that will contain only our app.
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .

EXPOSE 8080

CMD ["./main"]