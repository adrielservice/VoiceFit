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

        viewController.title = @"Report: Line Chart";

    } else if ([segue.identifier isEqualToString:@"barChart"])
    {
        //Add bar chart

        viewController.title = @"Bar Chart";
    } else if ([segue.identifier isEqualToString:@"circleChart"])
    {
        //Add circle chart

        viewController.title = @"Report: Circle Chart";

    } else if ([segue.identifier isEqualToString:@"pieChart"])
    {
        //Add pie chart

        viewController.title = @"Report: Pie Chart";
    } else if ([segue.identifier isEqualToString:@"scatterChart"])
    {
        //Add scatter chart
        
        viewController.title = @"Exercise: Scatter Chart";
    } else if ([segue.identifier isEqualToString:@"steps"])
    {
        //Add scatter chart
        
        viewController.title = @"Exercise: Steps (Pedometer)";
    } else if ([segue.identifier isEqualToString:@"pushups"])
    {
        //Add scatter chart
        
        viewController.title = @"Pushups";
    } else if ([segue.identifier isEqualToString:@"squads"])
    {
        //Add scatter chart
        
        viewController.title = @"Exercise: squads";
    }
    
}

@end
