//
//  Bee_TableViewBuilder.h
//  bee
//
//  Created by sang on 5/30/13.
//
//

#import <Foundation/Foundation.h>


#import "Bee_RefreshTableView.h"

/**
 * 主要处理DATableView的重载问题
 *
 *
 * 它不需要单例，这样的原因是每个builder都要有自己的一组tableview
 *
 *
 *
 */

@interface Bee_TableViewBuilder : NSObject

 

@property (nonatomic, assign, readwrite) UITableViewStyle style;
@property (nonatomic, retain, readwrite) NSMutableArray *tableViewArray;

- (id)initWithStyle:(UITableViewStyle)style;

#pragma mark -

- (int)refresh_table_creator;
- (int)table_creator_with_frame:(CGRect)f;
- (int)refresh_table_creator_with_frame:(CGRect)f and_style:(UITableViewCellStyle)style;
- (Bee_RefreshTableView *)get_refresh_table_view_with_index:(int)index;


#pragma mark - 快速增加接口

-(int)fast_add_refresh_table_view:(UIView *)table_parent_view;
-(Bee_RefreshTableView *)get_fast_add_refresh_table_view:(UIView *)table_parent_view;

@end
