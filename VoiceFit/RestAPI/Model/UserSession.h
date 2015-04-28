//
//  UserSession.h
//  VoiceFit
//
//  Created by David Beilis on 4/27/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "WorkoutSummary.h"
#import "WorkoutStats.h"

@interface UserSession : NSObject

@property (nonatomic, retain) User              *user;
@property (nonatomic, retain) NSString            *userId;
@property (nonatomic, retain) NSString            *phoneNumber;
@property (nonatomic, retain) WorkoutSummary    *workoutSummary;
@property (nonatomic, retain) WorkoutStats      *workoutStats;

@end
