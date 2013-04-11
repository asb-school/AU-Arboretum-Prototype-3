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
#import "MyTreeLists.h"


// --------------------------------------------------------------
// DEFINITIONS

#define METERS_PER_MILE 1609.344


// --------------------------------------------------------------
// SETUP CLASS VARIABLES

TreeController *treeController;
MyTreeLists *mytrees;
Boolean isFiltered;
NSInteger searchSelection;

NSMutableArray *filteredFields,*fields, *picfields, *filteredpicFields,*options, *scientificFields, *nameFields, *_objects;



// --------------------------------------------------------------
// BEGIN IMPLEMENTATION

@implementation MapViewDelegate


// --------------------------------------------------------------
// VIEW DID LOAD

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    //Hide Table & Searchbar When program is initialized
	[self.table setHidden:TRUE];
    [self.search setHidden:TRUE];
    
    MyTreeLists * mytrees =[[MyTreeLists alloc] init];
    
    //Put mutable array for objects fields in variable
    
  //  Initialize Arrays
    _objects =  [mytrees getMyTrees];
    fields = [[NSMutableArray alloc]init];
    picfields = [[NSMutableArray alloc] init];
    scientificFields =[[NSMutableArray alloc] init];
    nameFields = [[NSMutableArray alloc] init];
    
    NSInteger i = 0;
    //Populate fields array with name fields form database
    while (i<_objects.count) {
        [fields addObject:((TreeList *) [_objects objectAtIndex:i]).tree];
        [nameFields addObject:((TreeList *) [_objects objectAtIndex:i]).tree];
        [scientificFields addObject:((TreeList *) [_objects objectAtIndex:i]).scientificname];
        [picfields addObject: [UIImage imageNamed:((TreeList *) [_objects objectAtIndex:i]).picturename]];
        i=i+1;
    }
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
// DID SELECT ANNOTATION VIEW

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	// Get a reference to the current annotation
	TreeAnnotation *thisAnnotation = view.annotation;
	
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
// VIEW WILL APPEAR

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload {
	[self setCommonTreeNameLabel:nil];
	[self setScientificTreeNameLabel:nil];
	[self setTreeDescriptionText:nil];
	[self setTreeImage:nil];
	[super viewDidUnload];
}


//------------------------------------------------------------
//BUTTON FUNCTIONS


- (IBAction)Browse:(id)sender {
    searchSelection = 0;
    [self.table reloadData];
    [self.table setHidden:FALSE];
    [self.search setHidden:FALSE];
     NSLog(@"The result is %i", searchSelection);
    
}

- (IBAction)CloseBrowse:(id)sender{
    
    [self.table setHidden:TRUE];
    [self.search setHidden:TRUE];

}

- (IBAction)SciNames:(id)sender{
    searchSelection = 1;
    [self.table reloadData];
    [self.table setHidden:FALSE];
    [self.search setHidden:FALSE];
    NSLog(@"The result is %i", searchSelection);
    
}
    

//----------------------------------------------------------
//--------------------------------------------------------
#pragma TableFunctions
//---------------------------------------------------------
//---------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
   
    
    if(isFiltered){
        return[filteredFields count];
    }
    return ([fields count]);
    
    [self.table reloadData];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

//------------------------------------------------------------
//------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(searchSelection==1){
        fields = scientificFields;
    }
    if(searchSelection==0){
        fields = nameFields;
    }
    if(isFiltered){
        NSString *object = filteredFields[indexPath.row];
        UIImage *picObj = filteredpicFields[indexPath.row];
        cell.textLabel.text = [object description];
        cell.imageView.image = picObj;
        
    }else{
        NSString *object = fields[indexPath.row];
        UIImage *picObj = picfields[indexPath.row];
        cell.textLabel.text = object;
        cell.imageView.image = picObj;
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


//-------------------------------------------------------------------
//------------------------------------------------------------
 - (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     
     // Update tree information in UI
     NSInteger index = indexPath.row;
     NSLog(@"The result is %i", index);
     [self.treeImage setImage:[UIImage imageNamed:((TreeList *) [_objects objectAtIndex:index]).picturename]];
     [self.commonTreeNameLabel setText:((TreeList *) [_objects objectAtIndex:index]).tree];
     [self.scientificTreeNameLabel setText:((TreeList *) [_objects objectAtIndex:index]).scientificname];
     [self.treeDescriptionText setText:((TreeList *) [_objects objectAtIndex:index]).description];
     
    // [self.table reloadData];
 }



#pragma SEARCHBAR
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//SEARCH BAR SUBROUTINES
//-------------------------------------------------------------------------------
//-----------------------------------------------------------------------------

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length==0){
        isFiltered=NO;}
    else{
        isFiltered=YES;
        filteredFields =[ [NSMutableArray alloc] init];
        for(NSString *strin in fields){
            NSRange TreeRange = [strin rangeOfString:searchText options: NSCaseInsensitiveSearch];
            if(TreeRange.location!= NSNotFound){
                [ filteredFields addObject:strin ];
            }
        }
    }
    [self.table reloadData];
}
//-------------------------------------------------------------------------------
//-----------------------------------------------------------------------------
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.table resignFirstResponder];
    
}

//-------------------------------------------------------------------------------
//-----------------------------------------------------------------------------

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.table resignFirstResponder];
}

//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    self.searchDisplayController.searchBar.frame=CGRectMake(0, 44, 248, 44);

}


@end