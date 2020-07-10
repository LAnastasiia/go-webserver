package functional

import (
	"encoding/json"
	_ "fmt"
	"net/http"
	"strconv"
	_"strconv"
	"strings"
)

type profile struct {
	Name    string
	Hobbies []string
}

var profiles = []profile{
	{Name: "N", Hobbies: []string{"sports", "arts", "travelling"}},
	{Name: "P", Hobbies: []string{"gaming", "cooking", "alternative"}},
	{Name: "K", Hobbies: []string{"hiking", "football", "dancing"}},
	{Name: "M", Hobbies: []string{"math competitions", "tennis", "hiking"}},
	{Name: "S", Hobbies: []string{"dancing", "sports", "photography"}},
}

func GetProfileList(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(profiles); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func GetProfileByID(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		parts := strings.Split(r.URL.String(), "/")
		if len(parts) < 3 {
			w.WriteHeader(http.StatusBadRequest)
			w.Write([]byte("unrecognized url pattern"))
			return
		}
		id, err := strconv.Atoi(parts[2])
		if err != nil {
			GetProfileList(w,r)
			w.Write([]byte("no profile id given --> redirected to all profiles"))
			return
		}
		if id > len(profiles)-1 {
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte("no such entry among profiles"))
			return
		}
		w.Header().Set("Content-Type", "application/json")
		if err := json.NewEncoder(w).Encode(profiles[id]); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	} else {
		w.WriteHeader(http.StatusMethodNotAllowed)
		w.Write([]byte("method not allowed"))
	}
}