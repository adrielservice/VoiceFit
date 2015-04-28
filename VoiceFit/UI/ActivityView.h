//
//  ActivityView.h
//  VoiceFit
//
//  Created by David Beilis on 4/27/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityStatusView <NSObject>

- (void) update;

@end

@interface ActivityView : UIViewController<ActivityStatusView>

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *counter;

- (IBAction)updateActityStatus:(id)sender;

@end
