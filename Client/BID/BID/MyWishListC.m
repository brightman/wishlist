//
//  MyWishListC.m
//  BID
//
//  Created by YoungShook on 13-7-6.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//
#import "MyWishListC.h"
#import "TPGestureTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import <BaiduSocialShare/BDSocialShareSDK.h>
#import "User.h"
#import "Wish.h"
#import "OpenUDID.h"

@interface MyWishListC (){
    MPMoviePlayerController *player;
    UIView *touchView;
}
@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) TPGestureTableViewCell *currentCell;
@end

@implementation MyWishListC

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [self becomeFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [NSMutableArray new];
    User *user = [User shared];
    [user AddUser:@"YoungShook" withSex:@"M" withDelegate:self];
    
    UIImageView *bg = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]autorelease];
    bg.image = [UIImage imageNamed:@"bg@2x.png"];
    [self.view addSubview:bg];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
	_myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height)];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_myTableView];
    [self performSelector:@selector(reloadWishList) withObject:nil afterDelay:0.0];
    if(![user._userDefaults boolForKey:@"Notfirst"]){
        [self splashView];
    }
}

-(void)reloadWishList{
    [[User shared]WishlistwithDelegate:self];
}

#pragma mark
#pragma mark UITableViewDatasource

//返回指定的 row 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 67;
    }
    if (indexPath.row == [_dataArray count] + 1) {
        return 57;
    }
    if (indexPath.row == [_dataArray count] + 2) {
        return 162;
    }
    return 48;
}

//返回 tableview 有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//返回对应的section有多少个元素，也就是多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count]+3;
}

//返回指定的row 的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellHeader"];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellHeader"]autorelease];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *headerView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 67)]autorelease];
        headerView.image = [UIImage imageNamed:@"title_bg@2x"];
        //add share button
        UIButton *shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share@2x.png"] forState:UIControlStateNormal];
        shareBtn.highlighted = YES;
        
        shareBtn.frame = CGRectMake(250, 0, 30, 48);
        [headerView addSubview:shareBtn];
        [shareBtn addTarget:self action:@selector(baidushare) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:headerView];
        return cell;
    }
    
    if (indexPath.row == [_dataArray count]+1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFooter"];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellFooter"]autorelease];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *footerView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 57)]autorelease];
        footerView.image = [UIImage imageNamed:@"bottom_bg@2x"];
        UIButton *seleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        seleBtn.frame = CGRectMake(250,0, 70, 57);
        [seleBtn setBackgroundImage:[UIImage imageNamed:@"add_new@2x.png"] forState:UIControlStateNormal];
        [seleBtn setBackgroundImage:[UIImage imageNamed:@"add_new_a@2x.png"] forState:UIControlStateHighlighted];
        [seleBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            Wish *id = [[Wish new]autorelease];
            id.title = @"add item";
            [_dataArray addObject:id];
            [_myTableView reloadData];
            TPGestureTableViewCell *cell = (TPGestureTableViewCell*)[_myTableView cellForRowAtIndexPath:indexPath];
            [cell.titleTextView becomeFirstResponder];
            //add wish
            [[User shared] AddWish:id withDelegate:self];
        }];
        [cell addSubview:footerView];
        [cell addSubview:seleBtn];
        return cell;
    }
    
    if (indexPath.row == [_dataArray count]+2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellgrass"];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellgrass"]autorelease];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *cellgrassView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 162)]autorelease];
        cellgrassView.image = [UIImage imageNamed:@"grass@2x"];
        [cell addSubview:cellgrassView];
        UIImageView *animatHeadset = [[UIImageView alloc]initWithFrame:CGRectMake(-110, 40, 100, 80)];
        animatHeadset.tag = 0x12;
        NSArray *animImgArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"fly-r-1@2x"],
                                 [UIImage imageNamed:@"fly-r-2@2x"],
                                 [UIImage imageNamed:@"fly-r-3@2x"],
                                 [UIImage imageNamed:@"fly-r-4@2x"],
                                 [UIImage imageNamed:@"fly-r-5@2x"],
                                 [UIImage imageNamed:@"fly-r-6@2x"],
                                 [UIImage imageNamed:@"fly-r-7@2x"],
                                 [UIImage imageNamed:@"fly-r-8@2x"],nil];
        animatHeadset.animationImages = animImgArray;
        animatHeadset.animationDuration = 0.5;
        animatHeadset.animationRepeatCount = 0;
        [animatHeadset startAnimating];
        [UIView animateWithDuration:15 delay:0 options: UIViewAnimationOptionRepeat animations:^{
            animatHeadset.frame = CGRectMake(420, 5, 100, 80);
        }completion:^(BOOL finished) {
            
        }];
        
        [cell addSubview:animatHeadset];
        [animatHeadset release];
        return cell;
    }
    
    static NSString *cellIdentifier = @"LomemoBasicCell";
    TPGestureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[TPGestureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.delegate=self;
        cell.titleTextView.delegate = self;
    }
    Wish *item=(Wish*)[_dataArray objectAtIndex:indexPath.row-1];
    cell.itemData = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == [_dataArray count]+1) {
        return;
    }
    
    if (indexPath.row == [_dataArray count]+2) {
        Wish *id = [[Wish new]autorelease];
        id.title = @"add item";
        [_dataArray addObject:id];
        [_myTableView reloadData];
        
        return;
    }
    
    TPGestureTableViewCell *cell = (TPGestureTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.revealing==YES){
        cell.revealing=NO;
        return;
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark network Delegate
- (void)connection:(NSDictionary *)dic successConType:(int)type{
    if (type == 1) {
        
    }else if (type == 2){
        
    }else if (type == 3){
        
    }else if (type == 4){//Get Wish list
        if (![[dic objectForKey:@"ret"]integerValue]) {
            
            for (NSDictionary *dict in [dic objectForKey:@"wishlist"]) {
                Wish *id = [[Wish new]autorelease];
                id.ID = [dict objectForKey:@"id"];
                id.title = [dict objectForKey:@"title"];
                [_dataArray addObject:id];
            }
            [_myTableView reloadData];
        }
    }else if (type == 5){
        
    }else if (type == 6){
        
    }else if (type == 7){
        
    }else if (type == 8){
        
    }else{
        
    }
}

- (void)connection:(NSDictionary *)dic failConType:(int)type{
    
}


#pragma mark
#pragma mark TPGestureTableViewCellDelegate

- (void)cellDidBeginPan:(TPGestureTableViewCell *)cell{
    
}
//滑动后
- (void)cellDidReveal:(TPGestureTableViewCell *)cell{
    if(self.currentCell!=cell){
        self.currentCell.revealing=NO;
        self.currentCell=cell;
    }
    if (cell.currentStatus == kFeedStatusRightExpanded) {
        NSIndexPath *indexPath = [_myTableView indexPathForCell:cell];
        Wish *item=(Wish*)[_dataArray objectAtIndex:indexPath.row-1];
        item.isDone = !item.isDone;
        cell.itemData=item;
    }
}

#pragma mark -
#pragma mark Play one minute fly video as splash view

-(void)splashView{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preparedToPlay:) name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *moviePath = [bundle pathForResource:@"fly" ofType:@"m4v"];
    
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    player =[[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    player.controlStyle = MPMovieControlStyleNone;
    
    player.scalingMode = MPMovieScalingModeFill;
    
    [player prepareToPlay];
    
    [player.view setFrame:self.view.bounds];
    
    [self.view addSubview:player.view];
    
}

-(void)preparedToPlay:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:[notification object]];
    [self performSelector:@selector(endToPlay) withObject:nil afterDelay:201.50f];
    //[self performSelector:@selector(endToPlay) withObject:nil afterDelay:1.50f];
}

