//
//  TreeController.m
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 2/27/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//


// --------------------------------------------------------------
// IMPORTS

#import "TreeController.h"


// --------------------------------------------------------------
// BEGIN IMPLEMENTATION

@implementation TreeController


// --------------------------------------------------------------
// GET TREE ANNOTATIONS

- (NSMutableArray *)getTreeAnnotations
{
	// Definitions
	NSMutableArray *treeWalkList = [NSMutableArray new];
	NSMutableArray *treeWalkAnnotations = [NSMutableArray new];
	
	// Create object of database model for getting trees
	MyTreeLists *treeDatabaseController = [MyTreeLists new];
	
	// Get a list of all trees and their coordinates
	treeWalkList = [treeDatabaseController getMyCoordinates];
	
	// For each tree in the tree walk list create a new tree
	// annotation and add it to the tree walk annotations array
	for (TreeList *currentTree in treeWalkList)
	{
		// Create a new annotation
		TreeAnnotation *currentAnnotation = [TreeAnnotation new];
		
		// Set id of the tree
		[currentAnnotation setTreeId: currentTree.treeId];
		
		// Set coordinates of tree
		[currentAnnotation setCoordinateWithLatitude: currentTree.lat andLongitude: currentTree.lng];
        
        // Set tree type            
        currentAnnotation.title = currentTree.tree;
        currentAnnotation.subtitle = currentTree.scientificname;
		
		// Add to tree annotation list
		[treeWalkAnnotations addObject: currentAnnotation];
	}
	
	// Return the tree walk list
	return treeWalkAnnotations;
}


// --------------------------------------------------------------
// GET TREE ANNOTATIONS FOR A SPECIFIC COMMON NAME

- (NSMutableArray *)getTreeAnnotationsForType:(NSString *)treeCommonName andSet:(NSNumber *)setId
{
    // Define
    NSMutableArray *treeList = [NSMutableArray new];
    NSMutableArray *treeAnnotations = [NSMutableArray new];
    
    // Create a database controller
    MyTreeLists *treeDatabaseController = [MyTreeLists new];
    
    // Get a list of all trees and their coordinates for a
    // given scientific name
    treeList = [treeDatabaseController getTreesWithCommonName:treeCommonName andSet:setId];
    
    // For each tree in the tree walk list create a new tree
	// annotation and add it to the tree annotations array
    for (TreeList *currentTree in treeList)
    {
        // Create a new annotation
		TreeAnnotation *currentAnnotation = [TreeAnnotation new];
		
		// Set id of the tree
		[currentAnnotation setTreeId: currentTree.treeId];
		
		// Set coordinates of tree
		[currentAnnotation setCoordinateWithLatitude: currentTree.lat andLongitude: currentTree.lng];
        
        // Set tree type            
        currentAnnotation.title = currentTree.tree;
        currentAnnotation.subtitle = currentTree.scientificname;
		
		// Add to tree annotation list
		[treeAnnotations addObject: currentAnnotation];
    }
    
    // Return tree annotations list
    return treeAnnotations;
}


// --------------------------------------------------------------
// GET TREE ANNOTATIONS FOR A GIVEN SET ID

- (NSMutableArray *)getTreeAnnotationsForSet:(NSNumber *)setId
{
    // Define
    NSMutableArray *treeList = [NSMutableArray new];
    NSMutableArray *treeAnnotations = [NSMutableArray new];
    
    // Create a database controller
    MyTreeLists *treeDatabaseController = [MyTreeLists new];
    
    // Get a list of all trees and their coordinates for a
    // given set id
    treeList = [treeDatabaseController getTreesWithSet:setId];
    
    // For each tree in the tree walk list create a new tree
	// annotation and add it to the tree annotations array
    for (TreeList *currentTree in treeList)
    {
        // Create a new annotation
		TreeAnnotation *currentAnnotation = [TreeAnnotation new];
		
		// Set id of the tree
		[currentAnnotation setTreeId: currentTree.treeId];
		
		// Set coordinates of tree
		[currentAnnotation setCoordinateWithLatitude: currentTree.lat andLongitude: currentTree.lng];
        
        // Set tree type
        currentAnnotation.title = currentTree.tree;
        currentAnnotation.subtitle = currentTree.scientificname;
		
		// Add to tree annotation list
		[treeAnnotations addObject: currentAnnotation];
    }
    
    // Return tree annotations list
    return treeAnnotations;
}


// --------------------------------------------------------------
// GET SINGLE TREE INFORMATION

- (TreeList *)getSingleTreeInformation:(NSUInteger)givenTreeId
{
	// Create object of database model for getting tree info
	MyTreeLists *treeDatabaseController = [MyTreeLists new];
	
	// Get a single tree object and return it to caller
	return [treeDatabaseController getSingleTree: givenTreeId];
}

@end
