//
//  SecondCategoryViewController.m
//  PictureDictionary
//
//  Created by thinkit  on 9/24/14.
//  Copyright (c) 2014 thinkit . All rights reserved.
//

#import "SecondCategoryViewController.h"

@interface SecondCategoryViewController ()

@property (nonatomic, strong) NSMutableDictionary *familyNameDictionary;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation SecondCategoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.sectionIndexColor = [UIColor grayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.searchDisplayController.searchBar.backgroundImage = [UIImage new];
    
    [self prepareDatasource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"SecondCategoryViewController dealloc");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    return [self.sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    return [self.sectionTitles objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    NSMutableArray *sectionIndexTitles = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    [sectionIndexTitles addObjectsFromArray:self.sectionTitles];
    return sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 0;
    }
    // When the table view requests the section that corresponds to the search icon
    // in the index we return not found and fore the table view to scroll to the top
    if (index == 0)
    {
        [self.tableView setContentOffset:CGPointZero animated:YES];
        return NSNotFound;
    }
    return (index - 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    return [[self.familyNameDictionary objectForKey:[self.sectionTitles objectAtIndex:section]]
            count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell...
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        NSArray *familyNameArray = [self.familyNameDictionary objectForKey:[self.sectionTitles objectAtIndex:indexPath.section]];
        cell.textLabel.text = [familyNameArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Return YES to cause the search result table view to be reloaded.
   
    return YES;
}

#pragma mark - Helper Methods

- (void)prepareDatasource
{
    self.familyNameDictionary = [[NSMutableDictionary alloc] init];
    self.sectionTitles = [[NSMutableArray alloc] init];
    
    NSArray *originalDatasource = @[@"Li", @"Wang", @"Zhao", @"Qian", @"Sun", @"Xi", @"Yan", @"Bao", @"Ding", @"Zhang", @"Meng", @"Su"];
    NSArray *sortedDatasource  = [originalDatasource sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2];
    }];
    
    [sortedDatasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *firstLetter = [[NSString stringWithFormat:@"%c", [obj characterAtIndex:0]] uppercaseString];
        
        NSMutableArray *nameList = [self.familyNameDictionary objectForKey:firstLetter];
        if (!nameList)
        {
            nameList = [[NSMutableArray alloc] init];
            [self.familyNameDictionary setObject:nameList forKey:firstLetter];
            [self.sectionTitles addObject:firstLetter];
        }
        [nameList addObject:obj];
    }];
    
    self.searchResults = [NSMutableArray arrayWithArray:@[@"Ha", @"Hei"]];
}

@end
