//
//  News.h
//  week6port
//
//  Created by double on 23/04/2015.
//  Copyright (c) 2015 double. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* desc;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSURL* newsURL;

- (id)initWithTitle:(NSString*) title andDesc:(NSString*) desc andImageURL:(NSURL*) imageURL andNewsURL:(NSURL*) newsURL;


@end
