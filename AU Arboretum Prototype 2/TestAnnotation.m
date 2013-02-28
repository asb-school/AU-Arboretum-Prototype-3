//
//  TestAnnotation.m
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 2/18/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//

#import "TestAnnotation.h"

@implementation TestAnnotation

- (NSString *)title {
    return [NSString stringWithFormat:@"%i", self.level];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: (%f, %f)", [super description], self.coordinate.longitude, self.coordinate.latitude];
}

@end
