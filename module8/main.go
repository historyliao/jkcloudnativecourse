package main

import (
	"flag"
	"io/ioutil"
	"net/http"
	"os"
	"strconv"
	"strings"

	"k8s.io/klog/v2"
)

func main() {
	klog.InitFlags(nil)
	defer klog.Flush()

	level, err := ioutil.ReadFile("/workdir/conf/loglevel")
	if err != nil {
		klog.Fatalf("read config failed: %v", err)
	}

	flag.Set("v", string(level))
	flag.Parse()

	pid := os.Getpid()
	if err := ioutil.WriteFile("/workdir/.pidfile", []byte(strconv.Itoa(pid)), 0600); err != nil {
		klog.Fatalf("write pid file failed: %v", err)
	}

	http.HandleFunc("/", readVersion)
	http.ListenAndServeTLS("0.0.0.0:80", "apiserver.pem", "apiserver-key.pem", nil)
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

	klog.Infof("client-ip: %s, http-status-code: %d\n", remoteIP, statusCode)
}
