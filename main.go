package main

import (
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/robfig/cron/v3"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: cronwhen <cron expression>")
		os.Exit(1)
	}

	cronExpr := strings.Join(os.Args[1:], " ")
	cronParser := cron.NewParser(cron.Minute | cron.Hour | cron.Dom | cron.Month | cron.Dow)
	schedule, err := cronParser.Parse(cronExpr)
	if err != nil {
		fmt.Println("Error parsing cron expression:", err)
		os.Exit(1)
	}

	now := time.Now()
	nextRun := schedule.Next(now)

	fmt.Printf("%v\n", nextRun)
}
