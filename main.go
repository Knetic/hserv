package main

import (
    "net/http"
	"fmt"
	"strings"
)

func main() {

	var err error

    http.Handle("/", http.FileServer(http.Dir("./")))

	err = http.ListenAndServe(":80", nil)
	if(err != nil && strings.Contains(err.Error(), "permission")) {

		fmt.Printf("Bind permission when trying to serve on :80 (are you sudo?). Serving on :8080 instead.\n")

		err = http.ListenAndServe(":8080", nil)
		fmt.Printf("%v\n", err)
	}
}
