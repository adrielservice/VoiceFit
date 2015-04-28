//
//  ActivityView.h
//  VoiceFit
//
//  Created by David Beilis on 4/27/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceFitAPIMgr.h"

@protocol UpdateView;

@interface ActivityView : UIViewController<UpdateView>

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *counter;

- (IBAction)updateActityStatus:(id)sender;

@end
