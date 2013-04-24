//
//  MyTreeLists.h
//  MyTreeListIpad
//
//  Created by Martin Gaynor on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TreeList.h"

@interface MyTreeLists : NSObject{
    sqlite3 *db;
}

- (NSMutableArray *) getMyTrees;
- (NSMutableArray *) getMyCoordinates;
- (NSMutableArray *) getTreeTypes;
- (NSMutableArray *) getTreesWithCommonName: (NSString *)givenCommonName;
- (NSMutableArray *) getTreesWithSet: (NSNumber *)setId;
- (TreeList *)getSingleTree: (NSUInteger)givenTreeId;


@end
