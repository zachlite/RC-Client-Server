//
//  SettingsViewController.m
//  Remote Control
//
//  Created by Zach Lite on 7/22/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#import "SettingsViewController.h"
#import "RemoteAppDelegate.h"
@interface SettingsViewController ()

@property (nonatomic, retain) NSString *host_field_value;
@property (nonatomic, retain) NSString *port_field_value;

@end

@implementation SettingsViewController
@synthesize HostField;
@synthesize PortField;

@synthesize host_field_value;
@synthesize port_field_value;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(id)sender {
    
    
    
    [self.delegate getFromViewController:self :self.HostField.text :self.PortField.text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.PortField resignFirstResponder];
    [self.HostField resignFirstResponder];
}

@end
