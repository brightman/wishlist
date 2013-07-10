//
//  OtherWishListC.m
//  BID
//
//  Created by brightman on 13-7-10.
//  Copyright (c) 2013年 qfpay. All rights reserved.
//

#import "OtherWishListC.h"
#import "TPGestureTableViewCell.h"
#import "User.h"
#import "Wish.h"


@interface OtherWishListC ()
@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) TPGestureTableViewCell *currentCell;
@end

@implementation OtherWishListC



-(void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    
    [self becomeFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray new];
    
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)reloadWishList{
    [[User shared]RandWishlistwithDelegate:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//返回指定的 row 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 137;
    }
    if (indexPath.row == [_dataArray count] + 1) {
        return 57;
    }
    if (indexPath.row == [_dataArray count] + 2) {
        return 162;
    }
    return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_dataArray count]+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    // Configure the cell...
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellHeader"];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellHeader"]autorelease];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *headerView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 137)]autorelease];
        headerView.image = [UIImage imageNamed:@"shock_title_bg_1@2x"];
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
                [cell addSubview:footerView];
        
        return cell;
    }

    static NSString *cellIdentifier = @"LomemoBasicCell";
    TPGestureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[TPGestureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.delegate=self;
    }
    Wish *item=(Wish*)[_dataArray objectAtIndex:indexPath.row-1];
    cell.itemData = item;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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
#pragma mark network Delegate
- (void)connection:(NSDictionary *)dic successConType:(int)type{
    if (type == 1) {
        
    }else if (type == 2){
        
    }else if (type == 3){
        
    }else if (type == 4){//Get Wish list
        if (![[dic objectForKey:@"ret"]integerValue]) {
            [_dataArray removeAllObjects];
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

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake) {
        //UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"shake" message:@"game over" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
        //[alert show];
        [self reloadWishList];
        
    }
}

@end
