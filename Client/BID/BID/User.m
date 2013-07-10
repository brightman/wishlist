//
//  User.m
//  BID
//
//  Created by YoungShook on 13-7-6.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//

#import "User.h"
#import "Wish.h"
#import "ASIHTTPRequest.h"
#import "OpenUDID.h"
NSString *userurl = @"http://beforeidie.duapp.com/v1/user/1";

//添加用户
NSString *adduserurl = @"http://beforeidie.duapp.com/v1/user/add";

//添加愿望
NSString *addwishurl = @"http://beforeidie.duapp.com/v1/wish/add";

//支持愿望
NSString *supportwishurl = @"http://beforeidie.duapp.com/v1/wish/support/";


//共有愿望
NSString *ownwishurl = @"http://beforeidie.duapp.com/v1/user/";

//愿望列表
NSString *wishlisturl = @"http://beforeidie.duapp.com/v1/wishlist/";

//修改愿望
NSString *updatelisturl = @"http://beforeidie.duapp.com/v1/wish/change/";

//完成愿望
NSString *completelisturl = @"http://beforeidie.duapp.com/v1/wish/complete/";

//分享愿望
NSString *publiclisturl = @"http://beforeidie.duapp.com/v1/wish/public/";

static User *sharedUser = nil;

@implementation User

//UserWish单例
//SYNTHESIZE_SINGLETON_FOR_CLASS(User)

+(User *)shared {
    @synchronized(self) {
        if (sharedUser == nil) {
            sharedUser = [[self alloc] init];
            sharedUser._userDefaults = [NSUserDefaults standardUserDefaults];            
        }
    }
    
    return sharedUser;
}


- (void)AddUser:(NSString *)name withSex:(NSString *)sex withDelegate:(id<UserASIDelegate>)delegate{
    NSURL *url = [NSURL URLWithString:adduserurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:20.0f];
    NSDictionary *dic = @{@"uuid":[OpenUDID value],@"name":name,@"sex":sex};
    NSData *data =[[dic JSONString] dataUsingEncoding:NSUTF8StringEncoding];
    [request setPostBody:[NSData dataWithData:data]];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [__userDefaults setBool:TRUE forKey:@"Notfirst"];
        [delegate connection:dic successConType:1];
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}

- (void)AddWish:(Wish*)wish withDelegate:(id<UserASIDelegate>)delegate{
    NSURL *url = [NSURL URLWithString:addwishurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:10.0f];
    NSDictionary *dic = @{@"uuid":[OpenUDID value],@"title":wish.title,@"cost":[NSNumber numberWithInt:3000],@"lng":[NSNumber numberWithInt:30.0],@"lat":[NSNumber numberWithInt:10.0]};
    NSData *data =[[dic JSONString] dataUsingEncoding:NSUTF8StringEncoding];
    [request setPostBody:[NSData dataWithData:data]];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [delegate connection:dic successConType:2];
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}

//修改更新wish
- (void)UpdateWish:(Wish*)wish withDelegate:(id<UserASIDelegate>)delegate{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",updatelisturl,wish.ID]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:20.0f];
    NSDictionary *dic = @{@"title":wish.title,@"cost":[NSNumber numberWithInt:3000],@"uptodate":@"2013-07-11"};
    NSData *data =[[dic JSONString] dataUsingEncoding:NSUTF8StringEncoding];
    [request setPostBody:[NSData dataWithData:data]];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [delegate connection:dic successConType:3];
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}

//得到用户最新的数据
- (void)WishlistwithDelegate:(id<UserASIDelegate>)delegate{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",wishlisturl,[OpenUDID value]]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:10.0f];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [delegate connection:dic successConType:4];
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}

//随即得到陌生人公开的wish数据
- (void)RandWishlistwithDelegate:(id<UserASIDelegate>)delegate{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",wishlisturl,@"0"]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:10.0f];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [delegate connection:dic successConType:4];
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}

//公开wish
- (void)PubWish:(Wish*)wish withPub:(Boolean)pub withDelegate:(id<UserASIDelegate>)delegate{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",publiclisturl,wish.ID]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:10.0f];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [delegate connection:dic successConType:6];
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}

//赞别人wish
- (void)SupportWish:(Wish*)wish withDelegate:(id<UserASIDelegate>)delegate{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",supportwishurl,wish.ID]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:10.0f];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [delegate connection:dic successConType:7];
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}

//共享wish
- (void)OwnWish:(Wish*)wish withDelegate:(id<UserASIDelegate>)delegate{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/wishown/%@",ownwishurl,[OpenUDID value],wish.ID]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:20.0f];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [delegate connection:dic successConType:8];
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}


- (void)dealloc
{
    [__userDefaults synchronize];
    [super dealloc];
}
@end
