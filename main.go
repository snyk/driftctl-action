package main

import (
	"encoding/json"
	"fmt"
	"github.com/newrelic/go-agent"
	"io/ioutil"
	"log"
	"os"
	"time"
)

var newRelicApp newrelic.Application

type DrifctlSummary struct {
	TotalResources int `json:"total_resources"`
	TotalChanged int `json:"total_changed"`
	TotalUnmanaged int `json:"total_unmanaged"`
	TotalMissing int `json:"total_missing"`
	TotalManaged int `json:"total_managed"`
}

func main() {
	newRelicEventType := os.Getenv("INPUT_EVENT_TYPE_NAME")
	newRelicLicenseKey := os.Getenv("INPUT_NEW_RELIC_LICENCE_KEY")
	github_repository := os.Getenv("INPUT_GITHUB_REPOSITORY")
	github_run_id := os.Getenv("INPUT_GITHUB_RUN_ID")
	stage := os.Getenv("INPUT_ENV")
	summary := parseSummaryDrifctlOutput(os.Args[1])
	app := initNewRelicClient(newRelicLicenseKey)
	gha_url := fmt.Sprintf("https://github.com/%s/actions/runs/%s", github_repository, github_run_id)

	if err := app.RecordCustomEvent(newRelicEventType,map[string]interface{}{
		"env": stage,
		"total_resources": summary.TotalResources,
		"total_changed": summary.TotalChanged,
		"total_unmanaged" : summary.TotalUnmanaged,
		"total_managed" : summary.TotalManaged,
		"total_missing" : summary.TotalMissing,
		"ghaUrl": gha_url,
	}); err != nil {
		log.Println("error in creating New Relic custom event: ", err)
		return
	}
	app.Shutdown(5 * time.Second)

	fmt.Println(fmt.Sprintf(`::set-output name=total_resources::%s`, summary.TotalResources))
	fmt.Println(fmt.Sprintf(`::set-output name=total_changed::%s`, summary.TotalChanged))
	fmt.Println(fmt.Sprintf(`::set-output name=total_unmanaged::%s`, summary.TotalUnmanaged))
	fmt.Println(fmt.Sprintf(`::set-output name=total_managed::%s`, summary.TotalManaged))
	fmt.Println(fmt.Sprintf(`::set-output name=total_missing::%s`, summary.TotalMissing))
}

func parseSummaryDrifctlOutput(fileName string) DrifctlSummary {
	jsonFile, err := os.Open(fileName)
	if err != nil {
		log.Println("Unable to read Drifctl Output Summary: ", err)
	}
	byteValue, _ := ioutil.ReadAll(jsonFile)
	var summary DrifctlSummary
	json.Unmarshal(byteValue, &summary)
	defer jsonFile.Close()
	return summary
}

func initNewRelicClient(newRelicLicenseKey string) newrelic.Application {
	config := newrelic.NewConfig("GithubActionsMonitoring", newRelicLicenseKey)
	newRelicApp, err := newrelic.NewApplication(config)
	if err != nil {
		log.Println("error in creating new relic application: ", err)
		panic(err)
	}
	newRelicApp.WaitForConnection(5 * time.Second)
	return newRelicApp
}