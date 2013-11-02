//
//  DetailViewController.h
//  M7Demo
//
//  Created by yimajo on 2013/11/02.
//  Copyright (c) 2013年 Curiosity Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
