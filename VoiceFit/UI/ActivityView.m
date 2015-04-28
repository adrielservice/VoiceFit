//
//  ActivityView.m
//  VoiceFit
//
//  Created by David Beilis on 4/27/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import "ActivityView.h"
#import "VoiceFitAPIMgr.h"

@interface ActivityView ()

@end

@implementation ActivityView

- (void)viewDidLoad {
    [super viewDidLoad];
    VoiceFitAPIMgr *mgr = [VoiceFitAPIMgr sharedManager];
    [mgr getWorkoutSummary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handlers

- (IBAction)updateActityStatus:(id)sender {
    VoiceFitAPIMgr *mgr = [VoiceFitAPIMgr sharedManager];
    [mgr updateWorkoutProgress];
}

#pragma mark - callbacks

- (void) update {
    VoiceFitAPIMgr *mgr = [VoiceFitAPIMgr sharedManager];
    
    NSString* status = mgr.userSession.workoutSummary.status;
    
    // is workout completed?
    if (status && [status caseInsensitiveCompare:@"completed"]) {
        // navigate to stats
        self.status.text = @"COMPLETE";
        self.counter.text = @"00";
    } else {
        self.status.text = mgr.userSession.workoutSummary.activity;
        self.counter.text = [[NSString alloc] initWithFormat:@"%d" arguments:mgr.userSession.workoutSummary.totalRemaining];
    }

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
