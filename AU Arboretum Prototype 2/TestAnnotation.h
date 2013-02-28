//
//  TestAnnotation.h
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 2/18/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TestAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
