//
//  DrawView.m
//  GenericAl
//
//  Created by Frank Guo on 4/11/15.
//  Copyright © 2015 Frank Guo. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView
int * sequence[100];
int * citynumbers=0;
- (id) initWithFrame:(CGRect) frame data:(NSArray*) datanow flow:(NSArray*) flow city: (int *) city
{
    // inherent from frame
    self = [super initWithFrame:frame];
    if (self)
    {
        self.data = datanow;
        self.flow = flow;
        citynumbers = city;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // draw the CGRect at the center of application
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    // acquire data from ViewController
    CGContextMoveToPoint(context, [[self.data objectAtIndex:[[self.flow objectAtIndex:0] floatValue]*2] floatValue], [[self.data objectAtIndex:[[self.flow objectAtIndex:0] floatValue]*2+1] floatValue]);
    // draw  it
    for (int i=1;i< citynumbers; i++)
    {
         CGContextAddLineToPoint(context, [[self.data objectAtIndex:[[self.flow objectAtIndex:i] floatValue]*2] floatValue], [[self.data objectAtIndex:[[self.flow objectAtIndex:i] floatValue]*2+1] floatValue]);
    }
    //add the last line from the last point to the first one
     CGContextAddLineToPoint(context, [[self.data objectAtIndex:[[self.flow objectAtIndex:0] floatValue]*2] floatValue], [[self.data objectAtIndex:[[self.flow objectAtIndex:0] floatValue]*2+1] floatValue]);
    CGContextStrokePath(context);
}



@end