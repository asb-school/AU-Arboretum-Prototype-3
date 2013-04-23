//
//  TreeAnnotation.m
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 2/27/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//


// --------------------------------------------------------------
// IMPORTS

#import "TreeAnnotation.h"


// --------------------------------------------------------------
// BEGIN IMPLEMENTATION

@implementation TreeAnnotation


// --------------------------------------------------------------
// SYNTHESIZE PROPERTIES (setters & getters)

@synthesize treeId;
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;


// --------------------------------------------------------------
// SET COORDINATE WITH GIVEN LATITUDE & LONGITUDE

- (void)setCoordinateWithLatitude:(NSNumber *)givenLatitude andLongitude:(NSNumber *)givenLongitude
{
	CLLocationCoordinate2D temporaryCoordinate;
	
	temporaryCoordinate.latitude = [givenLatitude floatValue];
	temporaryCoordinate.longitude = [givenLongitude floatValue];

	[self setCoordinate: temporaryCoordinate];
}


@end
