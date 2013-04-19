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

//Synthesizing textfields and buttion for registration form
@implementation ViewController
@synthesize firstname;
@synthesize lastname;
@synthesize address;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize email;
@synthesize phone;


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
		
}


- (void)viewDidUnload {
    [self setFirstname:nil];
    [self setLastname:nil];
    [self setAddress:nil];
    [self setCity:nil];
    [self setState:nil];
    [self setZip:nil];
    [self setEmail:nil];
    [self setPhone:nil];
    [super viewDidUnload];
}

//defining action for the register button
- (IBAction)reginfo:(id)sender {
    NSString *strURL = [NSString stringWithFormat:@"http://www.andrews.edu/~gaynor/phpFileonline.php?fname=%@&lname=%@&address=%@&city=%@&state=%@&zip=%@&email=%@&phone=%@",firstname.text,lastname.text,address.text,city.text,state.text,zip.text,email.text,phone.text];
    NSString *finalString = [strURL stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:finalString]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strResult);
    
    //creating an alert for when registration is complete
    UIAlertView *thankyou = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:@"We will contact you with more information on donating to the AU Arboretum." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [thankyou show];
}
@end
