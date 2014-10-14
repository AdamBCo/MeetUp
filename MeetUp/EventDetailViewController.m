//
//  EventDetailViewController.m
//  MeetUp
//
//  Created by Adam Cooper on 10/13/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *rsvpCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventHost;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.selectedEvent.name;    
    self.rsvpCountLabel.text = self.selectedEvent.rsvpCount.description;
    self.eventHost.text = self.selectedEvent.hostGroupInfo;
    [self createWebViewWithHTML];
//    NSLog(@"%@", self.selectedEvent.eventDescription);

}

- (IBAction)moreInfoWebButton:(id)sender {
}

- (void) createWebViewWithHTML{
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: self.selectedEvent.eventDescription];
    NSLog(@"%@", html);
    
    //continue building the string
    [html appendString:@"</body></html>"];

    //pass the string to the webview
    [self.descriptionWebView loadHTMLString:[html description] baseURL:nil];
    
    
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
