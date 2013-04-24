//
//  SearchController.m
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 4/23/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//


// --------------------------------------------------------------
// IMPORTS

#import "SearchController.h"


// --------------------------------------------------------------
// BEGIN IMPLEMENTATION

@implementation SearchController


// --------------------------------------------------------------
// SYNTHESIZE PROPERTIES

@synthesize tableData;


// --------------------------------------------------------------
// INIT FUNCTION

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        // Set delegates and data sources
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
		
        UIView* bview = [[UIView alloc] init];
        
		// Table view background color
		[self.tableView setBackgroundView: nil];
		[self.tableView setBackgroundColor: [UIColor blueColor]];
    }
    
    return self;
}


// --------------------------------------------------------------
// VIEW DID LOAD

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Set language strings
	allTreesString = @"ALL TREES";
	
	// Init the table data array
	tableData = [NSMutableArray new];
	
	// Get tree types
	[self getTreeTypes];
	
    // Reload data
    [self.tableView reloadData];
}


// --------------------------------------------------------------
// GET TREE TYPES

- (void)getTreeTypes
{
	// Temporary list container
	NSMutableArray *treeTypes = [NSMutableArray new];
	
	// Create database controller
	MyTreeLists *treeDatabaseController = [MyTreeLists new];
	
	// Get a list of all tree types
	treeTypes = [treeDatabaseController getTreeTypes];
	
	// Format stuff to the table data
	[tableData addObject: allTreesString];
	[tableData addObjectsFromArray: treeTypes];
}


// --------------------------------------------------------------
// NUMBER OF ROWS IN SECTION

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


// --------------------------------------------------------------
// DID SELECT ROW AT INDEX PATH

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Get a reference to the current cell
    UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
	
	// Check if we need to select all trees, or just one specific one
	if ([currentCell.textLabel.text isEqualToString: allTreesString])
	{
		// Call notification center to dispatch observer for selecting all trees
		[[NSNotificationCenter defaultCenter] postNotificationName:@"selectAllTrees" object:nil];
	}
	
	// Else, select a specific tree
	else
	{
		// Get the cell text and assign it to a tree information dictionary
		NSDictionary *treeInformation = [NSDictionary dictionaryWithObject:currentCell.textLabel.text forKey:@"treeType"];
		
		// Call notification center to dispatch observer for selecting tree with tree information dictionary
		[[NSNotificationCenter defaultCenter] postNotificationName: @"selectTreesWithCustomType" object:nil userInfo:treeInformation];
	}
	
	// Deselect cell after selecting
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


// --------------------------------------------------------------
// WILL DISPLAY CELL FOR ROW AT INDEX PATH

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor darkGrayColor];
}


// --------------------------------------------------------------
// CELL FOR ROW AT INDEX PATH

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"treeType";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}


// --------------------------------------------------------------
// DID RECEIVE MEMORY WARNING

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
