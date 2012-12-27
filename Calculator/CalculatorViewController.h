//
//  CalculatorViewController.h
//  Calculator
//
//  Created by asustor on 12/12/18.
//  Copyright (c) 2012年 asustor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CalculatorBrain.h"

@interface CalculatorViewController : UIViewController
/*
{
    IBOutlet UILabel *display;  // outlet
    CalculatorBrain *brain;
}

- (IBAction)digiPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
*/

@property (weak, nonatomic) IBOutlet UILabel *display;

@property (weak, nonatomic) IBOutlet UILabel *displayOutput;
@end
