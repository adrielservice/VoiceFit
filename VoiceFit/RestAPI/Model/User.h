//
//  User.h
//  VoiceFit
//
//  Created by David Beilis on 4/27/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface User : NSObject

@property (nonatomic, strong) NSString  *firstName;
@property (nonatomic, retain) NSString  *lastName;
@property (nonatomic, retain) NSString  *phoneNumber;
@property (nonatomic, retain) NSString  *userId;

@end