-(void)endToPlay{
    [player pause];
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        player.view.alpha = 0;
    }completion:^(BOOL finished) {
        [player.view removeFromSuperview];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    TPGestureTableViewCell *cell = (TPGestureTableViewCell*)[[textField superview] superview];
    NSIndexPath *indexPath = [_myTableView indexPathForCell:cell];
    Wish *item=(Wish*)[_dataArray objectAtIndex:indexPath.row-1];
    item.title = textField.text;
    [[User shared] UpdateWish:item withDelegate:self];
    return NO;
}

-(void)dealloc{
    self.myTableView=nil;
    self.dataArray=nil;
    self.currentCell=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIDeviceOrientationPortrait);
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake) {
        //UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"shake" message:@"game over" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
        //[alert show];
        [self.view.window sendSubviewToBack:self.view];
    }
}


-(void)baidushare{
    NSLog(@"baidushare");
    BDSocialShareEventHandler result = ^(SHARE_RESULT requestResult, NSString *shareType, id response, NSError *error)
    {
        if (requestResult == BD_SOCIAL_SHARE_SUCCESS) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:[NSString stringWithFormat:@"%@分享成功",shareType] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            NSLog(@"%@分享成功",shareType);
        } else if (requestResult == BD_SOCIAL_SHARE_CANCEL){
            NSLog(@"分享取消");
        } else if (requestResult == BD_SOCIAL_SHARE_FAIL){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@分享失败\n error code:%d;\n error message:%@",shareType,error.code,[error localizedDescription]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            NSLog(@"%@分享失败\n error code:%d;\n error message:%@",shareType,error.code,[error localizedDescription]);
        }
    };
    
    
    BDSocialShareContent *content = [BDSocialShareContent shareContentWithDescription:@"Before I die 不是一个简单的to do list。它是一个也许需要你穷尽一生去实现的to do list。你可以，写下你死前一定要完成的愿望；记下你已经完成的人生成就；查看大家的梦想；将你喜欢的据为己有；分享你的梦想给你的好友；支持你的朋友实现梦想。让我们期待更多！" url:@"http://beforeidie.duapp.com" title:@"Things to do before i die"];
    
    
    
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [content addImageWithImageSource:theImage imageUrl:nil];
    
    
    SHARE_MENU_STYLE style = BD_SOCIAL_SHARE_MENU_THEME_STYLE;
    
    
    [BDSocialShareSDK showShareMenuWithShareContent:content menuStyle:style result:result];
}

@end