//
//  DictionaryViewController.m
//  PictureDictionary
//
//  Created by thinkit  on 9/15/14.
//  Copyright (c) 2014 thinkit . All rights reserved.
//

#import "DictionaryViewController.h"

@interface DictionaryViewController ()

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *products;
//@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
@property (nonatomic, strong) NSMutableDictionary *sortedProductsDictionary;
@property (nonatomic, strong) NSMutableArray *sectionTitles;

@end

@implementation DictionaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.products = [NSMutableArray arrayWithArray:@[@"MacBook Pro", @"MacBook Air", @"iPhone 5S", @"iPhone 6", @"Dell", @"Lenovo", @"HP", @"Haier", @"Asus"]];
    
    self.searchResults = [NSMutableArray arrayWithArray:@[@"searchResult1", @"searchResult2", @"searchResult3"]];
    
    [self prepareDatasource];
    
    //    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tater.png"]];
    
    // set colour for table view index
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    // set background colour for table view index when selected
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    
    //    self.collation = [UILocalizedIndexedCollation currentCollation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView data source and delegate methods

/*
 * Determinded by data source for table view
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    else
    {
        return [self.sectionTitles count];
    }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    // Display a magnifying glass icon as the first title
    NSMutableArray *sectionIndexTitles = [NSMutableArray arrayWithArray:self.sectionTitles];
    [sectionIndexTitles insertObject:UITableViewIndexSearch atIndex:0];
    return sectionIndexTitles;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // Returns the section that the table view should scroll to for the given index title
    if (index == 0)
    {
        [self.tableView setContentOffset:CGPointZero animated:YES];
        return NSNotFound;
    }
    
    return (index - 1);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    return [self.sectionTitles objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.searchResults count];
    }
	else
	{
        NSString *firstLetter = [self.sectionTitles objectAtIndex:section];
        return [[self.sortedProductsDictionary objectForKey:firstLetter] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"CellIdentifier";
    
    // Dequeue a cell from self's table view.
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellID];
    
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the search results array, otherwise use the product array.
	 */
    
    NSString *result;
    
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        result = [self.searchResults objectAtIndex:indexPath.row];
    }
	else
	{
        NSString *firstLetter = [self.sectionTitles objectAtIndex:indexPath.section];
        NSArray *productsStartsWithLetter = [self.sortedProductsDictionary objectForKey:firstLetter];
        result = [productsStartsWithLetter objectAtIndex:indexPath.row];
    }
    
	cell.textLabel.text = result;
	return cell;
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - Datasource related Methods

- (void)prepareDatasource
{
    self.products = [NSMutableArray arrayWithArray: [self.products sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 lowercaseString] compare:[obj2 lowercaseString]];
    }]];
    
    self.sortedProductsDictionary = [[NSMutableDictionary alloc] init];
    
    /* Products start from the same letter with be put in one array,
    *  sortedProductsDictionary:      Key(NSString)        Value(NSArray)
     *                                    firstLetter - Products start from the same letter
     */
    [self.products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *product = obj;
        NSString *firstLetter = [[NSString stringWithFormat:@"%c", [product characterAtIndex:0]] uppercaseString];
        NSMutableArray *productsStartsWithChar = [self.sortedProductsDictionary objectForKey:firstLetter];
        if (!productsStartsWithChar)
        {
            productsStartsWithChar = [[NSMutableArray alloc] init];
            [self.sortedProductsDictionary setObject:productsStartsWithChar forKey:firstLetter];
        }
        [productsStartsWithChar addObject:product];
    }];
    
//    [self.sortedProductsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSArray *sortedProduct = [(NSArray *)obj sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//            return [[obj1 lowercaseString] compare:[obj2 lowercaseString]];
//        }];
//        [self.sortedProductsDictionary setObject:sortedProduct forKey:key];
//    }];
    
    // Order section titles by ascend
    self.sectionTitles = [NSMutableArray arrayWithArray:[[self.sortedProductsDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
         return [obj1 compare:obj2];
    }]];
  
}

@end
