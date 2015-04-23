//
//  NewsListController.m
//  week6port
//
//  Created by double on 23/04/2015.
//  Copyright (c) 2015 double. All rights reserved.
//

#import "NewsListController.h"

@interface NewsListController ()

@end

@implementation NewsListController

- (void)viewDidLoad {
    self.newsList = [[NSMutableArray alloc] init];
    [self getNews];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0){
        
        return [self.newsList count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    News* news = [self.newsList objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = news.title;
    //cell.newsTitle.lineBreakMode = NSLineBreakByWordWrapping;
    //cell.newsTitle.numberOfLines = 0;
    
//    NSString *prefix = @"<p>";
//    NSString *suffix = @"</p>";
//    NSRange needleRange = NSMakeRange(prefix.length, news.newsDescription.length - prefix.length - suffix.length);
//    
//    news.newsDescription = [news.newsDescription substringWithRange:needleRange];
    
    cell.descTextView.text = [[news.desc stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
//    cell.newsDescriptions.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.newsDescriptions.numberOfLines = 0;
    
    //    NSLog(@"%@", news.newsImageURL);
    cell.thumbernailImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(@"%@", (NSString*)news.imageURL)]]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)getNews
{
    NSURL* url;
    
    url = [NSURL URLWithString:@"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://www.abc.net.au/news/feed/51120/rss.xml&num=-1"];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if(error == nil)
         {
             [self parseNewsJSON:data];
             
         }
         else
         {
             NSLog(@"Connection Error:\n%@", error.userInfo);
         } }];
}

- (void)parseNewsJSON:(NSData *)data{
    
    NSError* error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if(result == nil) {
        NSLog(@"Error parsing JSON:\n%@", error.userInfo);
        return;
    }
    
    //find out what the type of result is
    NSLog(@"%@",[result class]);
    
    if([result isKindOfClass:[NSDictionary class]])
    {
        //test if the result is what we expected
        NSLog(@"Test pass");
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSDictionary* responseData = JSON[@"responseData"];

        
        NSDictionary* feed = responseData[@"feed"];
        NSArray* entries = feed[@"entries"];
        
        if ([entries count] != 0) {
            NSLog(@"News number: %lu", (unsigned long)[entries count]);
        }
        else
            NSLog(@"No news");
        
        for (NSDictionary* news in entries)
        {
            
            if (news[@"mediaGroups"] != nil)
            {
                NSArray* mediaGroups = news[@"mediaGroups"];
                NSDictionary* media = mediaGroups[0];
                NSArray* contents = media[@"contents"];
                NSDictionary* contentsItem = contents[0];
                NSArray* thumbnails = contentsItem[@"thumbnails"];
                NSDictionary* thumbnailsImage = thumbnails[0];
                
                News* newsItem = [[News alloc] initWithTitle:(NSString*) news[@"title"] andDesc:(NSString*) news[@"content"] andImageURL:(NSURL*) thumbnailsImage[@"url"] andNewsURL:(NSURL*) news[@"link"]];
                
                [self.newsList addObject:newsItem];
                //                NSLog(@"%lu", (unsigned long)[self.newsList count]);
                //                NSLog(@"%@\n%@\n%@\n%@",eachNews.newsTitle, eachNews.newsDescription, eachNews.newsImageURL,eachNews.newsContentURL);
                
            }
        }
    }
    [self.tableView reloadData];
}

//Segue:
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ViewNewsSegue"]) {
        News* selectedNews = (News *)[self.newsList objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        ViewNewsViewController* controller = segue.destinationViewController;
        controller.currentNews = selectedNews;
    }
}









@end
