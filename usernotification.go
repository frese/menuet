package menuet

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework Cocoa -framework UserNotifications

#import <Cocoa/Cocoa.h>

#ifndef __USERNOTIFICATION_H_H__
#import "usernotification.h"
#endif

void requestUserNotifications();
void showUserNotification(const char *jsonString);

*/
import "C"
import (
	"encoding/json"
	"log"
	"unsafe"
)

// Notification represents an NSUserNotification
type UserNotification struct {
	// Duplicate identifiers do not re-display, but instead update the notification center
	Identifier string

	// The basic text of the notification
	Title    string
	Subtitle string
	Message  string
	IconURL  string

	// These add an optional action button, change what the close button says, and adds an in-line reply
	ActionButton        string
	CloseButton         string
	ResponsePlaceholder string

	// If true, the notification is shown, but then deleted from the notification center
	RemoveFromNotificationCenter bool
}

func (a *Application) SetupUserNotifications() {
	_, bundlePath := appPath()
	log.Printf("bundlePath: %s", bundlePath)
	if bundlePath == "" {
		log.Printf("Warning: notifications won't show up unless running inside an application bundle")
	}

	C.requestUserNotifications()
}

// Notification shows a notification to the user. Note that you have to be part of a proper application bundle for them to show up.
func (a *Application) UserNotification(notification UserNotification) {
	b, err := json.Marshal(notification)
	if err != nil {
		log.Printf("Marshal: %v", err)
		return
	}
	cstr := C.CString(string(b))
	C.showUserNotification(cstr)
	C.free(unsafe.Pointer(cstr))
}
