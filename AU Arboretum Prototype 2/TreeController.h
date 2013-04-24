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
#import "TreeAnnotation.h"
#import "MyTreeLists.h"


// --------------------------------------------------------------
// INTERFACE DEFINITION

@interface TreeController : NSObject
{
	// VARIABLES
}

// METHODS
- (NSMutableArray *)getTreeAnnotations;
- (NSMutableArray *)getTreeAnnotationsForType:(NSString *)treeCommonName andSet:(NSNumber *)setId;
- (NSMutableArray *)getTreeAnnotationsForSet:(NSNumber *)setId;
- (TreeList *)getSingleTreeInformation: (NSUInteger)givenTreeId;

@end
