//
//  ViewNewsViewController.h
//  week6port
//
//  Created by double on 23/04/2015.
//  Copyright (c) 2015 double. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface ViewNewsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) News* currentNews;


@end
