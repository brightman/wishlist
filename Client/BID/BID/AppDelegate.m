//
//  AppDelegate.m
//  BID
//
//  Created by YoungShook on 13-7-6.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//

#import "AppDelegate.h"
#import "MyWishListC.h"
#import "MotionResponse.h"
#import <BaiduSocialShare/BDSocialShareSDK.h>
@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[MotionResponse alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [USER_DEFAULTS setObject:AppVersion forKey:@"DevVersion"];
    //定义分享平台数组
    NSArray *platforms = [NSArray arrayWithObjects:kBD_SOCIAL_SHARE_PLATFORM_SINAWEIBO,kBD_SOCIAL_SHARE_PLATFORM_KAIXIN,kBD_SOCIAL_SHARE_PLATFORM_RENREN,kBD_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION,kBD_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE,
                          kBD_SOCIAL_SHARE_PLATFORM_EMAIL,
                          kBD_SOCIAL_SHARE_PLATFORM_SMS,nil];
    //初始化分享组件
    [BDSocialShareSDK registerApiKey:@"xcVWaIqqGVxxux7P9UiDLiRZ" andSupportPlatforms:platforms];
    
    //初始化微信
    [BDSocialShareSDK registerWXApp:@"wxcf07d62b9597a59f"];
    
    //设置新浪微博和QQ客户端的app id，使用SSO功能
    [BDSocialShareSDK enableSinaWeiboSSOWithAppId:@"3021614187"];
    
    self.window.backgroundColor = [UIColor blackColor];
    MyWishListC *myWishListC = [[MyWishListC new]autorelease];
    self.window.rootViewController = myWishListC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [BDSocialShareSDK handleOpenURL:url];
}

@end
