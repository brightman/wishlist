//
//  TPGestureTableViewCell.m
//  BID
//
//  Created by YoungShook on 13-7-6.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//

#import "TPGestureTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#import "User.h"

@interface SeperateLine : UIView

@end

@implementation SeperateLine

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:0.725 green:0.596 blue:0.310 alpha:1.000].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,0, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextStrokePath(context);
}

@end

#define kMinimumVelocity  self.contentView.frame.size.width*1.5
#define kMinimumPan       60.0
#define kBOUNCE_DISTANCE  7.0

//滑动方向
typedef enum {
    LMFeedCellDirectionNone=0,
	LMFeedCellDirectionRight,
	LMFeedCellDirectionLeft,
} LMFeedCellDirection;

@interface TPGestureTableViewCell ()

//Cell Flag
@property (nonatomic,retain) UIPanGestureRecognizer *panGesture;
@property (nonatomic,assign) CGFloat initialHorizontalCenter;
@property (nonatomic,assign) CGFloat initialTouchPositionX;

@property (nonatomic,assign) LMFeedCellDirection lastDirection;
@property (nonatomic,assign) CGFloat originalCenter;

//Cell UI
@property (nonatomic,retain) SeperateLine *seperateLine;
@property (nonatomic,retain) UIView *bottomRightView;
@property (nonatomic,retain) UIView *bottomLeftView;


@end


@implementation TPGestureTableViewCell
@synthesize delegate;
@synthesize initialHorizontalCenter=_initialHorizontalCenter;
@synthesize initialTouchPositionX=_initialTouchPositionX;
@synthesize bottomLeftView=_bottomLeftView;
@synthesize bottomRightView=_bottomRightView;
@synthesize seperateLine=_seperateLine;
@synthesize itemData=_itemData;


-(void)dealloc{
    self.itemData=nil;
    self.titleTextView=nil;
    self.panGesture=nil;
    self.bottomRightView=nil;
    self.bottomLeftView=nil;
    self.seperateLine=nil;
    self.doneFlagView = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        _currentStatus=kFeedStatusNormal;
        
        UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
        bg.image = [UIImage imageNamed:@"list_bg@2x.png"];
        [self.contentView addSubview:bg];
        
        _titleTextView = [[UITextField alloc]initWithFrame:CGRectZero];
        _titleTextView.backgroundColor = [UIColor clearColor];
        _titleTextView.textColor = [UIColor colorWithRed:0.416 green:0.298 blue:0.075 alpha:1.000];
        _titleTextView.font = [UIFont fontWithName:@"Noteworthy" size:18.0f];
        [self.contentView addSubview:_titleTextView];
        
        _doneFlagView = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.center.y, 30, 20)];
        _doneFlagView.backgroundColor = [UIColor clearColor];
        _doneFlagView.image = [UIImage imageNamed:@"icon_done@2x"];
        _doneFlagView.hidden = YES;
        [self.contentView addSubview:_doneFlagView];
        
        
        _originalCenter=ceil(self.bounds.size.width / 2);
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
		_panGesture.delegate = self;
        [self addGestureRecognizer:_panGesture];
        
    }
    return self;
}


-(void)layoutBottomView{
    if(!self.bottomRightView){
        _bottomRightView = [[UIView alloc]initWithFrame:CGRectMake(70, 0, self.bounds.size.width-80, self.bounds.size.height)];
        /*UIButton *shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share@2x.png"] forState:UIControlStateNormal];
        shareBtn.highlighted = YES;
        [shareBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            
        }];*/
        
        UIButton *sameBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [sameBtn setBackgroundImage:[UIImage imageNamed:@"icon_same@2x.png"] forState:UIControlStateNormal];
        sameBtn.highlighted = YES;
        [sameBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            
        }];
        
        UIButton *supportBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [supportBtn setBackgroundImage:[UIImage imageNamed:@"icon_support@2x.png"] forState:UIControlStateNormal];
        supportBtn.highlighted = YES;
        [supportBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            
        }];
        
        supportBtn.frame = CGRectMake(40, 0, 30, 48);
        sameBtn.frame = CGRectMake(115,0 , 30, 48);
        //shareBtn.frame = CGRectMake(190, 0, 30, 48);
        
        //[_bottomRightView addSubview:shareBtn];
        [_bottomRightView addSubview:sameBtn];
        [_bottomRightView addSubview:supportBtn];
        
        //[shareBtn addTarget:self action:@selector(baidushare) forControlEvents:UIControlEventTouchUpInside];
        
        //_bottomRightView.backgroundColor = [UIColor colorWithRed:0.694 green:0.596 blue:0.376 alpha:1.000];
        _bottomRightView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.300];
        [self insertSubview:_bottomRightView atIndex:0];
    }
    if(!self.bottomLeftView){
        _bottomLeftView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height)];
          _bottomLeftView.backgroundColor =  [UIColor colorWithRed:0.922 green:0.800 blue:0.478 alpha:1.000];
        [self insertSubview:_bottomLeftView atIndex:0];
    }
}

