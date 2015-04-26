//
//  DTStepModelController.h
//  Pedometer
//
//  David Beilis

#import <Foundation/Foundation.h>

// model controller that takes care of interacting with the Core Motion CMStepCounter. Property stepsToday is observable.
@interface DTStepModelController : NSObject

// returns number of steps or -1 if they are not available
@property (readonly) NSInteger stepsToday;

- (BOOL) isStepCountingAvailable;
- (BOOL) isDistanceAvailable;
- (BOOL) isFloorCountingAvailable;

- (void) startPedometerUpdates;
- (void) stopPedometerUpdates;

@end
