package main

import (
	"flag"
	"fmt"
	"math/rand"
	"net"
	"time"
)

var target string

func main() {
	flag.StringVar(&target, "t", "", "目标")
	flag.Parse()
	fmt.Println(IsWildCard(target))
}

func RandomStr(n int) string {
	var letterRunes = []rune("abcdefghijklmnopqrstuvwxyz1234567890")
	rand.Seed(time.Now().UnixNano())
	b := make([]rune, n)
	for i := range b {
		b[i] = letterRunes[rand.Intn(len(letterRunes))]
	}
	return string(b)
}

func IsWildCard(domain string) int {
	for i := 0; i < 5; i++ {
		subdomain := RandomStr(6) + "." + domain
		_, err := net.LookupIP(subdomain)
		if err != nil {
			continue
		}
		return 1
	}
	return 0
}
