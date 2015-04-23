//
//  NewsListController.h
//  week6port
//
//  Created by double on 23/04/2015.
//  Copyright (c) 2015 double. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "NewsCell.h"
#import "ViewNewsViewController.h"

@interface NewsListController : UITableViewController
@property (strong, nonatomic) NSMutableArray* newsList;

-(void)getNews;


@end
