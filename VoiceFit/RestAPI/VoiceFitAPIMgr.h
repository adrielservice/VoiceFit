//
//  VoiceFitAPIMgr.h
//  VoiceFit
//
//  Created by David Beilis on 4/27/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "UserSession.h"

@interface VoiceFitAPIMgr : NSObject {
    UserSession *userSession;
}

@property (nonatomic, retain) UserSession *userSession;

+ (id)sharedManager;

- (void) callGenesysFitnessApp;

- (void) configureRestKit;
- (void) registerWithUser:(User*) user;
- (void) getWorkoutSummary;
- (void) updateWorkoutProgress;
- (void) getWorkoutStats;

@end
