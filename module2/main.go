package main

import (
	"fmt"
	"net/http"
	"os"
	"strings"
)

func main() {
	http.HandleFunc("/", readVersion)
	http.ListenAndServe("0.0.0.0:80", nil)
}

func readVersion(w http.ResponseWriter, r *http.Request) {
	statusCode := http.StatusOK

	for key, vals := range r.Header {
		for _, val := range vals {
			w.Header().Add(key, val)
		}
	}

	v, _ := os.LookupEnv("VERSION")
	w.Header().Add("VERSION", v)

	remoteIP := r.RemoteAddr
	elems := strings.Split(r.RemoteAddr, ":")
	if len(elems) > 0 {
		remoteIP = elems[0]
	}

	w.WriteHeader(statusCode)

	fmt.Printf("client-ip: %s, http-status-code: %d\n", remoteIP, statusCode)
}
