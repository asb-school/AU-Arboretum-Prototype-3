//
//  TreeAnnotation.h
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 2/27/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//


// --------------------------------------------------------------
// IMPORTS

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>


// --------------------------------------------------------------
// BEGIN DEFINITION

@interface TreeAnnotation : NSObject <MKAnnotation>
{
	// VARIABLES
}

// PROPERTIES
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSUInteger treeId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;


// METHODS
- (void)setCoordinateWithLatitude: (NSNumber *)givenLatitude andLongitude: (NSNumber *)givenLongitude;

@end
