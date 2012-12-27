//
//  CalculatorBrain.h
//  Calculator
//
//  Created by asustor on 12/12/19.
//  Copyright (c) 2012年 asustor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand: (NSString *) operand;
- (double)performOperation:(NSString *) operation;
- (void) cleanAll;

/*
@property (readonly) id program;
+ (double)runProgram: (id)program;
+ (NSString *) descriptionOfProgram: (id)program;
*/

@end
