//
//  Bee_TableViewBuilder.m
//  bee
//
//  Created by sang on 5/30/13.
//
//

#import "Bee_TableViewBuilder.h"

@implementation Bee_TableViewBuilder

@synthesize style;
@synthesize tableViewArray;

- (id)init
{
    if (self = [super init]) {
        self.tableViewArray = [NSMutableArray array];
        self.style = UITableViewStylePlain;
        
    }
    
    return self;
}


- (id)initWithStyle:(UITableViewStyle)new_style
{
    if (self = [self init])
    {
        self.style = new_style;
    }
    return self;
}



- (void)dealloc{
    
    [self.tableViewArray removeAllObjects];
    self.tableViewArray = nil;
    
    
    [super dealloc];
}

#pragma mark table creator
//我的本意是想写builder模式，不过director没法加


- (int)refresh_table_creator
{
    return [self refresh_table_creator_with_frame:[[UIScreen mainScreen] applicationFrame] and_style:self.style];
}

- (int)table_creator_with_frame:(CGRect)f
{
    return [self refresh_table_creator_with_frame:f and_style:self.style];
}

/**
 * 返回是当前tableview的索引
 */
- (int)refresh_table_creator_with_frame:(CGRect)f and_style:(UITableViewCellStyle)new_style
{
    Bee_RefreshTableView *__tableView = [[Bee_RefreshTableView alloc] initWithFrame:f
                                                                          style:new_style];
    
    [self.tableViewArray addObject:__tableView];
    
    return [self.tableViewArray count] - 1;
}

- (Bee_RefreshTableView *)get_refresh_table_view_with_index:(int)index
{
    if (index >[self.tableViewArray count]-1) {
        NSAssert(NO, @"不存在");
        return nil;
    }
    
    Bee_RefreshTableView *__tableView = (Bee_RefreshTableView *)[self.tableViewArray objectAtIndex:index];;
    
    return __tableView;
}

-(int)fast_add_refresh_table_view:(UIView *)table_parent_view
{
    int i = [self refresh_table_creator];
    [table_parent_view addSubview:[self get_refresh_table_view_with_index:i]];
    return i;
}


-(Bee_RefreshTableView *)get_fast_add_refresh_table_view:(UIView *)table_parent_view
{
    int i = [self refresh_table_creator];
    [table_parent_view addSubview:[self get_refresh_table_view_with_index:i]];
    return [self get_refresh_table_view_with_index:i];
}


@end
