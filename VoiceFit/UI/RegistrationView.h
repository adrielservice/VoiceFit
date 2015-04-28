//
//  RegistrationView.h
//  VoiceFit
//
//  Created by David Beilis on 4/27/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceFitAPIMgr.h"

@protocol UpdateView;

@interface RegistrationView : UIViewController<UpdateView>

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *registrationStatus;

- (IBAction)register:(id)sender;

@end
