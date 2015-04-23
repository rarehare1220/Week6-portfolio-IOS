//
//  News.m
//  week6port
//
//  Created by double on 23/04/2015.
//  Copyright (c) 2015 double. All rights reserved.
//

#import "News.h"

@implementation News

- (id)initWithTitle:(NSString*) title andDesc:(NSString*) desc andImageURL:(NSURL*) imageURL andNewsURL:(NSURL*) newsURL
{
    if (self = [super init]) {
        self.title = title;
        self.desc = desc;
        self.imageURL = imageURL;
        self.newsURL = newsURL;
    }
    return self;
}


@end
