// Command fixture is the Go code the security.yml gates are dogfooded on.
package main

import (
	"fmt"

	"golang.org/x/text/language"
)

func main() {
	tags, _, _ := language.ParseAcceptLanguage("en-GB")
	fmt.Println("fixture", tags)
}
