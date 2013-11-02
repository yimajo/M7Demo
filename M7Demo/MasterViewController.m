//
//  MasterViewController.m
//  M7Demo
//
//  Created by yimajo on 2013/11/02.
//  Copyright (c) 2013年 Curiosity Software Inc. All rights reserved.
//

#import "MasterViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface MasterViewController ()


@property (weak, nonatomic) IBOutlet UILabel *todayStepLabel;

@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel;


@property (weak, nonatomic) IBOutlet UITableViewCell *activityStationaryCell;

@property (weak, nonatomic) IBOutlet UILabel *activityStationaryLabel;


@property (weak, nonatomic) IBOutlet UITableViewCell *activityWlkingCell;

@property (weak, nonatomic) IBOutlet UILabel *activityWalkingLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *activityRunningCell;

@property (weak, nonatomic) IBOutlet UILabel *activityRunningLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *activityAutomotiveCell;

@property (weak, nonatomic) IBOutlet UILabel *activityAutomotiveLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *activityUnknownCell;

@property (weak, nonatomic) IBOutlet UILabel *activityUnknownLabel;

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startStepCounting];
    [self startActivity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

//歩数計のカウントスタート
- (void)startStepCounting
{
    if([CMStepCounter isStepCountingAvailable])
    {
        CMStepCounter *stepCounter = [[CMStepCounter alloc] init];
        [stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue]
                                            updateOn:1
                                         withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error)
        {
              if(!error) {
              
                  self.stepCountLabel.text = [NSString stringWithFormat:@"steps:%ld", numberOfSteps];
              
              } else {
                  self.stepCountLabel.text = error.description;

                  NSLog(@"error:%@", error);
              }
        }];
        
        NSDate *today = [[self class] today];

        [stepCounter queryStepCountStartingFrom:today to:[NSDate date] toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error)
        {
            if (!error) {
                self.todayStepLabel.text = [NSString stringWithFormat:@"%ld", numberOfSteps];
            } else {
                self.todayStepLabel.text = error.description;
            }
        }];
    }
}

//現在のActivityを取得するメソッドをスタート
- (void)startActivity
{

    CMMotionActivityManager *motionActivityManager = [[CMMotionActivityManager alloc] init];
    
    [motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
                                           withHandler:^(CMMotionActivity *activity)
    {
        if (activity.stationary) {
            self.activityStationaryCell.backgroundColor = [[self class] activeColor];
            self.activityStationaryLabel.text = @"YES";
        } else {
            self.activityStationaryCell.backgroundColor = [UIColor clearColor];
            self.activityStationaryLabel.text = @"NO";
        }
        
        if (activity.walking) {
            self.activityWlkingCell.backgroundColor = [[self class] activeColor];
            self.activityWalkingLabel.text = @"YES";
        } else {
            self.activityWlkingCell.backgroundColor = [UIColor clearColor];
            self.activityWalkingLabel.text = @"NO";
        }
        
        if (activity.running) {
            self.activityRunningCell.backgroundColor = [[self class] activeColor];
            self.activityRunningLabel.text = @"YES";
        } else {
            self.activityRunningCell.backgroundColor = [UIColor clearColor];
            self.activityRunningLabel.text = @"NO";
        }
        
        if (activity.automotive) {
            self.activityAutomotiveCell.backgroundColor = [[self class] activeColor];
            self.activityAutomotiveLabel.text = @"YES";
        } else {
            self.activityAutomotiveCell.backgroundColor = [UIColor clearColor];
            self.activityAutomotiveLabel.text = @"NO";
        }

        if (activity.unknown) {
            self.activityUnknownCell.backgroundColor = [[self class] activeColor];
            self.activityUnknownLabel.text = @"YES";
        } else {
            self.activityUnknownCell.backgroundColor = [UIColor clearColor];
            self.activityUnknownLabel.text = @"NO";
        }

    }];
}

+ (UIColor *)activeColor
{
    return [UIColor colorWithRed:0.169 green:0.808 blue:0.969 alpha:1.000];
}

//今日の0時のNSDateを返す
+ (NSDate *)today
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
	NSDate *nowDate = [dateFormatter dateFromString:nowDateStr];

    return nowDate;
}

@end
