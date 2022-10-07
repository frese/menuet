#import <stdio.h>
#import <Cocoa/Cocoa.h>
#import <UserNotifications/UserNotifications.h>
#import <objc/runtime.h>

void requestUserNotifications() {

 	// [UNUserNotificationCenter currentNotificationCenter].delegate = self;

	UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
	UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
	[center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError *error) {
		if (!granted) {
			NSLog(@"Error granting notification options: %@", error);
		}
	}];

	[center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
		// Authorization status of the UNNotificationSettings object
		switch (settings.authorizationStatus) {
		case UNAuthorizationStatusAuthorized:
			NSLog(@"UNNotificationSettings Status Authorized");
			break;
		case UNAuthorizationStatusDenied:
			NSLog(@"UNNotificationSettings Status Denied");
			break;
		case UNAuthorizationStatusNotDetermined:
			NSLog(@"UNNotificationSettings Status Undetermined");
			break;
		default:
			break;
		}

		// Status of specific settings
		if (settings.alertSetting != UNAuthorizationStatusAuthorized) {
			NSLog(@"Alert settings not authorized");
		}

		if (settings.badgeSetting != UNAuthorizationStatusAuthorized) {
			NSLog(@"Badge settings not authorized");
		}

		if (settings.soundSetting != UNAuthorizationStatusAuthorized) {
			NSLog(@"Sound settings not authorized");
		}
	}];
}

void showUserNotification(const char *jsonString) {
	NSDictionary *jsonDict = [NSJSONSerialization
	                          JSONObjectWithData:[[NSString stringWithUTF8String:jsonString]
	                                              dataUsingEncoding:NSUTF8StringEncoding]
	                          options:0
	                          error:nil];

	UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = jsonDict[@"Title"];
	content.subtitle = jsonDict[@"Subtitle"];
    content.body = jsonDict[@"Message"];
	// UNNotificationAttachment *attachment = [UNNotificationAttachment identifier:"123" URL:jsonDict[@"IconURL"] type:kUTTypePNG];
	// content.attachment = *attachment;

    // content.sound = [UNNotificationSound defaultSound];


    // UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:jsonDict[@"Identifier"] content:content trigger:nil];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            printf("NOTIFICATION SUCCESS !!!\n");
        }
    }];

}
