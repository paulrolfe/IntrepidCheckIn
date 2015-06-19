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
#import "PARSlackRequestManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PARMainViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) PARLocationTracker *locationTracker;
@property (nonatomic, weak) IBOutlet UIButton *trackButton;
@property (nonatomic, weak) IBOutlet UILabel *trackingStatus;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UIButton *uploadButton;
@property (nonatomic, weak) IBOutlet UITextView *arrivingTextView;
@property (nonatomic, weak) IBOutlet UITextView *leavingTextView;


@end

@implementation PARMainViewController

#pragma mark - View Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.locationTracker = [[PARLocationTracker alloc] init];
    [self updateTrackingStatus];
    [self.trackButton.layer setCornerRadius:20];
    [self.userImageView.layer setCornerRadius:20];
    [self.arrivingTextView.layer setCornerRadius:4];
    [self.leavingTextView.layer setCornerRadius:4];
    
    if ([PARSettings nameOfEmployee]){
        [self.nameTextField setText:[PARSettings nameOfEmployee]];
    }
    if ([PARSettings iconWebURL]){
        [self.uploadButton setTitle:@"Change Your Photo" forState:UIControlStateNormal];
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[PARSettings iconWebURL]]];
    }
    self.arrivingTextView.text = [PARSettings arrivingMessage];
    self.leavingTextView.text = [PARSettings leavingMessage];
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

- (IBAction)uploadButtonPressed:(id)sender{
    //show action options.
    UIAlertController * actionSheet = [UIAlertController alertControllerWithTitle:@"Upload" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }]];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }]];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - Text Field Delegate

- (void) textFieldDidEndEditing:(UITextField *)textField{
    [PARSettings setNameOfEmployee:textField.text];
}

#pragma mark - TextView Delegate

- (void)textViewDidEndEditing:(UITextView *)textView{
    [PARSettings setLeavingMessage:self.leavingTextView.text];
    [PARSettings setArrivingMessage:self.arrivingTextView.text];
}

#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //Set image.
    self.userImageView.image = info[UIImagePickerControllerEditedImage];
    //upload it.
    [[PARSlackRequestManager sharedManager] uploadAndSavePhoto:info[UIImagePickerControllerEditedImage]];
    self.uploadButton.titleLabel.text = @"Change Your Photo";
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
