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
NSInteger searchSelection, filteredindexes;
NSMutableArray *filteredFields,*fields, *picfields, *filteredpicFields,*options, *scientificFields, *nameFields, *_objects, *filteredScientificfields, *filtereddescription;



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
// PLOT ANNOTATIONS WITH SCIENTIFIC NAME

- (void)plotAnnotationsWithScientificName:(NSString *)givenScientificName
{
    // Get annotations with scientific name and add to map
    [self.mapView addAnnotations: [treeController getTreeAnnotationsForScientificName:givenScientificName]];
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
// FIND ANNOTATION WITH GIVEN TREE ID

- (void)findAnnotationWithGivenTreeId:(NSInteger)givenTreeId
{
    // Search all current map annotations
    // for (id<TreeAnnotation> annotation in _mapView.annotations)
    for (TreeAnnotation *annotation in _mapView.annotations)
    {
        if (annotation.treeId == givenTreeId)
        {
            [_mapView selectAnnotation:annotation animated:YES];
        }
    }
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
    
    //Refresh Table
    [self.table reloadData];
    
    //Pressed to unhide table/search when common names button is pressed
    [self.table setHidden:FALSE];
    [self.search setHidden:FALSE];
    
}

- (IBAction)SciNames:(id)sender{
    searchSelection = 1;
    //Refresh Table
    [self.table reloadData];
    
    //Pressed to unhide table/search when scientific names button is pressed
    [self.table setHidden:FALSE];
    [self.search setHidden:FALSE];
}

- (IBAction)CloseBrowse:(id)sender{
    
//Pressed to unhide table/search when browser closes
    [self.table setHidden:TRUE];
    [self.search setHidden:TRUE];

}

#pragma TableFunctions
//-----------------------------------------------------------------
//-----------------------------------------------------------------
//TABLE VIEW SUBROUTINES
//-----------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    //Allocates space for rows on table based on the number of abjects in array
   
    if(isFiltered){
        return[filteredFields count];
    }
    else{
     return [fields count];   
    }
    [self.table reloadData];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

//------------------------------------------------------------
//------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:@"Cell"];
    
    //Decides weather to print scientific names or common names to table cells
    if(searchSelection==1){
        fields = scientificFields;
    }
    if(searchSelection==0){
        fields = nameFields;
    }
    
    //Prints filtered images and names to cells after search
    if(isFiltered){
        cell.textLabel.text = filteredFields[indexPath.row];
        cell.imageView.image = filteredpicFields[indexPath.row];
        
    }else{
        
        //Prints  names and images to cells before search
        cell.textLabel.text = fields[indexPath.row];
        cell.imageView.image = picfields[indexPath.row];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

//-------------------------------------------------------------------
//------------------------------------------------------------
 - (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     
     //Witdraw keybord when cell is clicked
     
     [self.search resignFirstResponder];
     // Update tree information in UI
     NSInteger index = indexPath.row;
     
     
     // Update tree information in UI after search when cell is clicked
     if(isFiltered){
         [self.commonTreeNameLabel setText:[filteredFields objectAtIndex:index]];
        [self.scientificTreeNameLabel setText:[filteredScientificfields objectAtIndex:index]];
         [self.treeDescriptionText setText:[filtereddescription objectAtIndex:index]];
         [self.treeImage setImage:[filteredpicFields objectAtIndex:index]];
     }
     // Update tree information in UI before search when cell is clicked
     if(!isFiltered){
         [self.treeImage setImage:[UIImage imageNamed:((TreeList *) [_objects objectAtIndex:index]).picturename]];
         [self.commonTreeNameLabel setText:((TreeList *) [_objects objectAtIndex:index]).tree];
         [self.scientificTreeNameLabel setText:((TreeList *) [_objects objectAtIndex:index]).scientificname];
         [self.treeDescriptionText setText:((TreeList *) [_objects objectAtIndex:index]).description];
     }
    // [self.table reloadData];
 }



#pragma SEARCHBAR
//-----------------------------------------------------------------
//-----------------------------------------------------------------
//SEARCH BAR SUBROUTINES
//-----------------------------------------------------------------

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //Initialize Populates filtered arrays when there is input in search bars
    if(searchText.length==0){
        isFiltered=NO;}
    else{
        isFiltered=YES;
        filteredFields =[ [NSMutableArray alloc] init];
         filteredpicFields =[ [NSMutableArray alloc] init];
        filteredScientificfields= [ [NSMutableArray alloc] init];
        filtereddescription =[ [NSMutableArray alloc] init];
        filteredindexes = 0;
        
        //Loops through rows to mach them with search input
        for(NSString *string in fields){
            NSRange TreeRange = [string rangeOfString:searchText options: NSCaseInsensitiveSearch];
            if(TreeRange.location!= NSNotFound){
                
                //Add the information for the filtered searched information into their own fultered arrays
                [filteredpicFields addObject:[picfields objectAtIndex:filteredindexes]];
                [filteredScientificfields addObject:[scientificFields objectAtIndex:filteredindexes]];
                [filtereddescription addObject:((TreeList *) [_objects objectAtIndex:filteredindexes]).description];
                [ filteredFields addObject:string ];
                
            }
            filteredindexes++;
        }
    }
    [self.table reloadData];
}
//------------------------------------------------------------------


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //Position Search Bar
     self.searchDisplayController.searchBar.frame=CGRectMake(0, 44, 248, 44);
    
    //Withdaraws keyboard when search button clicked
    [self.table resignFirstResponder];
}

//-----------------------------------------------------------------
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {

}

//-----------------------------------------------------------------
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.search resignFirstResponder];
    
    //Refreshes the table when Cancel Button Clicked
    [filteredFields removeAllObjects];
    [filteredpicFields removeAllObjects];
    [filteredpicFields addObjectsFromArray:picfields];
    [filteredFields addObjectsFromArray:fields];
    self.search.text = nil;
    [self.table reloadData];
    isFiltered=FALSE;
    
    //Set Position and size of table when search button clicked
    CGRect newFrame = CGRectMake(0, 88, 248, 652);
    self.table.frame = newFrame;
    
}
//-----------------------------------------------------------------
-(void)searchDisplayController: (UISearchDisplayController*)controller
 didShowSearchResultsTableView: (UITableView*)tableView
{
    //Set Position and size of table when search results shown
    CGRect newFrame = CGRectMake(0, 88, 248, 618);
    self.table.frame = newFrame;
        tableView.frame = newFrame;
}
//-----------------------------------------------------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // dismiss keyboard through `resignFirstResponder` When anything is pressed
    [self.search resignFirstResponder];
    
    //Set Position and size of table when clicked
    CGRect newFrame = CGRectMake(0, 88, 248, 618);
    self.table.frame = newFrame;


}
@end