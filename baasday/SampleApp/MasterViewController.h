//
//  MasterViewController.h
//  SampleApp
//
//  Created by Tokusei Noborio on 13/04/17.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

typedef enum {
    MenuTypeAuthorizeUser,
    MenuTypeFetchMe,
    MenuTypeAddPoint,
    MenuTypeAddScore,
    MenuTypeViewRanking,
    MenuTypeCount
} MenuType;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
