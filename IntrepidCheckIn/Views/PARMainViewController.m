//
//  PARMainViewController.m
//  IntrepidCheckIn
//
//  Created by Paul Rolfe on 6/16/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "PARMainViewController.h"
#import "PARLocationTracker.h"
#import "PARSettings.h"

@interface PARMainViewController () <UITextFieldDelegate>

@property (nonatomic, strong) PARLocationTracker *locationTracker;
@property (nonatomic, weak) IBOutlet UIButton *trackButton;
@property (nonatomic, weak) IBOutlet UILabel *trackingStatus;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;


@end

@implementation PARMainViewController

#pragma mark - View Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.locationTracker = [[PARLocationTracker alloc] init];
    [self updateTrackingStatus];
    [self.trackButton.layer setCornerRadius:20];
    if ([PARSettings nameOfEmployee]){
        [self.nameTextField setText:[PARSettings nameOfEmployee]];
    }
}

- (void)updateTrackingStatus{
    if ([self.locationTracker isMonitoringForIntrepidRegion]){
        [self.trackingStatus setText:@"Tracking is on"];
        [self.trackButton setTitle:@"Stop tracking" forState:UIControlStateNormal];
    }
    else{
        [self.trackingStatus setText:@"Tracking is off"];
        [self.trackButton setTitle:@"Track!" forState:UIControlStateNormal];
    }
}

#pragma mark - IBActions

- (IBAction)trackButtonPressed:(id)sender{
    if ([self.locationTracker isMonitoringForIntrepidRegion]){
        [self.locationTracker stopMonitoring];
        [self updateTrackingStatus];
    }
    else{
        [self.locationTracker startMonitoringForIntrepid];
        [self updateTrackingStatus];
    }
}

#pragma mark - Text Field Delegate

- (void) textFieldDidEndEditing:(UITextField *)textField{
    [PARSettings setNameOfEmployee:textField.text];
}

@end
