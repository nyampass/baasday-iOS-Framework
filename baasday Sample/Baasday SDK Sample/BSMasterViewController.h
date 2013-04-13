//
//  BSMasterViewController.h
//  Baasday SDK Sample
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSDetailViewController;

@interface BSMasterViewController : UITableViewController

@property (strong, nonatomic) BSDetailViewController *detailViewController;

@end
