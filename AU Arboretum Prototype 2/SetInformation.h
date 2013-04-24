//
//  SetInformation.h
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 4/24/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetInformation : NSObject

+ (NSNumber *)getSetId;
+ (void)defineSetId:(NSNumber *)givenSetId;

@end
