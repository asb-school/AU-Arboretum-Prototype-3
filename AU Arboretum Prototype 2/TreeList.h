//
//  TreeList.h
//  MyTreeListIpad
//
//  Created by Martin Gaynor on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeList : NSObject{
    NSInteger treeId;
    NSString *tree;
    NSString *scientificname;
    NSString *description;
    NSString *picturename;
    UIImage *picture;
    NSNumber *lat;
    NSNumber *lng;
    
}

@property (nonatomic, assign) NSInteger treeId;
@property (nonatomic, retain) NSString *tree;
@property (nonatomic, retain) NSString *scientificname;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *picturename;
@property (nonatomic, retain) UIImage *picture;
@property (nonatomic, retain) NSNumber *lat;
@property (nonatomic, retain) NSNumber *lng;

@end
