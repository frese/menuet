package main

import (
	"time"

	"github.com/caseymrm/menuet"
)

func helloClock() {
	menuet.App().SetupUserNotifications()

	for {
		menuet.App().SetMenuState(&menuet.MenuState{
			Title: "Hello World " + time.Now().Format(":05"),
		})

		time.Sleep(5 * time.Second)
		menuet.App().SetupUserNotifications()

		menuet.App().UserNotification(menuet.UserNotification{
			Identifier: "123", Title: "Hello", Subtitle: "World", Message: "We're here now.",
		})
	}
}

func main() {
	go helloClock()
	menuet.App().RunApplication()
}
