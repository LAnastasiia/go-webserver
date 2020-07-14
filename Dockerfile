FROM alpine:latest

RUN apk add --no-cache git
RUN apk add --no-cache go
RUN apk add --no-cache bash
RUN apk add --no-cache openssl

LABEL maintainer="Anastasiia <anastasiial@noogler.google.com>"

WORKDIR /app
# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download
# Copy the source from the current directory to the Working Directory inside the container
COPY . .
# Build the Go app

RUN mkdir -p ssl
RUN chmod +x ./generate-keys.sh
RUN ./generate-keys.sh ./ssl/

RUN CGO_ENABLED=0 go build -a -installsuffix cgo
RUN CGO_ENABLED=0 go build -o main .

# Expose port 8080 to the outside world
EXPOSE 8080

CMD ["./main"]