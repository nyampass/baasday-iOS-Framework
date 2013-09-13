//
//  DetailViewController.h
//  SampleApp
//
//  Created by Tokusei Noborio on 13/04/17.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (assign, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