-(void)setItemData:(Wish *)itemData{
    [itemData retain];
    [_itemData release];
    _itemData=itemData;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _titleTextView.frame = CGRectMake(50, 15, 300, 30);
    _titleTextView.text = _itemData.title;
    
    if(_itemData.isDone==YES){
        _doneFlagView.hidden=NO;
    }
    else{
        _doneFlagView.hidden=YES;
    }
}


- (void)togglePanelWithFlag{
    switch (_currentStatus) {
        case kFeedStatusLeftExpanding:
        {
            _bottomRightView.alpha=0.0f;
            _bottomLeftView.alpha=1.0f;
        }
            break;
        case kFeedStatusRightExpanding:
        {
            _bottomRightView.alpha=1.0f;
            _bottomLeftView.alpha=0.0f;
        }
            break;
        case kFeedStatusNormal:{
            [_bottomRightView removeFromSuperview];
            self.bottomRightView=nil;
            [_bottomLeftView removeFromSuperview];
            self.bottomLeftView=nil;
        }
        default:
            break;
    }

}

- (void)panGestureHandle:(UIPanGestureRecognizer *)recognizer
{

    //begin pan...
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        _initialTouchPositionX = [recognizer locationInView:self].x;
        _initialHorizontalCenter = self.contentView.center.x;
        if(_currentStatus==kFeedStatusNormal){
            [self layoutBottomView];
        }
        if ([self.delegate respondsToSelector:@selector(cellDidBeginPan:)]){
            [self.delegate cellDidBeginPan:self];
        }
        
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged) { //status change
        
        
        CGFloat panAmount  = _initialTouchPositionX - [recognizer locationInView:self].x;
        CGFloat newCenterPosition     = _initialHorizontalCenter - panAmount;
        CGFloat centerX               = self.contentView.center.x;

        
        if(centerX>_originalCenter && _currentStatus!=kFeedStatusLeftExpanding){
            _currentStatus = kFeedStatusLeftExpanding;
            [self togglePanelWithFlag];
        }
        else if(centerX<_originalCenter && _currentStatus!=kFeedStatusRightExpanding){
            _currentStatus = kFeedStatusRightExpanding;
            [self togglePanelWithFlag];

        }
        
        if (panAmount > 0){
            _lastDirection = LMFeedCellDirectionLeft;
        }
        else{
            _lastDirection = LMFeedCellDirectionRight;
        }
        
        if (newCenterPosition > self.bounds.size.width + _originalCenter){
            newCenterPosition = self.bounds.size.width + _originalCenter;
        }
        else if (newCenterPosition < -_originalCenter){
            newCenterPosition = -_originalCenter;
        }
        CGPoint center = self.contentView.center;
        center.x = newCenterPosition;
        self.contentView.layer.position = center;
        
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
            recognizer.state == UIGestureRecognizerStateCancelled){
        
        CGPoint translation = [recognizer translationInView:self];
        CGFloat velocityX = [recognizer velocityInView:self].x;
        
        //判断是否push view
        BOOL isNeedPush = (fabs(velocityX) > kMinimumVelocity);
        

        isNeedPush |= ((_lastDirection == LMFeedCellDirectionLeft && translation.x < -kMinimumPan) ||
                       (_lastDirection== LMFeedCellDirectionRight && translation.x > kMinimumPan));
        
        if (velocityX > 0 && _lastDirection == LMFeedCellDirectionLeft){
            isNeedPush = NO;
        }
        
        else if (velocityX < 0 && _lastDirection == LMFeedCellDirectionRight){
            isNeedPush = NO;
        }
        
        if (isNeedPush && !self.revealing) {
            
            if(_lastDirection==LMFeedCellDirectionRight){
                _currentStatus = kFeedStatusLeftExpanding;
                [self togglePanelWithFlag];
                
            }
            else{
                _currentStatus = kFeedStatusRightExpanding;
                [self togglePanelWithFlag];
            }
            [self _slideOutContentViewInDirection:_lastDirection];
            [self _setRevealing:YES];
            
        }
        else if (self.revealing && translation.x != 0) {
            
            LMFeedCellDirection direct = _currentStatus==kFeedStatusRightExpanding?LMFeedCellDirectionLeft:LMFeedCellDirectionRight;
            
            [self _slideInContentViewFromDirection:direct];
            [self _setRevealing:NO];
            
        }
        else if (translation.x != 0) {
            // Figure out which side we've dragged on.
            LMFeedCellDirection finalDir = LMFeedCellDirectionRight;
            if (translation.x < 0)
                finalDir = LMFeedCellDirectionLeft;
            [self _slideInContentViewFromDirection:finalDir];
            [self _setRevealing:NO];
        }
    }
    
}

