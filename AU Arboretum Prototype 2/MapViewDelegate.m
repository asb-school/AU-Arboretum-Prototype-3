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


// --------------------------------------------------------------
// DEFINITIONS

#define METERS_PER_MILE 1609.344


// --------------------------------------------------------------
// BEGIN IMPLEMENTATION

@implementation MapViewDelegate


// --------------------------------------------------------------
// VIEW DID LOAD

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	// Setup observers on the notification center for:
	
	// Select trees with a specific type
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTreeNotification:) name:@"selectTreesWithCustomType" object:nil];
    
	// Select all trees
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAllTreesNotification:) name:@"selectAllTrees" object:nil];
    
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
    
	// Plot annotations with set id
    [self plotAnnotationsWithSet:[SetInformation getSetId]];
}


// --------------------------------------------------------------
// SELECT ALL TREES NOTIFICATION

- (void)selectAllTreesNotification:(NSNotification *)notification
{
	// Hide search pane
	[self.viewDeckController toggleLeftViewAnimated:YES];
	
	// Plot all annotations
	[self plotAllAnnotations];
}


// --------------------------------------------------------------
// SELECT TREE NOTIFICATION

- (void)selectTreeNotification:(NSNotification *)notification
{
	// Extract the tree information dictionary from the notification object wrapper
    NSDictionary *treeInformation = notification.userInfo;
	
	// Hide search pane
	[self.viewDeckController toggleLeftViewAnimated:YES];
	
	// Plot annotations with the given name from the tree information dictionary
	[self plotAnnotationsWithCommonName:[treeInformation objectForKey:@"treeType"]];
}


// --------------------------------------------------------------
// PLOT ALL ANNOTATIONS

- (void)plotAllAnnotations
{
	// Clear any annotations
	if ([self.mapView annotations])
	{
		[self.mapView removeAnnotations:[self.mapView annotations]];
	}
	
	// Get annotations from tree controller and add to map view
	[self.mapView addAnnotations: [treeController getTreeAnnotations]];
}


// --------------------------------------------------------------
// PLOT ANNOTATIONS WITH COMMON NAME

- (void)plotAnnotationsWithCommonName:(NSString *)givenCommonName
{
	// New container for returned annotations
	NSMutableArray *returnedAnnotations = [NSMutableArray new];
	
	// Get tree annotations with the given common name
	returnedAnnotations = [treeController getTreeAnnotationsForType:givenCommonName];
	
	// Check if we have results
	if (returnedAnnotations)
	{
		// If we have more than 0
		if ([returnedAnnotations count] > 0)
		{
			// Clear the map of any annotations
			[self.mapView removeAnnotations:[self.mapView annotations]];
			
			// Add the annotations to the map
			[self.mapView addAnnotations:returnedAnnotations];
		}
	}
}


// --------------------------------------------------------------
// PLOT ANNOTATIONS WITH SET ID

- (void)plotAnnotationsWithSet:(NSNumber *)givenSetId
{
    // New container for returned annotations
	NSMutableArray *returnedAnnotations = [NSMutableArray new];
	
	// Get tree annotations with the given common name
	returnedAnnotations = [treeController getTreeAnnotationsForSet:givenSetId];
	
	// Check if we have results
	if (returnedAnnotations)
	{
		// If we have more than 0
		if ([returnedAnnotations count] > 0)
		{
			// Clear the map of any annotations
			[self.mapView removeAnnotations:[self.mapView annotations]];
			
			// Add the annotations to the map
			[self.mapView addAnnotations:returnedAnnotations];
		}
	}
}


// --------------------------------------------------------------
// VIEW DID APPEAR

- (void)viewDidAppear:(BOOL)animated
{
    // Select a tree on launch
    // [self findAnnotationWithGivenTreeId:1];
}


// --------------------------------------------------------------
// HIDE SHOW ACTION FOR INFORMATION VIEW

- (IBAction)hideShowAction:(id)sender
{
    // If information view is hidden
    if (informationViewHidden)
    {
        [self showInformationView];
    }
    
    // If information view is showing
    else
    {
        [self hideInformationViewAndClear:NO];
    }
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
			
			// Failed experiment
			/* Create a button
			UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			button.frame = CGRectMake(0, 0, 23, 24);
            
			//annotationView.rightCalloutAccessoryView = button;

			// Custom view -- failed experiement
			UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,366,455)];
			[leftCAV addSubview: [[[NSBundle mainBundle] loadNibNamed:@"annotationImageView" owner:self options:nil] lastObject]];
	
			//annotationView.rightCalloutAccessoryView = leftCAV;*/
			
			// Config options
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
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
    // Hide search pane
    [self.viewDeckController closeLeftViewAnimated:YES];
    
    // Cancel hiding of display if an annotation is selected
    noFurtherAnnotationsSelected = FALSE;
    
    // Show the information view
    [self showInformationView];
    
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
    
    
    /* Create an assumption that no further annotations will be selected.
     * Then, call a function to hide the information view after a specified
     * delay. This delayed function will only hide the information view if
     * the toggle is true. If another annotation is selected before the delay
     * time expires, the toggle will be set to false. Thus the function which
     * hides the information view will not execute the hiding of the 
     * information view.
    */
    
    noFurtherAnnotationsSelected = TRUE;
    
    // Call information hide function with delay
    [self performSelector:@selector(hideInformationViewOnTimeout) withObject:nil afterDelay:0.7];
    

}


