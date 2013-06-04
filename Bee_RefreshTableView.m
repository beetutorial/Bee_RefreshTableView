//
//  Bee_RefreshTableView.m
//  SinaFinance
//
//  Created by sang on 5/30/13.
//
//

#import "Bee_RefreshTableView.h"
 

@interface Bee_RefreshTableView()
{
    BOOL _reloading;
    CGRect _frame;
}

@end

@implementation Bee_RefreshTableView

@synthesize lastUpdatedDate;

@synthesize pageNumber;
@synthesize pageSize;

#pragma mark - data
@synthesize result_array;


@synthesize viewForHeaderInSection;
@synthesize viewForFooterInSection;

#pragma mark - block
@synthesize didSelectBlock;
@synthesize didSelectAction;
@synthesize heightForRowAtIndexPath;
@synthesize heightForHeaderInSection;
@synthesize heightForFooterInSection;

@synthesize rowCount;
@synthesize sectionsCount;

@synthesize cellForRowBlock;
@synthesize cellIdentifier;
@synthesize cellselectionStyle;
@synthesize refresh_call_back_handler;

@synthesize nextPage;

 
- (id)init
{
    self = [super init];
    if (self)
    {
        [self add_refresh_header_view];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self add_refresh_header_view];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self add_refresh_header_view];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self add_refresh_header_view];
    }
    return self;
}


- (void)add_refresh_header_view
{
    if (self.refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
        view.delegate = self;
        [self addSubview:view];
        self.refreshHeaderView = view;
        [view release];
    }
    self.refreshHeaderView.delegate = self;
    
    
    if (self.loadMoreFooterView == nil) {
        EGOLoadMoreTableFooterView *view = [[EGOLoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.contentSize.height, self.frame.size.width, self.bounds.size.height)];
        view.delegate = self;
        [self addSubview:view];
        self.loadMoreFooterView = view;
        [view release];
    }

    self.loadMoreFooterView.delegate = self;
    
    
    //  update the last update date
    [self check_date_now];
    
    self.result_array = [NSMutableArray array];
    
    self.pageNumber = 1;
    self.pageSize = 20;
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)check_date_now
{
    [self.refreshHeaderView refreshLastUpdatedDate];
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)set_delegate:(id)mydelegate
{
    self.dataSource = mydelegate;
    self.delegate = mydelegate;
}

- (void)reload_data_with_one_section:(NSArray *)new_result_array{
    if ([new_result_array isKindOfClass:[NSArray class]]) {
        self.result_array = [NSMutableArray arrayWithArray:new_result_array];
    }
    
    [self reloadData];
}

-(void)set_pull_down_enable:(Boolean)is_pull_down{
    if (!is_pull_down) {
        self.refreshHeaderView.hidden = YES;
        self.refreshHeaderView.delegate = self;
    }else{
        self.refreshHeaderView.hidden = NO;
        self.refreshHeaderView.delegate = self;
    }
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
	_reloading = YES;
    // TO be implemented
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    
    if (self.refresh_call_back_handler)
    {
        self.refresh_call_back_handler(self);
    }
}

- (void)doneLoadingTableViewData {
	//  model should call this when its done loading
	_reloading = NO;
	[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    [self.loadMoreFooterView egoLoadMoreScrollViewDataSourceDidFinishedLoading:self];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

 

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    self.lastUpdatedDate = [NSDate date];
	return self.lastUpdatedDate; // should return date data source was last changed
}


#pragma mark -
#pragma mark EGOLoadMoreTableFooterDelegate Methods

- (void)egoLoadMoreTableFooterDidTriggerLoad:(EGOLoadMoreTableFooterView *)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoLoadMoreTableFooterDataSourceIsLoading:(EGOLoadMoreTableFooterView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoLoadMoreTableFooterDataSourceLastUpdated:(EGOLoadMoreTableFooterView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
- (BOOL)egoLoadMoreTableFooterViewDefaultIsShowing:(EGOLoadMoreTableFooterView *)view{
    return YES;
}



#pragma mark - 自动刷新
// TODO: 自动刷新,未实现
- (void)start_check_refresh{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(is_need_to_reload) object:nil];
    [self performSelector:@selector(is_need_to_reload) withObject:nil afterDelay:0.01 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}


-(void)is_need_to_reload
{
    if ([self checkRefreshByDate]) {
        CC(@"checkRefreshByDate=YES,and reloadTableViewDataSource starting...");
        [self reloadTableViewDataSource];
    }
}

-(BOOL)checkRefreshByDate
{
    return [self checkRefreshByDate:10];
}

-(BOOL)checkRefreshByDate:(NSTimeInterval)timeInterval
{
    BOOL rtval = NO;
    NSDate* oldDate = self.lastUpdatedDate;
    if (oldDate) {
        NSTimeInterval length = [oldDate timeIntervalSinceDate:[NSDate date]];
        length = abs(length);
        if (length>timeInterval) {
            rtval = YES;
        }
    }
    else
        rtval = YES;
    return rtval;
}

- (void)add_need_reload_tip_view
{ 
//    UIImageView *v = [[UIImageView alloc] initWithFrame:self.frame];
//    [v setImage:__TABLE_BOARD_IMAGE(@"need_reload.png")];
//    v.tag = 10000;
//    [self addSubview:v];
}

@end