#pragma mark -
#pragma mark revealing setter
- (void)setRevealing:(BOOL)revealing
{
	if (_revealing == revealing) {
		return;
    }
	[self _setRevealing:revealing];
	
	if (self.revealing) {
		[self _slideOutContentViewInDirection:_lastDirection];
	} else {
		[self _slideInContentViewFromDirection:_lastDirection];
    }
}

- (void)_setRevealing:(BOOL)revealing
{
	_revealing=revealing;
	if (self.revealing && [self.delegate respondsToSelector:@selector(cellDidReveal:)])
		[self.delegate cellDidReveal:self];
}

#pragma mark
#pragma mark - ContentView Sliding
- (void)_slideInContentViewFromDirection:(LMFeedCellDirection)direction
{
    
	CGFloat bounceDistance = 0.0;

	if (self.contentView.center.x == _originalCenter)
		return;
	
	switch (direction) {
		case LMFeedCellDirectionRight:
			bounceDistance = kBOUNCE_DISTANCE;
			break;
		case LMFeedCellDirectionLeft:
			bounceDistance = -kBOUNCE_DISTANCE;
			break;
		default:
			break;
	}
	
	[UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction
					 animations:^{
                         self.contentView.center = CGPointMake(_originalCenter, self.contentView.center.y);
                     }
					 completion:^(BOOL f) {
						 [UIView animateWithDuration:0.1 delay:0
											 options:UIViewAnimationOptionCurveEaseOut
										  animations:^{ self.contentView.frame = CGRectOffset(self.contentView.frame, bounceDistance, 0); }
										  completion:^(BOOL f) {
                                              [UIView animateWithDuration:0.1 delay:0
                                                                  options:UIViewAnimationOptionCurveEaseIn
                                                               animations:^{ self.contentView.frame = CGRectOffset(self.contentView.frame, -bounceDistance, 0); }
                                                               completion:^(BOOL f){
                                                                   _currentStatus=kFeedStatusNormal;
                                                                   [self togglePanelWithFlag];
                                                               }];
                                          }];
                     }];
}

- (void)_slideOutContentViewInDirection:(LMFeedCellDirection)direction;
{
	CGFloat newCenterX = 0.0;
    CGFloat bounceDistance = 0.0;
    switch (direction) {
        case LMFeedCellDirectionLeft:{
            newCenterX = - _originalCenter/2;
            bounceDistance = -kBOUNCE_DISTANCE;
            _currentStatus=kFeedStatusLeftExpanded;
        }
            break;
        case LMFeedCellDirectionRight:{
            newCenterX = self.contentView.frame.size.width + _originalCenter/2;
            bounceDistance = kBOUNCE_DISTANCE;
            _currentStatus=kFeedStatusRightExpanded;
        }
            break;
        default:
            break;
    }
    
	[UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
                         self.contentView.center = CGPointMake(newCenterX, self.contentView.center.y);
                     }
                     completion:^(BOOL f) {
						 [UIView animateWithDuration:0.1 delay:0
											 options:UIViewAnimationOptionCurveEaseIn
										  animations:^{
                                              self.contentView.frame = CGRectOffset(self.contentView.frame, -bounceDistance, 0);
                                          }
										  completion:^(BOOL f) {
											  [UIView animateWithDuration:0.1 delay:0
                                                                  options:UIViewAnimationOptionCurveEaseIn
                                                               animations:^{
                                                                   self.contentView.frame = CGRectOffset(self.contentView.frame, bounceDistance, 0);
                                                               }
                                                               completion:NULL];
										  }];
                     }];
}

#pragma mark
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer == _panGesture) {
		UIScrollView *superview = (UIScrollView *)self.superview;
		CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:superview];
		// Make it scrolling horizontally
		return ((fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO &&
                (superview.contentOffset.y == 0.0 && superview.contentOffset.x == 0.0));
	}
	return YES;
}




@end
