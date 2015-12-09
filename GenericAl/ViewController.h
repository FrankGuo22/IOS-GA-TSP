//
//  ViewController.h
//  GenericAl
//
//  Created by Frank Guo on 4/11/15.
//  Copyright © 2015 Frank Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrawView;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *Cross;

@property (weak, nonatomic) IBOutlet UITextField *Mutat;

@property (weak, nonatomic) IBOutlet UITextField *Popula;

@property (weak, nonatomic) IBOutlet DrawView *drawview;

@property (weak, nonatomic) IBOutlet UILabel *BestSolution;

@property (weak, nonatomic) IBOutlet UITextField *City;

@property (weak, nonatomic) IBOutlet UILabel *GeneNumber;

@property (weak, nonatomic) IBOutlet UIButton *NextButton;

@property (weak, nonatomic) IBOutlet UIButton *FastButton;

@property (strong, nonatomic) NSArray *array;

@property (weak, nonatomic) IBOutlet UITextField *Random;

@property (weak, nonatomic) IBOutlet UIButton *End;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end

