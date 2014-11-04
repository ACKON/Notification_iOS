//
//  AppDelegate.m
//  Notification
//
//  Created by Hayden on 2014. 10. 29..
//  Copyright (c) 2014년 OliveStory. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<UIAlertViewDelegate>
@property (nonatomic, strong) NSDictionary *alertViewSender;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){//iOS8에서는 로컬노티피케이션을 띄울때도 사용자노티피케이션세팅을 등록해야 합니다.
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //노티피케이션 전달 받을시 alert화면 띄우기.
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"노티피케이션" message:notification.userInfo[@"link"] delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    self.alertViewSender = notification.userInfo;
    [alertView show];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView){
        if(buttonIndex==1){
            NSURL *url = [NSURL URLWithString:self.alertViewSender[@"link"]];
            if([[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        self.alertViewSender = nil;
    }
}
@end
