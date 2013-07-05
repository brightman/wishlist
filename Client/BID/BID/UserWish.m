//
//  UserWish.m
//  BID
//
//  Created by brightman on 13-7-5.
//  Copyright (c) 2013年 brightman. All rights reserved.
//

#import "UserWish.h"
#import "AFJSONRequestOperation.h"

NSString *host = @"http://wishlist.do";
NSString *creatuserurl = @"/v1/user/add";
NSString *addwishurl = @"/v1/wish/add";
NSString *supportwishurl = @"/v1/wish/support";
NSString *ownwishurl = @"/v1/wish/own";
NSString *wishlisturl = @"/v1/wishlist";

@implementation UserWish
@synthesize _uid;
@synthesize _wishlist;
@synthesize _randomwishlist;

- (void) CreateUser:(NSString *)uuid withlng:(NSNumber *)lng lat:(NSNumber *)lat{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host,creatuserurl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"CreateUser response: %@", JSON);
        //Parse JSON
        NSNumber *uid = [JSON valueForKey:@"uid"];
        self._uid = uid;
    } failure:nil];
    [operation start];
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
