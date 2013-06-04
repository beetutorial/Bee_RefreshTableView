//
//  Bee_RefreshTableView.h
//  SinaFinance
//
//  Created by sang on 5/30/13.
//
//

#import <UIKit/UIKit.h>
#import "EGOLoadMoreTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

/**
 * 主要处理DATableView的重载问题
 *
 *
 * 常规的下啦刷新是不确定条数的，所以这种场景不适用于DATableView
 *
 *
 *
 */

@interface Bee_RefreshTableView : UITableView <EGORefreshTableHeaderDelegate>

//add by alfred
@property(nonatomic,retain,readwrite) NSDate *lastUpdatedDate;



@property (nonatomic, assign, readwrite) int pageNumber;
@property (nonatomic, assign, readwrite) int pageSize;

@property (nonatomic, retain, readwrite) EGORefreshTableHeaderView *refreshHeaderView;

//EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic, retain, readwrite) EGOLoadMoreTableFooterView * loadMoreFooterView;

@property (nonatomic, retain, readwrite) NSMutableArray *result_array;

 
// 设置是否显示下拉UI
-(void)set_pull_down_enable:(Boolean)is_pull_down;


- (void)set_delegate:(id)mydelegate;

- (void)reload_data_with_one_section:(NSArray *)new_result_array;

- (void)check_date_now;

- (void)start_check_refresh;

@property (nonatomic, copy) void(^refresh_call_back_handler)(Bee_RefreshTableView *table);
@property (nonatomic, copy) void(^didSelectBlock)(NSIndexPath *indexPath);

//result_array
@property (nonatomic, copy) int (^rowCount)(NSArray *result_array,NSInteger section);

@property (nonatomic, copy) int (^sectionsCount)();


/**
 * 用于section的footer和header自定义视图
 */
@property (nonatomic, copy) UIView *(^viewForHeaderInSection)(Bee_RefreshTableView *table, NSInteger section);
@property (nonatomic, copy) UIView *(^viewForFooterInSection)(Bee_RefreshTableView *table, NSInteger section);



/**
 * 用于自定义cell界面
 *
 * 参数cell
 * 参数indexPath
 * 参数data是[result_array objectAtIndex:indexPath.row]
 */
@property (nonatomic, copy) void(^cellForRowBlock)(UITableViewCell *cell, NSIndexPath *indexPath,id data);


@property (nonatomic, copy) NSString *(^cellIdentifier)(NSIndexPath *indexPath,id data);

@property (nonatomic, copy) UITableViewCellSelectionStyle(^cellselectionStyle)(NSIndexPath *indexPath,id data);


@property (nonatomic) SEL didSelectAction;
@property (nonatomic, copy) float(^heightForRowAtIndexPath)(NSIndexPath *indexPath);

@property (nonatomic, copy) float(^heightForHeaderInSection)(NSInteger section);

@property (nonatomic, copy) float(^heightForFooterInSection)(NSInteger section);




@property (nonatomic, copy) void(^nextPage)();

//@property (nonatomic, copy) int(^numberOfRowsInSection)(NSInteger section);


- (void)add_need_reload_tip_view;

@end
