//
//  MeetUpCommentCell.h
//  MeetUp
//
//  Created by Adam Cooper on 10/13/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetUpCommentCell : UITableViewCell
@property NSString *commentorsName;
@property NSString *commentTime;
@property NSString *commentMaterial;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
