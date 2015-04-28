//
//  RegistrationView.m
//  VoiceFit
//
//  Created by David Beilis on 4/27/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import "RegistrationView.h"
#import "VoiceFitAPIMgr.h"

@interface RegistrationView ()

@end

@implementation RegistrationView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VoiceFitAPIMgr* mgr = [VoiceFitAPIMgr sharedManager];
    if (mgr.userSession) {
        self.registrationStatus.text = @"Registered";
        self.txtFirstName.text = mgr.userSession.user.firstName;
        self.txtLastName.text = mgr.userSession.user.lastName;
        self.txtPhoneNumber.text = mgr.userSession.user.phoneNumber;
    } else {
        self.registrationStatus.text = @"Unregistered";
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)register:(id)sender {
    User *user = [User alloc];
    user.firstName = self.txtFirstName.text;
    user.lastName = self.txtLastName.text;
    user.phoneNumber = self.txtPhoneNumber.text;
    VoiceFitAPIMgr *mgr = [VoiceFitAPIMgr sharedManager];
    [mgr registerWithUser:user callback:self];
}

#pragma mark - Callback

- (void) update {
    self.registrationStatus.text = @"Registered";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
