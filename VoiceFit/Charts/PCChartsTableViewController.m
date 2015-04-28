//
//  PCChartsTableViewController.m
//  VoiceFit
//
//  Created by David Beilis on 4/26/15.
//  Copyright (c) 2015 Genesys. All rights reserved.
//

#import "PCChartsTableViewController.h"

@implementation PCChartsTableViewController

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    UIViewController * viewController = [segue destinationViewController];

    if ([segue.identifier isEqualToString:@"lineChart"]) {

        //Add line chart

        viewController.title = @"Line Chart";

    } else if ([segue.identifier isEqualToString:@"barChart"])
    {
        //Add bar chart

        viewController.title = @"Bar Chart";
    } else if ([segue.identifier isEqualToString:@"circleChart"])
    {
        //Add circle chart

        viewController.title = @"Circle Chart";

    } else if ([segue.identifier isEqualToString:@"pieChart"])
    {
        //Add pie chart

        viewController.title = @"Pie Chart";
    } else if ([segue.identifier isEqualToString:@"scatterChart"])
    {
        //Add scatter chart
        
        viewController.title = @"Scatter Chart";
    } else if ([segue.identifier isEqualToString:@"steps"])
    {
        
        viewController.title = @"Steps (Pedometer)";
    } else if ([segue.identifier isEqualToString:@"pushups"])
    {
        
        viewController.title = @"Pushups";
    } else if ([segue.identifier isEqualToString:@"squats"])
    {
        
        viewController.title = @"Squats";
    }
    
}

@end
