//
//  SearchController.h
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 4/23/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//



// --------------------------------------------------------------
// IMPORTS

#import <UIKit/UIKit.h>
#import "MyTreeLists.h"
#import "TreeList.h"


// --------------------------------------------------------------
// INTERFACE DEFINITION

@interface SearchController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
	// VARIABLES
	NSString *allTreesString;
}

// PROPERTIES
@property (nonatomic, retain) NSMutableArray *tableData;


// METHODS
- (void)getTreeTypes;

@end
