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

- (void) registerWithUser:(User*)user callback:(id<UpdateView>)callback{
    
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
    
    user.username = [user.firstName stringByAppendingString:user.lastName];
    
    [[RKObjectManager sharedManager] postObject:user path:@"/users" parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            NSLog(@"It Worked: %@", [mappingResult array][0]);
                                            
                                            self.userSession = [mappingResult array][0];
                                            self.userSession.user = user;
                                            self.userSession.phoneNumber = @"18489993383";
                                            
                                            NSLog(@"UserId: %@", self.userSession.userId);
                                            
                                            [callback update];
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                        }];
};

- (void) getWorkoutSummaryWithCallback:(id<UpdateView>)callback {
    
    if (userSession && userSession.userId) {
        NSString *workoutPath = [@"/workouts/" stringByAppendingString:userSession.userId];
        
        [[RKObjectManager sharedManager] getObjectsAtPath:workoutPath parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               
                                               self.userSession.workoutSummary = [mappingResult array][0];
                                               
                                               [callback update];
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                           }];
    } else {
        NSLog(@"Session is not initialized");
    }
    
};

- (void) updateWorkoutProgressWithCallback:(id<UpdateView>)callback {
    if (userSession && userSession.userId && userSession.workoutSummary) {
        NSString *workoutPath = [@"/workouts/" stringByAppendingString:userSession.userId];
        workoutPath = [workoutPath stringByAppendingString:@"/rep"];
        
        [[RKObjectManager sharedManager] postObject:nil path:workoutPath parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               
                                               self.userSession.workoutSummary = [mappingResult array][0];
                                               
                                               [callback update];
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                           }];
    } else {
        NSLog(@"Workout is not initialized");
    }
    
};

- (void) getWorkoutStatsWithCallback:(id)callback {
    
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
    // NSURL *baseURL = [NSURL URLWithString:@"http://172.20.27.208:64939/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [objectManager setRequestSerializationMIMEType: RKMIMETypeJSON];
    
    // what to print
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    
    //---------------------------------------------------------------------------------------------------
    
    
    RKObjectMapping *userSessionRequestMapping =  [[User defineRequestMapping] inverseMapping];
    
    [objectManager addRequestDescriptor: [RKRequestDescriptor requestDescriptorWithMapping:userSessionRequestMapping objectClass:[User class] rootKeyPath:nil method:RKRequestMethodPOST]];
    
    // setup object mappings
    RKObjectMapping *userSessionResponseMapping = [RKObjectMapping mappingForClass:[UserSession class]];
    [userSessionResponseMapping addAttributeMappingsFromDictionary:@{
                                                         @"userId": @"userId",
                                                         @"phoneNumber": @"phoneNumber"
                                                         }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseSessionDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userSessionResponseMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"users"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseSessionDescriptor];
    
    //---------------------------------------------------------------------------------------------------
    
    // setup object mappings
    RKObjectMapping *workoutSummaryMapping = [RKObjectMapping mappingForClass:[WorkoutSummary class]];
    [workoutSummaryMapping addAttributeMappingsFromDictionary:@{
                                                             @"activity": @"activity",
                                                             @"status": @"status",
                                                             @"total_remaining": @"totalRemaining"
                                                             }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseWorkoutSummaryDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:workoutSummaryMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"workouts/:user_id"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseWorkoutSummaryDescriptor];
    
    
    //---------------------------------------------------------------------------------------------------
    
    // setup object mappings
    RKObjectMapping *workoutProgressMapping = [RKObjectMapping mappingForClass:[WorkoutSummary class]];
    [workoutProgressMapping addAttributeMappingsFromDictionary:@{
                                                                @"activity": @"activity",
                                                                @"status": @"status",
                                                                @"total_remaining": @"totalRemaining"
                                                                }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseWorkoutProgressDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:workoutProgressMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"workouts/:user_id/rep"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseWorkoutProgressDescriptor];
}


@end
