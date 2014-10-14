//
//  ViewController.m
//  MeetUp
//
//  Created by Adam Cooper on 10/13/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "ViewController.h"
#import "MeetUp.h"
#import "EventDetailViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *eventsArray;
@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventsArray = [NSMutableArray array];
    
    NSURL *url = [NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=477d1928246a4e162252547b766d3c6d"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",jsonString);
        NSError *jsonError = nil;
        
        NSDictionary *parsedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSArray *results = [parsedResults valueForKey:@"results"];
        
        
        for (NSDictionary *result in results) {
            MeetUp *meetUp = [[MeetUp alloc] init];
            meetUp.name = [result objectForKey:@"name"];
            meetUp.address = [result objectForKey:@"venue"];
            meetUp.eventDescription = [result objectForKey:@"description"];
//            NSLog(@"%@",meetUp.eventDescription);
            
            
            NSNumber *rSVP = [result objectForKey:@"yes_rsvp_count"];
            if (rSVP != nil) {
                meetUp.rsvpCount = [result objectForKey:@"yes_rsvp_count"];
            } else {
                meetUp.rsvpCount = 0;
            }

            NSDictionary *address = [result objectForKey:@"venue"];
            NSString *streetAddress = [address objectForKey:@"address_1"];
            if (streetAddress != nil) {
                meetUp.streetAddress = [address objectForKey:@"address_1"];
            } else {
                meetUp.streetAddress = @"No Address";
            }
            
            NSDictionary *group = [result objectForKey:@"group"];
            NSString *groupName = [group objectForKey:@"name"];
            if (groupName != nil) {
                meetUp.hostGroupInfo = [group objectForKey:@"name"];
            } else {
                meetUp.hostGroupInfo = @"No Information";
            }
            
            [self.eventsArray addObject:meetUp];
            
            
        }
        [self.eventsTableView reloadData];
    }];
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    if ([segue.identifier isEqualToString:@"EventDetailSegue"])
    {
        EventDetailViewController *eventDetailViewController = segue.destinationViewController;
        eventDetailViewController.selectedEvent = [self.eventsArray objectAtIndex:[self.eventsTableView indexPathForCell:cell].row];
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.eventsArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MeetUp *meetUp = [self.eventsArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = meetUp.name;
    cell.detailTextLabel.text = meetUp.streetAddress;
    
    return cell;
}





@end
