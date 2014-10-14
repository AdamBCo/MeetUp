//
//  EventDetailViewController.m
//  MeetUp
//
//  Created by Adam Cooper on 10/13/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventWebViewController.h"
#import "MeetUpCommentCell.h"
#import "ProfileViewController.h"

@interface EventDetailViewController () <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *rsvpCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventHost;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property NSMutableArray *commentsArray;
@property NSMutableArray *meetUPMembers;



@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.selectedEvent.name;    
    self.rsvpCountLabel.text = self.selectedEvent.rsvpCount.description;
    self.eventHost.text = self.selectedEvent.hostGroupInfo;
    self.commentsArray = [NSMutableArray array];
    self.meetUPMembers = [NSMutableArray array];
    [self createWebViewWithHTML];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&group_id=%@&page=20&key=4d6c601a67667a11415d703b4f241540", self.selectedEvent.groupID]]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         self.commentsArray = results[@"results"];
         [self.commentsTableView reloadData];
         
         for (NSDictionary *memberDictionary in self.commentsArray)
         {
             [self.meetUPMembers addObject:[memberDictionary[@"member_id"] stringValue]];
         }
     }];
    
    
    

}

- (IBAction)moreInfoWebButton:(id)sender {
}

- (void) createWebViewWithHTML{
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: self.selectedEvent.eventDescription];
    NSLog(@"%@", html);

    //pass the string to the webview
    [self.descriptionWebView loadHTMLString:[html description] baseURL:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    if ([segue.identifier isEqualToString:@"WebViewSegue"])
    {
        EventWebViewController *eventWebViewController = segue.destinationViewController;
        eventWebViewController.eventURL = self.selectedEvent.linkToEventPage;
    } else if ([segue.identifier isEqualToString:@"ProfileSegue"])
    {
        ProfileViewController *profileViewController = segue.destinationViewController;
        profileViewController.memberID = [self.meetUPMembers objectAtIndex:[self.commentsTableView indexPathForCell:cell].row];

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeetUpCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    NSDictionary *comment = [self.commentsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = comment[@"comment"];
    cell.detailTextLabel.text = comment[@"member_name"];
    
    
    NSNumber *timeInString = comment[@"time"];
    NSInteger timeInSeconds = timeInString.integerValue;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInSeconds];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm:ss a"];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@", dateString];
    
    
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsArray.count;
    
}






@end
