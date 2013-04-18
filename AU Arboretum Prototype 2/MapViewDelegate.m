//
//  MapViewDelegate.m
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 2/27/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//


// --------------------------------------------------------------
// IMPORTS

#import "MapViewDelegate.h"
#import "TreeController.h"
#import "TreeAnnotation.h"
#import "TreeList.h"


// --------------------------------------------------------------
// DEFINITIONS

#define METERS_PER_MILE 1609.344


// --------------------------------------------------------------
// SETUP CLASS VARIABLES

TreeController *treeController;


// --------------------------------------------------------------
// BEGIN IMPLEMENTATION

@implementation MapViewDelegate


// --------------------------------------------------------------
// VIEW DID LOAD

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	
	// Setup zoom location (happens to be somewhere around middle of AU)
	CLLocationCoordinate2D zoomLocation;
	zoomLocation.latitude = 41.961134;
	zoomLocation.longitude = -86.357324;
	
	// Set view region
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
	
	// Active the view region to the set region
	[self.mapView setRegion: viewRegion animated: NO];
	
	// Create a new tree controller object
	treeController = [TreeController new];
	
	// Get annotations from tree controller and add to map view
	[self.mapView addAnnotations: [treeController getTreeAnnotations]];
}


// --------------------------------------------------------------
// VIEW DID APPEAR

- (void)viewDidAppear:(BOOL)animated
{

}


// --------------------------------------------------------------
// VIEW FOR ANNOTATION

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	// Create annotation identifier
 	static NSString *identifier = @"TreeAnnotation";
	
	// Check class of tree annotation
    if ([annotation isKindOfClass:[TreeAnnotation class]])
	{
		// Create the annotation view with the given identifier
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
		// If we have no annotation view set
		if (annotationView == nil)
		{
			// Create annotation view with given annotation ID
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
			
			// Create a button
			UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			button.frame = CGRectMake(0, 0, 23, 24);
			annotationView.rightCalloutAccessoryView = button;

			// Custom view -- failed experiement
			UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,366,455)];
			[leftCAV addSubview: [[[NSBundle mainBundle] loadNibNamed:@"annotationImageView" owner:self options:nil] lastObject]];
	
			//annotationView.rightCalloutAccessoryView = leftCAV;
			
			// Config options
            annotationView.enabled = YES;
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"ui_map_pin.png"];
		}
		
		// Nothing to do here
		else
		{
            annotationView.annotation = annotation;
        }
 
        return annotationView;
    }
 
    return nil;
}


// --------------------------------------------------------------
// DID SELECT ANNOTATION VIEW

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    // Animation to show the information view
    NSTimeInterval animationDuration = 0.2; // in seconds
    CGRect newFrameSize = CGRectMake(0, 690, 768, 266);
    
    // Begin animations
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    // Run animation
    _informationView.frame = newFrameSize;
    [UIView commitAnimations];
    
	// Get a reference to the current annotation
	TreeAnnotation *thisAnnotation = view.annotation;
	
	// Change pin image
	view.image = [UIImage imageNamed:@"ui_map_pin_selected.png"];
	
	// Get a reference to the this tree object
	TreeList *thisTree = [treeController getSingleTreeInformation: thisAnnotation.treeId];

	// Create an image object
	UIImage *treeImage = [UIImage imageNamed: thisTree.picturename];

	// Update tree information in UI
	[self.commonTreeNameLabel setText: thisTree.tree];
	[self.scientificTreeNameLabel setText: thisTree.scientificname];
	[self.treeDescriptionText setText: thisTree.description];
	[self.treeImage setImage: treeImage];
	
}


// --------------------------------------------------------------
// DID DESELECT ANNOTATION VIEW

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
	// Change pin image back to normal
	view.image = [UIImage imageNamed:@"ui_map_pin.png"];
}


// --------------------------------------------------------------
// VIEW WILL APPEAR

- (void)viewWillAppear:(BOOL)animated
{
    // Hide the information view
    CGRect newFrameSize = CGRectMake(0, 1030, 768, 266);
    _informationView.frame = newFrameSize;
    [UIView commitAnimations];
}


// --------------------------------------------------------------
// VIEW DID UNLOAD

- (void)viewDidUnload
{
	[self setCommonTreeNameLabel:nil];
	[self setScientificTreeNameLabel:nil];
	[self setTreeDescriptionText:nil];
	[self setTreeImage:nil];
    [self setInformationView:nil];
	[super viewDidUnload];
}
@end
