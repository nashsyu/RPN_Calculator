//
//  CalculatorBrain.m
//  Calculator
//
//  Created by asustor on 12/12/19.
//  Copyright (c) 2012年 asustor. All rights reserved.
//

#import "CalculatorBrain.h"
#import <math.h>

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray * operandStack;

@end


@implementation CalculatorBrain

@synthesize operandStack = _operandStack;


- (NSMutableArray *)operandStack
{
    if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (void) setOperandStack:(NSMutableArray *)operandStack
{
    _operandStack = operandStack;
}

-(void) pushOperand: (NSString *) operand
{
/*
    It's the code that change to NSString class before.
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
*/
    //[self.operandStack addObject:[NSNumber numberWithDouble:operand]];
   [self.operandStack addObject:operand];
}

- (double) popOperand
{
    NSString *operandObject = [self.operandStack lastObject];
    double operandInStack = 0;
    if ( [operandObject isEqualToString:@"PI"] ) {
        operandInStack = M_PI;
    } else if ( [operandObject isEqualToString:@"EXP"] ) {
        operandInStack = M_E;
    } else {
        operandInStack = [ operandObject doubleValue ];
    }
    if (operandObject != nil) [self.operandStack removeLastObject];
    return operandInStack;
    // return [operandObject doubleValue];
}

- (double) performOperation:(NSString *)operation
{
    NSDictionary *operationCase = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:1], @"+",
                                    [NSNumber numberWithInt:2], @"*",
                                    [NSNumber numberWithInt:3], @"-",
                                    [NSNumber numberWithInt:4], @"/",
                                    [NSNumber numberWithInt:5], @"sqrt",
                                    [NSNumber numberWithInt:6], @"sin",
                                    [NSNumber numberWithInt:7], @"cos",
                                    [NSNumber numberWithInt:8], @"log", nil ];
    double result = [self popOperand];
    NSNumber * operationCaseNumber = [operationCase objectForKey:operation];
    switch ( [operationCaseNumber intValue] )
    {
        case 1:
            result = [self popOperand] + result;
            break;
        case 2:
            result = [self popOperand] * result;
            break;
        case 3:
            result = [self popOperand] - result;
            break;
        case 4:
            if ( result == 0 )
            {
                result = 0;
            } else {
                result = [self popOperand] / result;
            }
            break;
        case 5:
            result = sqrt( result );
            break;
        case 6:
            result = sin( result*M_PI/180 );
            break;
        case 7:
            result = cos( result*M_PI/180 );
            break;
        case 8:
            //result = log( result );  // ln(100) = 4.60517 (It is "Natural Logarithms")
            result = log10( result );  // log(100) = 2
            break;
    }
/* 
    Try to use NSDictionary just for practicing
    if ( [operation isEqualToString:@"+"] ) {
        result = [self popOperand] + result;
    }else if ( [@"*" isEqualToString:operation] ) {
        result = [self popOperand] * result;
    }else if ( [@"-" isEqualToString:operation] ) {
        result = [self popOperand] - result;
    }else if ( [@"/" isEqualToString:operation] ) {
        result = [self popOperand] / result;
    }else if ( [@"sqrt" isEqualToString:operation] ) {
        result = sqrt(result);
    }else if ( [@"sin" isEqualToString:operation] ) {
        result = sin(result*M_PI/180);
    }else if ( [@"cos" isEqualToString:operation] ) {
        result = cos(result*M_PI/180);
    }else if ( [@"log" isEqualToString:operation] ) {
        result = log( result );
    }
*/
  // calculate result
  return result;
}

- (void) cleanAll{
  [self.operandStack removeAllObjects];
}

@end
