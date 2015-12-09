//
//  DrawView.h
//  GenericAl
//
//  Created by Frank Guo on 4/11/15.
//  Copyright © 2015 Frank Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DrawView : UIView
@property (strong,nonatomic) NSArray *data;
@property (strong,nonatomic) NSArray *flow;

- (id) initWithFrame:(CGRect) frame data:(NSArray*) datanow flow:(NSArray*) flow city: (int *) city;
@end