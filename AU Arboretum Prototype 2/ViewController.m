//
//  ViewController.m
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 2/11/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//


// --------------------------------------------------------------
// IMPORTS

#import "ViewController.h"


// --------------------------------------------------------------
// BEGIN IMPLEMENTATION

@implementation ViewController


// --------------------------------------------------------------
// VIEW DID LOAD

- (void)viewDidLoad
{
    [super viewDidLoad];
	
		
}


// --------------------------------------------------------------
// DID RECEIVE MEMORY WARNING

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// --------------------------------------------------------------
// VIEW DID APPEAR

- (void)viewDidAppear:(BOOL)animated
{

}


// --------------------------------------------------------------
// VIEW WILL APPEAR

- (void)viewWillAppear:(BOOL)animated
{
	// Hide navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:animated];
	[super viewWillAppear:animated];
}


// --------------------------------------------------------------
// VIEW WILL DISAPPEAR

- (void)viewWillDisappear:(BOOL)animated
{
	// Show navigation bar
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	[super viewWillDisappear:animated];
}

@end
