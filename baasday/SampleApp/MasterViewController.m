//
//  MasterViewController.m
//  SampleApp
//
//  Created by Tokusei Noborio on 13/04/17.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "baasday.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}

-(NSString *)menuTitle:(MenuType)type
{
    switch (type) {
        case MenuTypeAuthorizeUser:
            return NSLocalizedString(@"Create user", nil);
            break;

        case MenuTypeFetchMe:
            return NSLocalizedString(@"Fetch my user data", nil);
            
        case MenuTypeAddPoint:
            return NSLocalizedString(@"Add point", nil);
            
        case MenuTypeAddScore:
            return NSLocalizedString(@"Add score", nil);

        case MenuTypeViewRanking:
            return NSLocalizedString(@"View ranking", nil);
            
        default:
            return nil;
    }
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    _objects = [NSMutableArray new];
    for (NSInteger i = 0; i < MenuTypeCount; i++) {
        [_objects addObject:[self menuTitle:i]];
    }

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)willPresentAlertView:(UIAlertView *)alertView {
    
    [alertView setFrame:CGRectMake(0, 0, 320, 460)];}

static BOOL saveAuthenticationKey = NO;

- (void)authorizeUser:(BOOL)showMessage
{
	NSError *error;
	BDAuthenticatedUser *user = [BDAuthenticatedUser createWithValues:@{@"registeredAt": [NSDate date]} error:&error];
	if (error) {
		NSLog(@"%@", error);
		return;
	}
	[BDBaasday setUserAuthenticationKey:user.authenticationKey];
    saveAuthenticationKey = YES;
    if (showMessage) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:[NSString stringWithFormat:@"Created user\n%@", user.authenticationKey]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
	}
}

- (void)fetchMe
{
    if (!saveAuthenticationKey)
        [self authorizeUser:NO];
	/*
	BDAuthenticatedUser *user = [BDAuthenticatedUser fetchWithError:nil];
    [[[UIAlertView alloc] initWithTitle:nil
                                message:[NSString stringWithFormat:@"%@", user]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
	 */
	[BDAuthenticatedUser fetchInBackground:^(BDAuthenticatedUser *user, NSError *error) {
		[[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ : %@ in background", user, user.createdAt] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
	}];
	[[[UIAlertView alloc] initWithTitle:nil message:@"fetch user in background" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

- (void)addPoint
{
    if (!saveAuthenticationKey)
        [self authorizeUser:NO];
	/*
	BDAuthenticatedUser *user = [BDAuthenticatedUser fetchWithError:nil];
    [user update:@{@"point": @{@"$inc": [NSNumber numberWithInt:10]}}];
	[[[UIAlertView alloc] initWithTitle:nil
                                message:[NSString stringWithFormat:@"Point: %@", [user objectForKey:@"point"]]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
	 */
	[BDAuthenticatedUser fetchInBackground:^(BDAuthenticatedUser *user, NSError *error) {
		[user updateInBackground:@{@"point": @{@"$inc": [NSNumber numberWithInt:10]}} block:^(id user, NSError *error) {
			[[[UIAlertView alloc] initWithTitle:nil
										message:[NSString stringWithFormat:@"Point: %@ in background", [user objectForKey:@"point"]]
									   delegate:nil
							  cancelButtonTitle:nil
							  otherButtonTitles:@"OK", nil] show];
		}];
	}];
	[[[UIAlertView alloc] initWithTitle:nil message:@"add point in background" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

- (void)addScore
{
	/*
	BDLeaderboardEntry *entry = [BDLeaderboardEntry createWithLeaderboardName:@"normal-mode" score:100 error:nil];
    [[[UIAlertView alloc] initWithTitle:nil
                                message:[NSString stringWithFormat:@"Rank: %d", entry.rank]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
	 */
	[BDLeaderboardEntry createInBackgroundWithLeaderboardName:@"normal-mode" score:100 block:^(BDLeaderboardEntry *entry, NSError *error) {
		[[[UIAlertView alloc] initWithTitle:nil
									message:[NSString stringWithFormat:@"Rank: %d in background", entry.rank]
								   delegate:nil
						  cancelButtonTitle:nil
						  otherButtonTitles:@"OK", nil] show];
	}];
	[[[UIAlertView alloc] initWithTitle:nil message:@"add score in background" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

- (void)viewRanking
{
	BDQuery *query = [[BDQuery alloc] init];
	query.skip = 0;
	query.limit = 100;
	/*
	BDListResult *entries = [BDLeaderboardEntry fetchAllWithLeaderboardName:@"normal-mode" query:query error:nil];
    for (BDLeaderboardEntry *entry in entries.contents) {
        NSLog(@"%d %d %d", entry.rank, entry.order, entry.score);
    }
	 */
	[BDLeaderboardEntry fetchAllInBackgroundWithLeaderboardName:@"normal-mode" query:query block:^(BDListResult *result, NSError *error) {
		NSLog(@"-- leaderboard in background --");
		for (BDLeaderboardEntry *entry in result.contents) {
			NSLog(@"%d %d %d", entry.rank, entry.order, entry.score);
		}
	}];
	NSLog(@"fetch leaderboard entries in background");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuType type = indexPath.row;
    switch (type) {
        case MenuTypeAuthorizeUser:
            [self authorizeUser:YES];
            break;

        case MenuTypeFetchMe:
            [self fetchMe];
            break;
            
        case MenuTypeAddPoint:
            [self addPoint];
            break;
            
        case MenuTypeAddScore:
            [self addScore];
            break;
            
        case MenuTypeViewRanking:
            [self viewRanking];
            break;
            
        default:
            break;
    }
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
