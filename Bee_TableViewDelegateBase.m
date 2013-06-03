//
//  Bee_TableViewDelegateBase.m
//  bee
//
//  Created by sang on 5/30/13.
//
//

#import "Bee_TableViewDelegateBase.h"
#import "Bee_RefreshTableView.h"

@interface Bee_TableViewDelegateBase()

@property(nonatomic,retain,readwrite) Bee_RefreshTableView *_tableView;

@end


@implementation Bee_TableViewDelegateBase

@synthesize _tableView;


#pragma mark - datasource
- (NSInteger)tableView:(Bee_RefreshTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    return [tableView.result_array count];
//    if ([tableView.result_array count] == 0) {
//        return 0;
//    }
    
    CC(@"%d rows",tableView.rowCount ? tableView.rowCount(tableView.result_array,section):[tableView.result_array count]);
    return tableView.rowCount ? tableView.rowCount(tableView.result_array,section):[tableView.result_array count];
}


- (NSInteger)numberOfSectionsInTableView:(Bee_RefreshTableView *)tableView{
    
   CC(@"%d sects",tableView.sectionsCount ? tableView.sectionsCount():1);
   return tableView.sectionsCount ? tableView.sectionsCount():1;
}

// custom view for header. will be adjusted to default or specified header height
- (UIView *)tableView:(Bee_RefreshTableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return tableView.viewForHeaderInSection ? tableView.viewForHeaderInSection(tableView,section):nil;
}

// custom view for footer. will be adjusted to default or specified footer height
- (UIView *)tableView:(Bee_RefreshTableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return tableView.viewForFooterInSection ? tableView.viewForFooterInSection(tableView,section):nil;
}

- (CGFloat)tableView:(Bee_RefreshTableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableView.heightForHeaderInSection? tableView.heightForHeaderInSection(section) : 0.0f;
}
- (CGFloat)tableView:(Bee_RefreshTableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return tableView.heightForFooterInSection? tableView.heightForFooterInSection(section) : 0.0f;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(Bee_RefreshTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_default_id"];
    if (tableView.cellIdentifier) {
        cellIdentifier = tableView.cellIdentifier(indexPath,nil);
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
     

    
    //单个section的读取result_array
    if ([self numberOfSectionsInTableView:tableView] == 1 ) {
        id data = [tableView.result_array objectAtIndex:indexPath.row];
        
        
        self._tableView = tableView;
        
       
        if (tableView.cellIdentifier) {
            cellIdentifier = tableView.cellIdentifier(indexPath,data);
        }
        
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (tableView.cellselectionStyle)
        {
            cell.selectionStyle = tableView.cellselectionStyle(indexPath,data);
        }
        
        
        if (tableView.cellForRowBlock)
        {
            tableView.cellForRowBlock(cell, indexPath,data);
        }
        
    }else{
        //多个section的不处理，在cellforrow里自己处理
        self._tableView = tableView;
        
       
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (tableView.cellselectionStyle)
        {
            cell.selectionStyle = tableView.cellselectionStyle(indexPath,nil);
        }
        
        
        if (tableView.cellForRowBlock)
        {
            tableView.cellForRowBlock(cell, indexPath,nil);
        }

    }
    
//    if ([tableView.result_array count] == 0) {
//        return nil;
//    }
    
   
    return cell;
    
}

#pragma mark table delegate
- (CGFloat)tableView:(Bee_RefreshTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.heightForRowAtIndexPath) {
        return tableView.heightForRowAtIndexPath(indexPath) > 0 ? tableView.heightForRowAtIndexPath(indexPath) : 44.0f;
    }
    return 44.0f;
}



- (void)tableView:(Bee_RefreshTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.didSelectBlock)
    {
        tableView.didSelectBlock(indexPath);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (tableView.didSelectAction)
    {
        [self performSelector:tableView.didSelectAction];
    }
#pragma clang diagnostic pop
}




#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(Bee_RefreshTableView *)scrollView
{
    CC(@"%@ table 下拉刷新开始了",self._tableView);
}

- (void)scrollViewDidScroll:(Bee_RefreshTableView *)scrollView {
	[scrollView.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    
    int contentHeight = scrollView.contentSize.height;
    contentHeight = contentHeight>=scrollView.bounds.size.height?contentHeight:scrollView.bounds.size.height;
    int extraHeight = contentHeight - scrollView.bounds.size.height;
    
    BOOL __is_load_next_page = NO;
    if (scrollView.contentOffset.y>extraHeight + 45) {
        
        if (scrollView.nextPage) {
            __is_load_next_page = YES; 
        } 
 
    }
    
    if (__is_load_next_page) {
        int page = scrollView.pageNumber;
        
         CC(@"bpage = %d",page);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reload_next_page:) object:scrollView];
        [self performSelector:@selector(reload_next_page:) withObject:scrollView afterDelay:0.5];
         
    }
    

}

-(void)reload_next_page:(Bee_RefreshTableView *)scrollView{
    scrollView.nextPage();
}

- (void)scrollViewDidEndDragging:(Bee_RefreshTableView *)scrollView willDecelerate:(BOOL)decelerate {
	//兼容老版本的ego
    //    if ([refreshHeaderView respondsToSelector:@selector(egoRefreshScrollViewDidEndDragging)]) {
    //        [refreshHeaderView egoRefreshScrollViewDidEndDragging];
    //    }
    //
    if ([scrollView.refreshHeaderView respondsToSelector:@selector(egoRefreshScrollViewDidEndDragging:)]) {
        [scrollView.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


@end
