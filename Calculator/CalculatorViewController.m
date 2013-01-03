//
//  CalculatorViewController.m
//  Calculator
//
//  Created by asustor on 12/12/18.
//  Copyright (c) 2012年 asustor. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()

@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) NSString *inputContent;
@property (nonatomic) NSString *inputContentHistory;
// @property (nonatomic) bool userHasBeenInputEnter;
// @property (nonatomic) bool isDotInNumber;
// @property (nonatomic) int indexInputContent;
// @property (nonatomic) bool isOperationPIorEXPPressed;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize brain = _brain;
@synthesize inputContent = _inputContent;
@synthesize inputContentHistory = _inputContentHistory;
// @synthesize userHasBeenInputEnter = _userHasBeenInputEnter;
// @synthesize isDotInNumber = _isDotInNumber;
// @synthesize indexInputContent = _indexInputContent;
// @synthesize isOperationPIorEXPPressed =_isOperationPIorEXPPressed;

- (CalculatorBrain *) brain
{
  if (!_brain) _brain = [[CalculatorBrain alloc] init];
  return _brain;
}

/* Original code
- (IBAction)digitPressed:(UIButton *)sender
{
  NSString *digit = [sender currentTitle];
  UILabel *myDisplay = self.display; // [self display];
  NSString *currentText = myDisplay.text; // [myDisplay text];
  NSString *newText = [currentText stringByAppendingString:digit];
  myDisplay.text = newText; // [myDisplay seText:newText];
}
*/

/* the second changed code
- (IBAction)digitPressed:(UIButton *)sender
{
  NSString *digit = [sender currentTitle];
  NSString *currentText = self.display.text; // [myDisplay text];
  NSString *newText = [currentText stringByAppendingString:digit];
  self.display.text = newText; // [myDisplay seText:newText];
}
*/

/* the third changed code
 - (IBAction)digitPressed:(UIButton *)sender
 {
 NSString *digit = [sender currentTitle];
 self.display.text = [self.display.text stringByAppendingString:digit]; // [myDisplay seText:newText];
 }
 */

- (NSString *) inputContent {
    if ( _inputContent == nil ) {
        _inputContent = [[NSString alloc] init];
    }
    return _inputContent;
}

- (NSString *) inputContentHistory {
    if ( _inputContentHistory == nil ) {
        _inputContentHistory = [[NSString alloc] init];
    }
    return _inputContentHistory;
}

- (IBAction) digitPressed:(UIButton *)sender {
    // inputContent controll
    if ( [self.inputContentHistory length] > 0 ) {
        NSRange inputEnterRange = NSMakeRange( [self.inputContentHistory length]-1, 1 );
        if ( [self.inputContentHistory rangeOfString:@" " options:NSBackwardsSearch range:inputEnterRange].length == 0 ) {
            if ([self.inputContent isEqualToString:@"PI"] == YES ||
                [self.inputContent isEqualToString:@"PI"] == YES ) {
                [self enterPressed];  // After "PI" input, we need "Enter" again.
            }
        }
        if ( [self.inputContentHistory rangeOfString:@" " options:NSBackwardsSearch range:inputEnterRange].length == 1 ) {
            self.inputContent = @"";
        }
    }
    if ( [self.inputContent length] == 0 ) {  // If there is no number in inputContent.
        if ( [sender.currentTitle isEqualToString:@"."] == YES ) {  // There is no number ,and user input "dot".
            self.inputContentHistory = [self.inputContentHistory stringByAppendingString:@"0."];
            self.inputContent = [self.inputContent stringByAppendingString:@"0."];
        } else {  // User just input digit number.
            self.inputContentHistory = [self.inputContentHistory stringByAppendingString:sender.currentTitle];
            self.inputContent = sender.currentTitle;
        }
    } else {  // There are numbers in inputContent.
        if ( [sender.currentTitle isEqualToString:@"." ] == NO ||
             [self.inputContent rangeOfString:@"."].length == 0 ) {
            // The number just can have only one "dot".
            // If user input "dot", it should check "isDotInNumber".
            // The condition is the reverse of that ( user input "dot", and the number also has the "dot" ).
            // It means the reverse of ( [sender.currentTitle isEqualToString:@"." ] == YES  && self.isDotInNumber == YES ).
            self.inputContentHistory = [self.inputContentHistory stringByAppendingString:sender.currentTitle];
            self.inputContent = [self.inputContent stringByAppendingString:sender.currentTitle];
        }
    }
    self.display.text = self.inputContentHistory;
}

