//
//  SearchController.m
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 4/23/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//

#import "SearchController.h"

@interface SearchController ()

@end

@implementation SearchController

@synthesize tableData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        // Set delegates and data sources
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"selected: %@", currentCell.textLabel.text);
    
    NSDictionary *treeInformation = [NSDictionary dictionaryWithObject:currentCell.textLabel.text forKey:@"treeType"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"selectTreesWithCustomType" object:nil userInfo:treeInformation];
}

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



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set table data
    tableData = [NSMutableArray new];
    
    // Dummy data
    [tableData addObject:@"one"];
    [tableData addObject:@"two"];
    
    // Reload data
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
