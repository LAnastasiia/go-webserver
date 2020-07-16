# First define a 'builder' with all requirements installed.
FROM golang:1.14 as builder

LABEL maintainer="Anastasiia <anastasiial@noogler.google.com>"

WORKDIR /app
COPY go.mod go.sum ./

RUN go mod download
COPY . .

RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o main .


# Create a smaller, 'production' that will contain only our app.
FROM scratch
COPY --from=builder /app/main .
EXPOSE 8080
ENTRYPOINT ["/main"]