//
//  DTStepModelController.m
//  Pedometer
//
//  David Beilis

#import "DTStepModelController.h"
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>

@interface DTStepModelController ()

@property (assign) NSInteger stepsToday;

@end

@implementation DTStepModelController
{
   CMPedometer *_pedometer;
   NSInteger _stepsToday;
   NSInteger _stepsAtBeginOfLiveCounting;
   BOOL _isLiveCounting;
   NSOperationQueue *_stepQueue;
}


- (instancetype)init
{
   self = [super init];
   
   if (self)
   {
      _pedometer = [[CMPedometer alloc] init];
      self.stepsToday = -1;
      
      NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
      
      // subscribe to relevant notifications
      [noteCenter addObserver:self selector:@selector(timeChangedSignificantly:) name:UIApplicationSignificantTimeChangeNotification object:nil];
      [noteCenter addObserver:self selector:@selector(willEnterForeground:)
                        name:UIApplicationWillEnterForegroundNotification
                        object:nil];
      [noteCenter addObserver:self selector:@selector(didEnterBackground:)
                        name:UIApplicationDidEnterBackgroundNotification
                        object:nil];
      
      // queue for step count updating
      _stepQueue = [[NSOperationQueue alloc] init];
      _stepQueue.maxConcurrentOperationCount = 1;
      
      // start counting
      [self _updateStepsTodayFromHistoryLive:YES];
   }
   
   return self;
}

- (void)dealloc
{
   // remove notification subscriptions
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// queries the CMStepCounter history from midnight until now
- (void)_updateStepsTodayFromHistoryLive:(BOOL)startLiveCounting
{
   if (![CMPedometer isStepCountingAvailable]) {
      NSLog(@"Step counting not available on this device");
      
      self.stepsToday = -1;
      return;
   }
   
   NSDate *now = [NSDate date];
   
   NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
   NSDateComponents *components = [calendar components:NSCalendarUnitYear
                                   | NSCalendarUnitMonth
                                   | NSCalendarUnitDay
                                     fromDate:now];
   
   NSDate *beginOfDay = [calendar dateFromComponents:components];
   
   
   [_pedometer queryPedometerDataFromDate:beginOfDay
                            toDate:now
                            withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                if (error) {
                                    // note: CMErrorDomain, code 105 means not authorized
                                    NSLog(@"%@", [error localizedDescription]);
                                    self.stepsToday = -1;
                                } else {
                                    NSNumber *numOfSteps = pedometerData.numberOfSteps;
                                    self.stepsToday = numOfSteps.integerValue;
                                      
                                    if (startLiveCounting) {
                                        [self _startLiveCounting];
                                    }
                                }
                            }];
}

- (void)_startLiveCounting
{
   if (_isLiveCounting)
   {
      return;
   }
   
   _isLiveCounting = YES;
   _stepsAtBeginOfLiveCounting = self.stepsToday;
    NSDate *now = [NSDate date];
   [_pedometer startPedometerUpdatesFromDate:now
                                 withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                                   self.stepsToday = _stepsAtBeginOfLiveCounting + pedometerData.numberOfSteps.integerValue;
                                               }];
    
   NSLog(@"Started live step counting");
}

- (void)_stopLiveCounting
{
   if (!_isLiveCounting)
   {
      return;
   }
   
   [_pedometer stopPedometerUpdates];
   _isLiveCounting = NO;
   
   NSLog(@"Stopped live step counting");
}

#pragma mark - Notifications

- (void)timeChangedSignificantly:(NSNotification *)notification
{
   [self _stopLiveCounting];
   
   [self _updateStepsTodayFromHistoryLive:YES];
}

- (void)willEnterForeground:(NSNotification *)notification
{
   [self _updateStepsTodayFromHistoryLive:YES];
}

- (void)didEnterBackground:(NSNotification *)notification
{
   [self _stopLiveCounting];
}

@end
