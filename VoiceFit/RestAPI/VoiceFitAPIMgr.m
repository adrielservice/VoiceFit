//
//  VoiceFitAPIMgr.m
//  VoiceFit
//
//  Created by David Beilis on 4/27/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import "VoiceFitAPIMgr.h"
#import <RestKit/RestKit.h>

@implementation VoiceFitAPIMgr

@synthesize userSession;

#pragma mark Singleton Methods

- (id) init {
    [self configureRestKit];
    
    return self;
};

+ (id) sharedManager {
    static VoiceFitAPIMgr *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[VoiceFitAPIMgr alloc] init];
    });
    return _sharedInstance;
};

#pragma mark REST methods

- (void) registerWithUser:(User*) user {
    
    // clean resources
    if (userSession) {
        if (userSession.user) {
            userSession.user = nil;
            userSession.workoutStats = nil;
            userSession.workoutSummary = nil;
        }
        
        user = nil;
    }
    userSession = nil;
    
    [[RKObjectManager sharedManager] postObject:user path:@"/users" parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            userSession = [[UserSession alloc] init];
                                            userSession.user = user;
                                            userSession.user.userId = mappingResult.dictionary[@"user_id"];
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                        }];
};

- (void) getWorkoutSummary {
    
    if (userSession && userSession.user && userSession.user.userId) {
        NSString *workoutPath = [@"/workout/" stringByAppendingString:userSession.user.userId];
        
        WorkoutSummary *workoutSummary = [[WorkoutSummary alloc] init];
        
        [[RKObjectManager sharedManager] getObject:workoutSummary path:workoutPath parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               // TODO: Read user ID
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                           }];
    } else {
        NSLog(@"Session is not initialized");
    }
    
};

- (void) updateWorkoutProgress {
    
    if (userSession && userSession.user && userSession.user.userId && userSession.workoutSummary) {
    } else {
        NSLog(@"Session is not initialized");
    }
};

- (void) getWorkoutStats {
    
}

- (void) callGenesysFitnessApp {
    
    if (userSession && userSession.phoneNumber) {
        
        NSString *phoneNumber = userSession.phoneNumber;
        
        NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@", phoneNumber ];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
        
        NSLog(@"Calling %@", phoneCallNum);
    } else {
        NSLog(@"Session is not initialized");
    }
}

- (void)configureRestKit {
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://52.6.170.226/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping addAttributeMappingsFromArray:@[@"name"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseUserDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/users"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseUserDescriptor];
    
    // setup object mappings
    RKObjectMapping *userSessionMapping = [RKObjectMapping mappingForClass:[userSession class]];
    [userSessionMapping addAttributeMappingsFromArray:@[@"name"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseSessionDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userSessionMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/workouts"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseSessionDescriptor];
    
    
}


@end
