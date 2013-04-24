//
//  SetInformation.m
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 4/24/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//

#import "SetInformation.h"

@implementation SetInformation

static NSNumber *setId;

+ (NSNumber *)getSetId
{
    return setId;
}

+ (void)defineSetId:(NSNumber *)givenSetId
{
    setId = givenSetId;
}

@end
