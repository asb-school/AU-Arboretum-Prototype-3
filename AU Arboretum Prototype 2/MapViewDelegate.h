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


// --------------------------------------------------------------
// INTERFACE DEFINITION

@interface MapViewDelegate : UIViewController <MKMapViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate >

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


//Search Bar
@property (strong, nonatomic) IBOutlet UISearchBar *search;

//Custom Tableview
@property (strong, nonatomic) IBOutlet UITableView *table;





// METHODS
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;

- (IBAction)GetTreeListing:(id)sender;



@end