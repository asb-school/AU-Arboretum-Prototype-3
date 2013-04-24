//
//  MyTreeLists.m
//  MyTreeListIpad
//
//  Created by Martin Gaynor on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MyTreeLists.h"
#import "TreeList.h"


@implementation MyTreeLists

// Meh, don't need this right now.
- (NSMutableArray *) getMyTrees
{
    NSMutableArray *treeArray = [[NSMutableArray alloc] init];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"MyTreesDBnew.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT t.key, t.name, t.scientific_name, t.latitude, t.longitude, t.description, m.url FROM  trees AS t, media AS m WHERE t.key = m.treeID";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            TreeList *MyTree = [[TreeList alloc]init];
            MyTree.treeId = sqlite3_column_int(sqlStatement, 0);
            MyTree.tree = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            MyTree.scientificname = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
            MyTree.lng = [NSNumber numberWithFloat:(float)sqlite3_column_double(sqlStatement, 3)];
            MyTree.lat = [NSNumber numberWithFloat:(float)sqlite3_column_double(sqlStatement, 4)];              
            MyTree.description = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
            MyTree.picturename = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 6)];            
            [treeArray addObject:MyTree];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return treeArray;
    }
    
}


- (NSMutableArray *)getTreeTypes
{
	NSMutableArray *treeTypes = [[NSMutableArray alloc] init];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"MyTreesDBnew.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT common_name_display FROM species";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
		{
			[treeTypes addObject: [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)]];
		}
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return treeTypes;
    }

}


- (NSMutableArray *)getTreesWithCommonName:(NSString *)givenCommonName
{
    NSMutableArray *treeArray = [[NSMutableArray alloc] init];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"MyTreesDBnew.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        NSString *queryString;

		queryString = [NSString stringWithFormat:@"SELECT key, latitude, longitude, name, scientific_name FROM trees WHERE name= '%@'", givenCommonName];
        
		const char *sql = [queryString UTF8String];
        
        sqlite3_stmt *sqlStatement;
		
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
		
//		sqlite3_bind_text(sqlStatement, 1, givenCommonName, -1, sql)
        
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
		{
		
			TreeList *MyTreeCoordinates = [[TreeList alloc]init];
			
            MyTreeCoordinates.treeId = sqlite3_column_int(sqlStatement, 0);
			
			// ERROR! The latitude is actually the longitude
            MyTreeCoordinates.lat = [NSNumber numberWithFloat:(float)sqlite3_column_double(sqlStatement, 2)];
			
			// ERROR! The longitude is actually the latitude
            MyTreeCoordinates.lng = [NSNumber numberWithFloat:(float)sqlite3_column_double(sqlStatement, 1)];
            
            // Tree name
            MyTreeCoordinates.tree = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
            
            // Scientific name
            MyTreeCoordinates.scientificname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 4)];
						
            [treeArray addObject:MyTreeCoordinates];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return treeArray;
    }
    
}




// Returns a single tree
- (TreeList *)getSingleTree: (NSUInteger)givenTreeId
{
	@try
	{
		// Create a tree object
		TreeList *myTree = [TreeList new];
		
	
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"MyTreesDBnew.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
		
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
		
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
		
		NSString *queryString;
		
		queryString = [NSString stringWithFormat:@"SELECT t.key, t.name, t.scientific_name, t.latitude, t.longitude, t.description, m.url FROM trees AS t, media AS m WHERE t.key = m.treeID AND m.precedence = 1 AND t.key = %lu;", (unsigned long)givenTreeId];

		const char *sql = [queryString UTF8String];
		
//        const char *sql = "SELECT key, name, scientific_name, latitude, longitude, description, picture FROM treewalk WHERE key = %@;", givenTreeId;

        sqlite3_stmt *sqlStatement;
		
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {

            myTree.treeId = sqlite3_column_int(sqlStatement, 0);
            myTree.tree = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            myTree.scientificname = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
            myTree.lng = [NSNumber numberWithFloat:(float)sqlite3_column_double(sqlStatement, 3)];
            myTree.lat = [NSNumber numberWithFloat:(float)sqlite3_column_double(sqlStatement, 4)];
            myTree.description = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
            myTree.picturename = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 6)];
            
		}
		
		// Return my tree object
		return myTree;
		
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    //@finally {
    //    return treeArray;
    //}

}



- (NSMutableArray *) getMyCoordinates{
    NSMutableArray *treeCoordinatesArray = [[NSMutableArray alloc] init];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"MyTreesDBnew.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT key, latitude, longitude, name, scientific_name FROM  trees";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            TreeList *MyTreeCoordinates = [[TreeList alloc]init];
            MyTreeCoordinates.treeId = sqlite3_column_int(sqlStatement, 0);
			
			// ERROR! The latitude is actually the longitude
            MyTreeCoordinates.lat = [NSNumber numberWithFloat:(float)sqlite3_column_double(sqlStatement, 2)];
			
			// ERROR! The longitude is actually the latitude
            MyTreeCoordinates.lng = [NSNumber numberWithFloat:(float)sqlite3_column_double(sqlStatement, 1)];
            
            // Tree name
            MyTreeCoordinates.tree = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
            
            // Scientific name
            MyTreeCoordinates.scientificname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 4)];
            
            [treeCoordinatesArray addObject:MyTreeCoordinates];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return treeCoordinatesArray;
    }
    
    
}




- (NSMutableArray *)getTreesWithSet:(NSNumber *)setId
{
    NSMutableArray *treeArray = [[NSMutableArray alloc] init];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"MyTreesDBnew.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
//        const char *sql = "SELECT t.key, t.latitude, t.longitude, t.name, t.scientific_name FROM trees as t, set_membership as s WHERE t.key = s.treeID AND s.setID = %d",;
        
        NSString *queryString;
        
        
		queryString = [NSString stringWithFormat:@"SELECT t.key, t.latitude, t.longitude, t.name, t.scientific_name FROM trees as t, set_membership as s WHERE t.key = s.treeID AND s.setID = %d", [setId intValue]];
        
        NSLog(@"query: %@", queryString);
        
		const char *sql = [queryString UTF8String];

        
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            TreeList *MyTreeCoordinates = [[TreeList alloc]init];
            MyTreeCoordinates.treeId = sqlite3_column_int(sqlStatement, 0);
			
			// ERROR! The latitude is actually the longitude
            MyTreeCoordinates.lat = [NSNumber numberWithFloat:(float)sqlite3_column_double(sqlStatement, 2)];
			
			// ERROR! The longitude is actually the latitude
            MyTreeCoordinates.lng = [NSNumber numberWithFloat:(float)sqlite3_column_double(sqlStatement, 1)];
            
            // Tree name
            MyTreeCoordinates.tree = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
            
            // Scientific name
            MyTreeCoordinates.scientificname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 4)];
						
            [treeArray addObject:MyTreeCoordinates];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return treeArray;
    }
    
    
}


@end