// --------------------------------------------------------------
// SHOW INFORMATION VIEW

- (void)showInformationView
{
    // Animation to show the information view
    NSTimeInterval animationDuration = 0.2; // in seconds
    CGRect newFrameSize = CGRectMake(0, 600, 768, 365);
    
    // Begin animations
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    // Run animation
    _informationView.frame = newFrameSize;
    [UIView commitAnimations];
    
    // Toggle status of information view
    informationViewHidden = FALSE;
}


// --------------------------------------------------------------
// HIDE INFORMATION VIEW

- (void)hideInformationViewAndClear:(BOOL)clearView
{
    // Animation to hide the information view
    NSTimeInterval animationDuration = 0.2; // in seconds
    CGRect newFrameSize = CGRectMake(0, 930, 768, 365);
    
    // Begin animations
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    // Run animation
    _informationView.frame = newFrameSize;
    [UIView commitAnimations];
    
    // Toggle status
    informationViewHidden = TRUE;
    
    // If we need to clear the view
    if (clearView)
    {
        // Wait a bit until the animation has completed to clear view
        [self performSelector:@selector(clearView) withObject:nil afterDelay:0.5];
    }
}


// --------------------------------------------------------------
// HIDE INFORMATION VIEW ON TIMEOUT

- (void)hideInformationViewOnTimeout
{
    if (noFurtherAnnotationsSelected)
    {
        [self hideInformationViewAndClear:YES];
    }
}


// --------------------------------------------------------------
// CLEAR VIEW

- (void)clearView
{
    [self.commonTreeNameLabel setText: @""];
    [self.scientificTreeNameLabel setText: @""];
    [self.treeDescriptionText setText: @""];
    [self.treeImage setImage: nil];
}


// --------------------------------------------------------------
// FIND ANNOTATION WITH GIVEN TREE ID

- (void)findAnnotationWithGivenTreeId:(NSInteger)givenTreeId
{
    // Search all current map annotations
    for (TreeAnnotation *annotation in _mapView.annotations)
    {
        // If the current annotation matches the given tree id
        if (annotation.treeId == givenTreeId)
        {
            // Select it on the map
            [_mapView selectAnnotation:annotation animated:YES];
        }
    }
}


// --------------------------------------------------------------
// SEARCH BUTTON

- (void)searchButton
{
	[self.viewDeckController toggleLeftViewAnimated:YES];
}


// --------------------------------------------------------------
// BACK BUTTON

-(void)backButton
{
    [self.viewDeckController closeLeftViewAnimated:NO];
	[self.navigationController popViewControllerAnimated:YES];
}


// --------------------------------------------------------------
// VIEW WILL APPEAR

- (void)viewWillAppear:(BOOL)animated
{
    // Create an array to store the custom UI buttons
    NSMutableArray *customUIButtons = [NSMutableArray new];

	UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[leftSpace setWidth:10];
	
	[customUIButtons addObject:leftSpace];

	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage: [UIImage imageNamed:@"ui_back_button.png"] forState:UIControlStateNormal];

	backButton.frame = CGRectMake(0, 0, 30, 26);
	
	[backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	
	[customUIButtons addObject:backButtonItem];
	

	UIBarButtonItem *searchSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[searchSpace setWidth:30];
	
	[customUIButtons addObject:searchSpace];

	// Custom search button
	UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[searchButton setImage: [UIImage imageNamed:@"ui_search_button.png"] forState:UIControlStateNormal];
	
	searchButton.frame = CGRectMake(0, 0, 32, 26);
	
	[searchButton addTarget:self action:@selector(searchButton) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
	
	[customUIButtons addObject:searchButtonItem];
	
    
    // Set left bar button items to the custom UI buttons we created earlier
    self.navigationItem.leftBarButtonItems = customUIButtons;
    
    // This allows us to add the custom UI buttons in ADDITION to the back button.
    // If this was set to NO, it would not show the back button.
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    
    // self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImage *customBarImage = [UIImage imageNamed:@"ui_navigation_bar"];

    [navigationBar setBackgroundImage:customBarImage forBarMetrics:UIBarMetricsDefault];
    
    
    
    // Hide the information view
    CGRect newFrameSize = CGRectMake(0, 930, 768, 365);
    _informationView.frame = newFrameSize;
    [UIView commitAnimations];
    
    // Toggle status of information view
    informationViewHidden = TRUE;
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
