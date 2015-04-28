//
//  Phone.h
//  VoiceFit
//
//  Created by David Beilis on 4/27/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneView : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *callButton;

- (IBAction)makeCall:(id)sender;

@end
