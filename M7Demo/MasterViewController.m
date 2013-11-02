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
        __weak MasterViewController *weakRefrencedViewController = self;

        CMStepCounter *stepCounter = [[CMStepCounter alloc] init];
        
        [stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue]
                                            updateOn:1
                                         withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error)
        {
              if(!error) {
              
                  //start後からのカウントをするはずだがqueryでの和と一致せず
                  //精度も良くない気がするので余り役に立たないと思った方がいい
                  weakRefrencedViewController.stepCountLabel.text = [NSString stringWithFormat:@"steps:%ld", numberOfSteps];

                  //都度今日のstep数を取得したほうが正確な気がする
                  [self todayStepWithStepCounter:stepCounter];
              } else {
                  weakRefrencedViewController.stepCountLabel.text = error.description;

                  NSLog(@"error:%@", error);
              }
        }];
        
        [self todayStepWithStepCounter:stepCounter];
    }
}

- (void)todayStepWithStepCounter:(CMStepCounter *)stepCounter
{
    NSDate *today = [[self class] today];
    
    __weak MasterViewController *weakRefrencedViewController = self;

    [stepCounter queryStepCountStartingFrom:today to:[NSDate date] toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error)
     {
         if (!error) {
             weakRefrencedViewController.todayStepLabel.text = [NSString stringWithFormat:@"%ld", numberOfSteps];
         } else {
             weakRefrencedViewController.todayStepLabel.text = error.description;
         }
     }];

}

//現在のActivityを取得するメソッドをスタート
- (void)startActivity
{
    __weak MasterViewController *weakRefrencedViewController = self;
    
    CMMotionActivityManager *motionActivityManager = [[CMMotionActivityManager alloc] init];
    
    [motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
                                           withHandler:^(CMMotionActivity *activity)
    {
        if (activity.stationary) {
            weakRefrencedViewController.activityStationaryCell.backgroundColor = [[self class] activeColor];
            weakRefrencedViewController.activityStationaryLabel.text = @"YES";
        } else {
            weakRefrencedViewController.activityStationaryCell.backgroundColor = [UIColor clearColor];
            weakRefrencedViewController.activityStationaryLabel.text = @"NO";
        }
        
        if (activity.walking) {
            weakRefrencedViewController.activityWlkingCell.backgroundColor = [[self class] activeColor];
            weakRefrencedViewController.activityWalkingLabel.text = @"YES";
        } else {
            weakRefrencedViewController.activityWlkingCell.backgroundColor = [UIColor clearColor];
            weakRefrencedViewController.activityWalkingLabel.text = @"NO";
        }
        
        if (activity.running) {
            weakRefrencedViewController.activityRunningCell.backgroundColor = [[self class] activeColor];
            weakRefrencedViewController.activityRunningLabel.text = @"YES";
        } else {
            weakRefrencedViewController.activityRunningCell.backgroundColor = [UIColor clearColor];
            weakRefrencedViewController.activityRunningLabel.text = @"NO";
        }
        
        if (activity.automotive) {
            weakRefrencedViewController.activityAutomotiveCell.backgroundColor = [[self class] activeColor];
            weakRefrencedViewController.activityAutomotiveLabel.text = @"YES";
        } else {
            weakRefrencedViewController.activityAutomotiveCell.backgroundColor = [UIColor clearColor];
            weakRefrencedViewController.activityAutomotiveLabel.text = @"NO";
        }

        if (activity.unknown) {
            weakRefrencedViewController.activityUnknownCell.backgroundColor = [[self class] activeColor];
            weakRefrencedViewController.activityUnknownLabel.text = @"YES";
        } else {
            weakRefrencedViewController.activityUnknownCell.backgroundColor = [UIColor clearColor];
            weakRefrencedViewController.activityUnknownLabel.text = @"NO";
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
