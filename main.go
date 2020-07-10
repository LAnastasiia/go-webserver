package main

import (
	"example.com/webserver/functional"
	"fmt"
	"log"
	"net/http"
)

const (
	certFilePath = "./ssl/tls.crt"
	keyFilePath  = "./ssl/tls.key"
)

// Middleware contains code for pre-/post-processing that is common for all the requests (e.g. logging).
func middlewareWrapper(handler http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Got a %s request for: %v\n", r.Method, r.URL)
		handler.ServeHTTP(w, r)
		log.Printf("Handler finished processing request")
	})
}

func main() {

	// Add multiplexer for mapping the URL patterns to handler functions.
	prodMux := http.NewServeMux()
	fs := http.FileServer(http.Dir("static"))
	prodMux.Handle("/", fs)
	prodMux.HandleFunc("/profiles", functional.GetProfileList)
	prodMux.HandleFunc("/profiles/", functional.GetProfileByID)

	// Use another multiplexer to allow serving beta features iff requested URL starts with /beta/
	betaMux := http.NewServeMux()
	betaMux.HandleFunc("/profile", func(w http.ResponseWriter, r *http.Request) {
		if _, err := fmt.Fprintln(w, "beta page for profiles"); err != nil {
			fmt.Print("! Warning unable to respond to request")
		}
	})

	// The main multiplexer redirects requests either to prod or beta mux-es.
	mainMux := http.NewServeMux()
	mainMux.Handle("/", http.StripPrefix("", prodMux))
	mainMux.Handle("/beta/", http.StripPrefix("/beta", betaMux))

	loggedHandler := middlewareWrapper(mainMux)

	if err := http.ListenAndServeTLS(":8080", certFilePath, keyFilePath, loggedHandler); err != nil {
		fmt.Println(err)
	}
}
