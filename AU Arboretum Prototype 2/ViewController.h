//
//  ViewController.h
//  AU Arboretum Prototype 2
//
//  Created by Andrew Breja on 2/11/13.
//  Copyright (c) 2013 Andrews University. All rights reserved.
//


// --------------------------------------------------------------
// IMPORTS

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


// --------------------------------------------------------------
// INTERFACE DEFINITION

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstname;
@property (weak, nonatomic) IBOutlet UITextField *lastname;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *zip;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phone;


- (IBAction)reginfo:(id)sender;


@end