- (IBAction) enterPressed {
    if ( [self.inputContent length] > 0 ) {
        [self.brain pushOperand:self.inputContent ];  // push Number in stack
        // display control
        NSRange inputEnterRange = NSMakeRange( [self.inputContentHistory length]-1, 1 );
        if ( [self.inputContentHistory rangeOfString:@" " options:NSBackwardsSearch range:inputEnterRange].length == 0 ) {
            self.inputContentHistory = [self.inputContentHistory stringByAppendingString: @" "];
        } else {
            self.inputContentHistory = [self.inputContentHistory stringByAppendingString:self.inputContent];
            self.inputContentHistory = [self.inputContentHistory stringByAppendingString: @" "];
        }
        self.display.text = self.inputContentHistory;
    }
}

- (IBAction) operationPressed:(UIButton *)sender {
    if ( [self.inputContentHistory length] > 0 ) {  // There are some digit number in inputContent
        NSRange inputEnterRange = NSMakeRange( [self.inputContentHistory length]-1, 1 );
        if ( [self.inputContentHistory rangeOfString:@" " options:NSBackwardsSearch range:inputEnterRange].length == 0 ) {
            [self enterPressed];
        }
    }
    // Perform to calculate
    double result = [self.brain performOperation:sender.currentTitle];
    self.inputContentHistory = [self.inputContentHistory stringByAppendingString:sender.currentTitle];
    self.inputContentHistory = [self.inputContentHistory stringByAppendingString:@" "];
    // [self displayControl];
    self.display.text = self.inputContentHistory;
    self.display.text = [self.display.text stringByAppendingString:@"="];
    self.inputContent = @"";
    NSString * resultString = [NSString stringWithFormat:@"%g", result];
    [self.brain pushOperand:resultString];  // Push result to hold number after calculating
    self.displayOutput.text = resultString;
}

- (IBAction) operationPIorEXPPressed:(UIButton *)sender {
    if ( [self.inputContentHistory length] > 0 ) {  // There are some digit number in inputContent
        NSRange inputEnterRange = NSMakeRange( [self.inputContentHistory length]-1, 1 );
        if ( [self.inputContentHistory rangeOfString:@" " options:NSBackwardsSearch range:inputEnterRange].length == 0 ) {
            [self enterPressed];
        }
    }
    [self digitPressed:sender];  // We need digitPress for input "PI"
}

- (IBAction) cleanPressed {
    [self.brain cleanAll ];  // clear stack
    // self.userIsInTheMiddleOfEnteringANumber = NO;
    self.inputContent = @"";
    self.inputContentHistory = @"";
    self.display.text = @"0";
    self.displayOutput.text = @"0";
}

- (IBAction) baqckspacePressed {
    if ( [self.inputContentHistory length] > 0 ) {  // There are some digit number in inputContent
        NSRange inputEnterRange = NSMakeRange( [self.inputContentHistory length]-1, 1 );
        if ( [self.inputContentHistory rangeOfString:@" " options:NSBackwardsSearch range:inputEnterRange].length == 1 ) {
            self.inputContent = @"";
        } else {
            self.inputContentHistory = [self.inputContentHistory substringToIndex:[self.inputContentHistory length]-1];
            self.inputContent = [self.inputContent substringToIndex:[self.inputContent length]-1];
            if ( [self.inputContentHistory length] == 1 &&
                [self.inputContentHistory isEqualToString:@"-"] == YES ) {
                self.inputContentHistory = @"";
                self.inputContent = @"";
            }
            // [self displayControl];
            if ( [self.inputContentHistory length] == 0 )
            {
                self.display.text = @"0";
            } else {
                self.display.text = self.inputContentHistory;
            }
        }
    }
}

- (IBAction) positiveOrNegative {
    if ( [self.inputContent length] > 0 )
    {
        self.inputContentHistory = [self.inputContentHistory substringToIndex:[self.inputContentHistory length]-[self.inputContent length]];
        if ( [self.inputContent rangeOfString:@"-" options:NSLiteralSearch range:NSMakeRange( 0, 1 )].length == 1 ) {
            self.inputContent = [self.inputContent substringFromIndex:1];
        } else {
            self.inputContent = [@"-" stringByAppendingString:self.inputContent];
        }
        self.inputContentHistory = [self.inputContentHistory stringByAppendingString:self.inputContent];
        //[self displayControl];
        self.display.text = self.inputContentHistory;
    }
}
@end
