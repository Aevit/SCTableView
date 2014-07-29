SCTableView
===========


---
###Preview

---
###Description
This is a **tableview** with **refreshView(header)** and **loadMoreView(footer)**. 

It imitates the UI of the iPhone app ——《网易新闻》.  

It's easy to use.

---
###How to use
1. copy the folder `SCTableViewClasses` to your project.
2. add a controller inherits from `SCTableViewController` and set delegate, dataSource to the controller.
3. override the method `- (void)sendRequest:(id)sender` in your controller to get data and reload tableview.  
(There is a demo controller ***SCDemoTableViewController*** in my project.)


####***or***  
1. copy the folder `SCTableViewClasses` to your project.
2. add a tableview inherits from `SCTableView` to a controller and set delegate, dataSource, scDelegate to the controller.
3. use the scDelegate methods  
`- (void)didBeginToRefresh:(SCTableView *)tableView`  
and  
`- (void)didBeginToLoadMoreData:(SCTableView *)tableView`  
to get data and reload tableview.   
(There is a demo controller ***DemoViewController*** in my project.)

###Properties
* SCTableView: 

```
/**
 *  YES: refreshView is the subview of tableView (refreshView will move with tableview)
 *  NO: refreshView is the subview of tableView.superView (refreshView will NOT move with tableview)
 */
@property (nonatomic, assign) BOOL isRefreshViewOnTableView;

/**
 *  set hidden to YES：cancel the refersh data module
 *  set hidden to NO： add the refersh module
 */
@property (nonatomic, strong) SCRereshHeaderView *refreshView;

/**
 *  YES: start the refresh animation, and call the refresh method to get data
 *  NO:  stop the refresh animation
 */
@property (nonatomic, assign) BOOL isTableRefreshing;

/**
 *  set hidden to YES：cancel the load more data module
 *  set hidden to NO： add the load more data module
 */
@property (nonatomic, strong) SCLoadMoreFooterView *loadMoreView;

/**
 *  YES: start the load more animation, and call the load more method to get data接口
 *  NO:  stop the load more animation
 */
@property (nonatomic, assign) BOOL isTableLoadingMore;
```
  

* SCLoadMoreFooterView  

```
/**
 *  the load more data button. will call the load more data method after click this button
 *  set hidden to YES: will NOT show the load more data button
 *  set hidden to NO:  will show the load more data button
 */
@property (nonatomic, strong) UIButton *loadMoreBtn;
```

###License

This code is distributed under the terms and conditions of the MIT license.  
