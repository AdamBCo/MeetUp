//
//  ProfileViewController.m
//  MeetUp
//
//  Created by Adam Cooper on 10/13/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet UITextView *interestsTextView;

@property NSMutableDictionary *member;

@end

@implementation ProfileViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.member = [[NSMutableDictionary alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=4d6c601a67667a11415d703b4f241540", self.memberID]]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         self.navigationItem.title = results[@"name"];
         NSURL *imageUrl = [NSURL URLWithString:results[@"photo"][@"highres_link"]];
         self.profilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
         NSString *userState = results[@"state"];
         NSString *userCity = results[@"city"];
         self.locationLabel.text = [[userCity stringByAppendingString:@", "] stringByAppendingString:userState];
         self.biographyTextView.text = results[@"bio"];
         
         NSArray *interestArray = results[@"topics"];
         [interestArray componentsJoinedByString: @", "];
         NSMutableArray *interests = [NSMutableArray array];
         for (NSDictionary *interestDict in interestArray)
         {
             [interests  addObject:interestDict[@"name"]];
         }
         
         self.interestsTextView.text = [interests componentsJoinedByString: @", "];
         
     }];
    
}



@end
