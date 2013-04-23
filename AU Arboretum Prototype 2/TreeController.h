//
//  TreeController.h
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 2/27/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//


// --------------------------------------------------------------
// IMPORTS

#import <Foundation/Foundation.h>
#import "TreeList.h"


// --------------------------------------------------------------
// INTERFACE DEFINITION

@interface TreeController : NSObject
{
	// VARIABLES
	TreeController *treeController;
}

// METHODS
- (NSMutableArray *)getTreeAnnotations;
- (TreeList *)getSingleTreeInformation: (NSUInteger)givenTreeId;

@end
