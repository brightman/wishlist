//
//  UserWish.m
//  BID
//
//  Created by brightman on 13-7-5.
//  Copyright (c) 2013年 brightman. All rights reserved.
//

#import "UserWish.h"
#import "ASIHTTPRequest.h"

NSString *host = @"http://beforeidie.duapp.com";
NSString *creatuserurl = @"/v1/user";
NSString *addwishurl = @"/v1/wish/add";
NSString *supportwishurl = @"/v1/wish/support";
NSString *ownwishurl = @"/v1/wish/own";
NSString *wishlisturl = @"/v1/wishlist";

@implementation UserWish
@synthesize _uid;
@synthesize _wishlist;
@synthesize _randomwishlist;

- (void) CreateUser:(NSString *)name{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host,creatuserurl]];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:20.0f];

    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSLog(@"responseString:%@",responseString);
        if ([responseString rangeOfString:@"beforeidie.duapp.com"].location != NSNotFound) {
            
        }else{
            
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}

- (void) AddWish:(NSString *)title withCost:(NSNumber *)cost uptodate:(NSDate *)uptodate{
                      
}

- (BOOL) PubWish:(NSInteger)wid withPub:(Boolean)pub{
    return TRUE;
}

- (BOOL) SupportWish:(NSInteger)wid{
    return TRUE;
}

- (BOOL) OwnWish:(NSInteger)wid{
    return TRUE;
}

- (NSDictionary *) Wishlist{
    NSDictionary * result = [NSDictionary alloc];
    return result;
}

- (NSDictionary *) RandWishlist{
    NSDictionary * result = [NSDictionary alloc];
    return result;
}

@end
