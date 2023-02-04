package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"

	"github.com/tidwall/gjson"
)

func GetCorporateName(url string, id int, flag int, Number int, Percentage float64) string {
	req_url := url + strconv.Itoa(id)
	client := &http.Client{}
	req, _ := http.NewRequest("GET", req_url, nil)

	rep, err := client.Do(req)
	if err != nil {
		fmt.Print(err)
	}
	defer rep.Body.Close()
	body, _ := ioutil.ReadAll(rep.Body)
	rep_json := string(body)

	investorList := gjson.Get(rep_json, "data.investorList")
	for _, i := range investorList.Array() {
		if i.Get("percentFloat").Float() >= Percentage {
			fmt.Println(i.Get("name"))
			if i.Get("hasNode").Bool() && flag < Number {
				GetCorporateName(url, int(i.Get("id").Num), flag+1, Number, Percentage)

			}
		}

	}
	return rep_json
}

func main() {

	baseurl := "https://capi.tianyancha.com/cloud-equity-provider/v4/equity/indexnode.json?id="
	var Companyid int
	var Number int
	var Percentage float64
	flag.IntVar(&Companyid, "i", 0, "Company id")
	flag.IntVar(&Number, "n", 3, "递归层数，默认: 3")
	flag.Float64Var(&Percentage, "p", 0.9, "控股占比，默认: 0.9")
	flag.Parse()
	rep_json := GetCorporateName(baseurl, Companyid, 0, Number, Percentage)
	fmt.Println(gjson.Get(rep_json, "data.name"))

}
