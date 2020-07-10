# go-webserver
Very simple HTTPS webserver written on Go for learning purposes.

Usage:

1. Generate the a SSL/TLS certificate and a key by executing `generate-keys.sh` taken from [here](https://github.com/stackrox/admission-controller-webhook-demo/blob/master/deployment/generate-keys.sh). HTTPS server uses them for data encryption, digital signature, and server authentication.

2. `go build`, `./webserver`

3. check the handled URL routs 
    * https://127.0.0.1:8080/
    * https://127.0.0.1:8080/profiles
    * https://127.0.0.1:8080/profiles/
    * https://127.0.0.1:8080/profiles/1
    * https://127.0.0.1:8080/profiles/555040
