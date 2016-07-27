package main

import (
	"fmt"
	"net/http"
	"os"
	"strings"
)

func main() {

	var err error

	// we can only ever exit in failure. User has to SIGTERM or SIGKILL to stop a successful instance.
	defer os.Exit(1)

	http.Handle("/", http.FileServer(http.Dir("./")))

	err = http.ListenAndServe(":80", nil)
	if err != nil && strings.Contains(err.Error(), "permission") {

		fmt.Printf("Bind permission when trying to serve on :80 (are you sudo?). Serving on :8080 instead.\n")

		err = http.ListenAndServe(":8080", nil)
		fmt.Printf("%v\n", err)
	}

	fmt.Printf("Failed to bind. %v\n", err)
}
