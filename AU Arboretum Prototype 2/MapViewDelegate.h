//
//  MapViewDelegate.h
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 2/27/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//


// --------------------------------------------------------------
// IMPORTS

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IIViewDeckController.h"
#import "TreeController.h"
#import "TreeAnnotation.h"
#import "TreeList.h"


// --------------------------------------------------------------
// INTERFACE DEFINITION

@interface MapViewDelegate : UIViewController <MKMapViewDelegate>
{
	// VARIABLES
    BOOL informationViewHidden;
    BOOL noFurtherAnnotationsSelected;
    TreeController *treeController;
}

// PROPERTIES

// Our custom map view
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

// Common tree name label
@property (strong, nonatomic) IBOutlet UILabel *commonTreeNameLabel;

// Scientific name label
@property (strong, nonatomic) IBOutlet UILabel *scientificTreeNameLabel;

// Description text field
@property (strong, nonatomic) IBOutlet UITextView *treeDescriptionText;

// Tree image
@property (strong, nonatomic) IBOutlet UIImageView *treeImage;

// Information view
@property (strong, nonatomic) IBOutlet UIView *informationView;


// METHODS
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;
- (void)plotAllAnnotations;
- (void)showInformationView;
- (void)hideInformationViewAndClear:(BOOL)clearView;
- (void)hideInformationViewOnTimeout;
- (void)clearView;
- (void)selectAllTreesNotification:(NSNotification *)notification;
- (void)selectTreeNotification:(NSNotification *)notification;
- (void)plotAnnotationsWithCommonName:(NSString *)givenCommonName;
- (void)findAnnotationWithGivenTreeId:(NSInteger)givenTreeId;
- (IBAction)hideShowAction:(id)sender;
- (void)searchButton;
- (void)backButton;


@end
