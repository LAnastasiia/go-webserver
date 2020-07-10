FROM golang:latest

LABEL maintainer="Anastasiia <anastasiial@noogler.google.com>"

WORKDIR /app
# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download
# Copy the source from the current directory to the Working Directory inside the container
COPY . .
# Build the Go app

RUN chmod +x ./generate-keys.sh && ./generate-keys.sh ./ssl/
RUN go build -o main .
# Expose port 8080 to the outside world
EXPOSE 8080

CMD ["./main"]