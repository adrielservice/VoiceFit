//
//  WorkoutSummary.h
//  VoiceFit
//
//  Created by David Beilis on 4/27/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkoutSummary : NSObject

@property (nonatomic, copy) NSString            *activity;
@property (nonatomic, copy) NSString            *status;
@property (nonatomic) NSInteger                 totalRemaining;

@end
