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
@property (nonatomic) bool userHasBeenInputEnter;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) NSString *inputContent;
@property (nonatomic) NSString *inputContentHistory;
@property (nonatomic) bool isDotInNumber;
@property (nonatomic) int indexInputContent;
@property (nonatomic) bool isOperationPIorEXPPressed;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize userHasBeenInputEnter = _userHasBeenInputEnter;
@synthesize brain = _brain;
@synthesize inputContent = _inputContent;
@synthesize inputContentHistory = _inputContentHistory;
@synthesize isDotInNumber = _isDotInNumber;
@synthesize indexInputContent = _indexInputContent;
@synthesize isOperationPIorEXPPressed =_isOperationPIorEXPPressed;

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

- (void) displayControl {
    // display control
    if ( self.userHasBeenInputEnter == YES ) {
        self.display.text = self.inputContentHistory;
        if ( self.indexInputContent <= 0 ) {
            self.display.text = [self.display.text stringByAppendingString:@" ="];
        }
    } else {
        if ( [self.inputContentHistory isEqualToString: @""] == YES ) {  // User doesn't "Enter" any digit number.
            self.display.text = self.inputContent;
        } else {  // User has been "Enter" some number
            self.display.text = self.inputContentHistory;
            if ( self.indexInputContent > 0 ) {
                // If user doesn't input any number, it doesn't need print inputContent.
                self.display.text = [self.display.text stringByAppendingString :self.inputContent];
            }
        }
    }
}

- (IBAction) digitPressed:(UIButton *)sender {
    // inputContent controll
    if ( self.userHasBeenInputEnter == NO &&
         self.isOperationPIorEXPPressed == YES ){
        [self enterPressed];  // After "PI" input, we need "Enter" again.
        self.isOperationPIorEXPPressed = NO;
    }
    if ( self.userHasBeenInputEnter == YES ) {  // User input digit number after pressing "Enter".
        self.userHasBeenInputEnter = NO;
        self.indexInputContent = 0;  // claer inputContent
    }
    if ( self.indexInputContent <= 0 ) {  // If there is no number in inputContent.
        if ( [sender.currentTitle isEqualToString:@"."] == YES ) {  // There is no number ,and user input "dot".
            self.inputContent = [self.inputContent stringByAppendingString:@"0."];
            self.isDotInNumber = YES;
            self.indexInputContent = 2;
        } else {  // User just input digit number.
            self.inputContent = sender.currentTitle;
            if ( [sender.currentTitle isEqualToString:@"0"] == NO ) {
                // If user input a non-zero number at the first character,then index add 1.
                self.indexInputContent = 1;
            }
        }
    } else {  // There are numbers in inputContent.
        if ( [sender.currentTitle isEqualToString:@"." ] == NO ||
             self.isDotInNumber == NO ) {
            // The number just can have only one "dot".
            // If user input "dot", it should check "isDotInNumber".
            // The condition is the reverse of that ( user input "dot", and the number also has the "dot" ).
            // It means the reverse of ( [sender.currentTitle isEqualToString:@"." ] == YES  && self.isDotInNumber == YES ).
            self.inputContent = [self.inputContent stringByAppendingString:sender.currentTitle];
            if ( [sender.currentTitle isEqualToString:@"."] == YES ) {  // If user input "dot" ,and then set 
                self.isDotInNumber = YES;
            }
            self.indexInputContent = self.indexInputContent + 1;
        }
    }
    [self displayControl];
}

- (IBAction) enterPressed {
    if ( self.indexInputContent > 0 )  // It works when there are number in inputContent
    {
        [self.brain pushOperand:self.inputContent ];  // push Number in stack
        // display control
        if ( [self.inputContentHistory isEqualToString: @""] == YES ) {  // If user "Enter" first time.
            self.inputContentHistory = self.inputContent;
        } else {
            self.inputContentHistory = [self.inputContentHistory stringByAppendingString:self.inputContent];
        }
        self.inputContentHistory = [self.inputContentHistory stringByAppendingString: @" "];
        self.userHasBeenInputEnter = YES;
        [self displayControl];
    }
}

- (IBAction) operationPressed:(UIButton *)sender {
    //NSString * digit = [ NSString stringWithFormat:@" %@ ", sender.currentTitle];
    //self.display.text = [self.display.text stringByAppendingString: digit];
    if ( self.userHasBeenInputEnter == NO ) {  // There are some digit number in inputContent
        [self enterPressed];
    }
    // Perform to calculate
    double result = [self.brain performOperation:sender.currentTitle];
    self.inputContentHistory = [self.inputContentHistory stringByAppendingString:sender.currentTitle];
    self.inputContentHistory = [self.inputContentHistory stringByAppendingString:@" "];
    [self displayControl];
    self.userHasBeenInputEnter = NO;
    self.indexInputContent = 0;
    self.isDotInNumber = NO;
    NSString * resultString = [NSString stringWithFormat:@"%g", result];
    [self.brain pushOperand:resultString];  // Push result to hold number after calculating
    self.displayOutput.text = resultString;
}
- (IBAction) operationPIorEXPPressed:(UIButton *)sender {
    if ( self.userHasBeenInputEnter == NO &&
        self.isOperationPIorEXPPressed == NO ) {  // There is a number, before user enter "PI". It need "Enter".
        [self enterPressed];
    }
    [self digitPressed:sender];  // We need digitPress for input "PI"
    self.isOperationPIorEXPPressed = YES;
}

- (IBAction) cleanPressed {
    [self.brain cleanAll ];  // clear stack
    // self.userIsInTheMiddleOfEnteringANumber = NO;
    self.indexInputContent = 0;
    self.isDotInNumber = NO;
    self.inputContentHistory = @"";
    self.display.text = @"0";
    self.displayOutput.text = @"0";
}

- (IBAction) baqckspacePressed {
    if ( self.indexInputContent > 0 ) {  // User has been input number.
        if ( self.userHasBeenInputEnter == YES ) {
            self.userHasBeenInputEnter = NO;
            self.indexInputContent = 0;
        } else {
            self.indexInputContent = self.indexInputContent - 1;
            self.inputContent = [self.inputContent substringToIndex:self.indexInputContent];  // cut last character
            [self displayControl];
        }
    }
}

- (IBAction) positiveOrNegative {
    if ( self.indexInputContent > 0 )
    {
        NSString *tempString = [self.inputContent substringToIndex:1];
        if ( [tempString isEqualToString:@"-"] == YES ) {
            self.inputContent = [self.inputContent substringFromIndex:1];
        } else {
            self.inputContent = [@"-" stringByAppendingString:self.inputContent];
        }
        [self displayControl];
    }
}
@end
