//
//  CALCRootViewController.m
//  Calc
//
//  Created by Jo Albright on 1/16/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

#import "CALCRootViewController.h"

#import "MOVE.h"

@interface CALCRootViewController ()

typedef enum mathematics {
    NOMATH,
    DIVISION,
    MULTIPLICATION,
    SUBTRACTION,
    ADDITION,
    EQUALS
} mathematics;

@end

@implementation CALCRootViewController
{
    float screen_height;
    float screen_width;
    
    CGSize btn_size;
    
    UIView *display;
    UIFont *display_font;
    UILabel *number_display;
    
    UIView *sidebuttons;
    UIColor *side_color;
    UIView *side_circle;
    
    NSMutableArray *all_side_buttons;
    
    UIView *numberbuttons;
    UIView *number_circle;
    UIFont *number_font;
    UIFont *button_font;
    
    UIFont *decimal_font;
    
    
    mathematics last_math;
    mathematics selected;
    
    double current_value;
    double current_operation_value;
    
    UIButton *tapped;
    UIButton *clear_button;
    UIButton *delete_button;
    
    BOOL decimal_waiting;
    BOOL equals_tapped;
    BOOL typing_number;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        number_font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:36];
        button_font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28];
        display_font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:80];
        decimal_font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:80];
        
        side_color = [UIColor colorWithRed:1.0 green:78/255.0 blue:0.0 alpha:1.0];
        all_side_buttons = [[NSMutableArray alloc] init];
        equals_tapped = NO;
        typing_number = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    screen_height = [UIScreen mainScreen].bounds.size.height;
    screen_width = [UIScreen mainScreen].bounds.size.width;
    
    btn_size = CGSizeMake(screen_width / 4, screen_height / 4 * 3 / 5);
    
    // ***** TOP DISPLAY ***** //
    
    display = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, screen_height / 4)];
    [display setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    
    [self.view addSubview:display];
    
    number_display = [[UILabel alloc] initWithFrame:CGRectMake(15, display.frame.size.height - 100, 290, 100)];
    [number_display setFont:display_font];
    [number_display setAdjustsFontSizeToFitWidth:YES];
    [number_display setTextAlignment:NSTextAlignmentRight];
    [number_display setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    [number_display setText:@"0"];
    
    [self updateDisplayWithText:@"0"];
    
    [display addSubview:number_display];
    
    
    // ***** SIDE BUTTONS ***** //
    
    sidebuttons = [[UIView alloc] initWithFrame:CGRectMake(240, screen_height / 4, 80, screen_height / 4 * 3)];
    [sidebuttons setBackgroundColor:side_color];
    
    [self.view addSubview:sidebuttons];
    
    side_circle = [[UIView alloc] init];
    [side_circle setBackgroundColor:[UIColor whiteColor]];
    [side_circle setClipsToBounds:YES];
    
    NSArray *operations = @[@"÷",@"×",@"−",@"+",@"="];
    
    for (NSString *oper in operations)
    {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:oper forState:UIControlStateNormal];
        [[button titleLabel] setFont:number_font];
        [button setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
        [sidebuttons addSubview:button];
        
        [button setTag:[operations indexOfObject:oper] + 1];
        
        [button addTarget:self action:@selector(setMath:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setFrame:CGRectMake(0, btn_size.height * [operations indexOfObject:oper], btn_size.width, btn_size.height)];
        
        [all_side_buttons addObject:button];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
    }
    
    // ***** NUMBER BUTTONS ***** //
    
    numberbuttons = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height / 4, 240, screen_height / 4 * 3)];
    [numberbuttons setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.05]];
    
    [self.view addSubview:numberbuttons];
    
    NSArray *numbers = @[@7,@8,@9,@4,@5,@6,@1,@2,@3,@0];
    
    int row = 1;
    int col = 1;
    
    for (NSNumber *num in numbers)
    {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:[NSString stringWithFormat:@"%@",num] forState:UIControlStateNormal];
        [[button titleLabel] setFont:number_font];
        [button setTitleColor:[UIColor colorWithWhite:0 alpha:0.8] forState:UIControlStateNormal];
        [numberbuttons addSubview:button];
        
        [button addTarget:self action:@selector(addNumber:) forControlEvents:UIControlEventTouchUpInside];
        
        if([num intValue] == 0)
        {
            [button setFrame:CGRectMake(0, btn_size.height * 4, btn_size.width * 2, btn_size.height)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, btn_size.width)];
            
        } else {
            
            if(col == 4) { col = 1; row++; }
            
            [button setFrame:CGRectMake((col - 1) * btn_size.width, row * btn_size.height, btn_size.width, btn_size.height)];
            
            col++;
        }
    }
    
    // ***** EXTRA BUTTONS ***** //
    
    clear_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn_size.width, btn_size.height)];
    [clear_button setTitle:@"AC" forState:UIControlStateNormal];
    [[clear_button titleLabel] setFont:button_font];
    [clear_button setTitleColor:[UIColor colorWithWhite:0 alpha:0.8] forState:UIControlStateNormal];
    [clear_button addTarget:self action:@selector(clearDisplay:) forControlEvents:UIControlEventTouchUpInside];
    
    [numberbuttons addSubview:clear_button];
    
    
    delete_button = [[UIButton alloc] initWithFrame:CGRectMake(btn_size.width * 1, btn_size.height * 4, btn_size.width, btn_size.height)];
    [delete_button setTitle:@"del" forState:UIControlStateNormal];
    [[delete_button titleLabel] setFont:button_font];
    [delete_button setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
    [delete_button addTarget:self action:@selector(deleteNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    [numberbuttons addSubview:delete_button];
    
    
    UIButton *decimal_button = [[UIButton alloc] initWithFrame:CGRectMake(btn_size.width * 2, btn_size.height * 4, btn_size.width, btn_size.height)];
    [decimal_button setTitle:@"." forState:UIControlStateNormal];
    [[decimal_button titleLabel] setFont:decimal_font];
    [decimal_button setTitleColor:[UIColor colorWithWhite:0 alpha:0.8] forState:UIControlStateNormal];
    [decimal_button addTarget:self action:@selector(addDecimal:) forControlEvents:UIControlEventTouchUpInside];
    [decimal_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 25, 0)];
    
    [numberbuttons addSubview:decimal_button];
    
    
    UIButton *percent_button = [[UIButton alloc] initWithFrame:CGRectMake(btn_size.width * 2, 0, btn_size.width, btn_size.height)];
    [percent_button setTitle:@"%" forState:UIControlStateNormal];
    [[percent_button titleLabel] setFont:button_font];
    [percent_button setTitleColor:[UIColor colorWithWhite:0 alpha:0.8] forState:UIControlStateNormal];
    [percent_button addTarget:self action:@selector(addPercent:) forControlEvents:UIControlEventTouchUpInside];
    
    [numberbuttons addSubview:percent_button];
    
    // signing button
    
    UILabel *plus_sign = [[UILabel alloc] initWithFrame:CGRectMake(btn_size.width * 1, 0, btn_size.width - 20, btn_size.height - 15)];
    [plus_sign setText:@"+"];
    [plus_sign setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22]];
    [plus_sign setTextColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [plus_sign setTextAlignment:NSTextAlignmentCenter];
    
    [numberbuttons addSubview:plus_sign];
    
    UILabel *minus_sign = [[UILabel alloc] initWithFrame:CGRectMake(btn_size.width * 1 + 20, 10, btn_size.width - 20, btn_size.height - 20)];
    [minus_sign setText:@"−"];
    [minus_sign setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22]];
    [minus_sign setTextColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [minus_sign setTextAlignment:NSTextAlignmentCenter];
    
    [numberbuttons addSubview:minus_sign];
    
    UIButton *signing_button = [[UIButton alloc] initWithFrame:CGRectMake(btn_size.width * 1, 0, btn_size.width, btn_size.height)];
    [signing_button setTitle:@"/" forState:UIControlStateNormal];
    [[signing_button titleLabel] setFont:button_font];
    [signing_button setTitleColor:[UIColor colorWithWhite:0 alpha:0.8] forState:UIControlStateNormal];
    [signing_button addTarget:self action:@selector(changeSign:) forControlEvents:UIControlEventTouchUpInside];
    
    [numberbuttons addSubview:signing_button];
}

#pragma mark - Processing

- (void)updateDisplayWithText:(NSString *)text
{
    NSArray *parts = [text componentsSeparatedByString:@"."];
    
    NSMutableAttributedString *part0 = [[NSMutableAttributedString alloc] initWithString:parts[0] attributes:@{NSFontAttributeName:display_font}];
    
    if([parts count] > 1)
    {
        NSMutableAttributedString *decimal = [[NSMutableAttributedString alloc] initWithString:@"." attributes:@{NSFontAttributeName:decimal_font}];
        [part0 appendAttributedString:decimal];
    }
    
    if([parts count] > 1 && ![parts[1] isEqualToString:@""])
    {
        NSMutableAttributedString *part1 = [[NSMutableAttributedString alloc] initWithString:parts[1] attributes:@{NSFontAttributeName:display_font}];
        [part0 appendAttributedString:part1];
    }
    
    [number_display setAttributedText:part0];
}

- (NSString *)doMathWith:(enum mathematics)m
{
    double num;
    
    switch((int)m)
    {
        case 1: // Division
            num = current_value / current_operation_value;
            break;
            
        case 2: // Multiplication
            num = current_value * current_operation_value;
            break;
            
        case 3: // Subtraction
            num = current_value - current_operation_value;
            break;
            
        case 4: // Addition
            num = current_value + current_operation_value;
            break;
    }
    
    NSString *result;
    
    if(num - (int)num == 0)
    {
        result = [NSString stringWithFormat:@"%d",(int)num];
        
    } else {
        
        result = [NSString stringWithFormat:@"%g",num];
    }
    
    return result;
}

- (NSString *)formatCommasWithString:(NSString *)number
{
    BOOL negative = [[number substringToIndex:1] isEqualToString:@"-"];
    
    NSArray *parts = [number componentsSeparatedByString:@"."];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *formatted = [formatter stringFromNumber:@([parts[0] intValue])];
    
    if([parts count] > 1)
    {
        formatted = [formatted stringByAppendingString:@"."];
        formatted = [formatted stringByAppendingString:parts[1]];
    }
    
    if(negative && ![[formatted substringToIndex:1] isEqualToString:@"-"]) formatted = [@"-" stringByAppendingString:formatted];
    
    return formatted;
}

#pragma mark - UIButtonActions

- (void)setMath:(UIButton *)sender
{
    if(!equals_tapped) current_operation_value = [[[number_display text] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
    else current_value = [[[number_display text] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
    
    int op_num = (int)sender.tag;
    
    if(equals_tapped && op_num != 5)
    {
        last_math = selected = NOMATH;
        equals_tapped = NO;
    }
    
    if(last_math != selected)
    {
        NSString *formatted = [self formatCommasWithString:[self doMathWith:last_math]];
        
        [self updateDisplayWithText:formatted];
    }
    
    if(selected != (mathematics)sender.tag)
    {
        if(op_num < 6)
        {
            for(UIButton *button in all_side_buttons) { [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; }
            [side_circle removeFromSuperview];
        }
        
        if(op_num < 5)
        {
            [sender setTitleColor:side_color forState:UIControlStateNormal];
            
            int diameter = btn_size.width - 30;
            int top_extra = btn_size.height - btn_size.width + 30;
            
            int button_y = btn_size.height * (op_num - 1);
            
            [side_circle setFrame:CGRectMake(btn_size.width / 2.0, button_y + (btn_size.height / 2.0), 0, 0)];
            [[side_circle layer] setCornerRadius:diameter / 2.0];
            [side_circle setAlpha:0];
            
            [MOVE animateView:side_circle properties:@{@"x":@15,@"y":@(button_y + (top_extra / 2.0)),@"height":@(diameter),@"width":@(diameter),@"duration":@0.2,@"alpha":@1,@"animation":@((int)UIViewAnimationCurveEaseOut)}];
            
            [sidebuttons insertSubview:side_circle atIndex:0];
            
            last_math = selected = (mathematics)sender.tag;
        }
    }
    
    if(sender.tag == 5)
    {
        selected = NOMATH;
        equals_tapped = YES;
        [self circleAtNumber:sender];
    }
    
    if(sender.tag < 6)
    {
        typing_number = NO;
        [delete_button setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
    }
}

- (void)addNumber:(UIButton *)sender
{
    [self circleAtNumber:sender];
    
    if(equals_tapped)
    {
        last_math = selected = NOMATH;
        equals_tapped = NO;
        
        [number_display setText:@"0"];
    }
    
    if((int)selected > 0)
    {
        current_value = [[[number_display text] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
        
        [number_display setText:@"0"];
        selected = NOMATH;
        
        // hide circle
    }
    
    NSString *nocommas = [[number_display text] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    if([self tooLong]) return;
    
    double num = [nocommas floatValue];
    
    NSString *whole;
    
    if(num - (int)num == 0)
    {
        int value = [nocommas intValue];
        
        whole = [NSString stringWithFormat:@"%d",value];
        
    } else {
        
        double value = [nocommas floatValue];
        
        whole = [NSString stringWithFormat:@"%g",value];
    }
    
    NSString *num_text = [number_display text];
    
    if([[num_text substringFromIndex:num_text.length - 1] isEqualToString:@"."]) whole = [whole stringByAppendingString:@"."];
    
    NSString *formatted = [self formatCommasWithString:[whole stringByAppendingString:[[sender titleLabel] text]]];
    
    [self updateDisplayWithText:formatted];
    
    [clear_button setTitle:@"C" forState:UIControlStateNormal];
    
    typing_number = YES;
    [delete_button setTitleColor:[UIColor colorWithWhite:0 alpha:0.8] forState:UIControlStateNormal];
}

- (void)addDecimal:(UIButton *)sender
{
    [self circleAtNumber:sender];
    
    last_math = selected = NOMATH;
    equals_tapped = NO;
    
    NSString *nocommas = [[number_display text] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    double num = [nocommas floatValue];
    if(num - (int)num != 0) return;
    
    if(num == 0)
    {
        [self updateDisplayWithText:@"0."];
        
    } else {
        
        NSString *formatted = [self formatCommasWithString:[[number_display text] stringByAppendingString:@"."]];
        
        [self updateDisplayWithText:formatted];
    }
    
    [clear_button setTitle:@"C" forState:UIControlStateNormal];
    
    typing_number = YES;
    [delete_button setTitleColor:[UIColor colorWithWhite:0 alpha:0.8] forState:UIControlStateNormal];
}

- (void)addPercent:(UIButton *)sender
{
    [self circleAtNumber:sender];
    
    NSString *nocommas = [[number_display text] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    double percent = [nocommas floatValue] / 100;
    
    NSString *formatted = [self formatCommasWithString:[NSString stringWithFormat:@"%g",percent]];
    
    [self updateDisplayWithText:formatted];
}

- (void)changeSign:(UIButton *)sender
{
    [self circleAtNumber:sender];
    
    NSString *nocommas = [[number_display text] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    double number = [nocommas floatValue] * -1;
    
    NSString *formatted = [self formatCommasWithString:[NSString stringWithFormat:@"%g",number]];
    
    [self updateDisplayWithText:formatted];
}

- (void)clearDisplay:(UIButton *)sender
{
    [self circleAtNumber:sender];
    
    if([[[clear_button titleLabel] text] isEqualToString:@"AC"])
    {
        last_math = selected = NOMATH;
        
        for(UIButton *button in all_side_buttons) { [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; }
        [side_circle removeFromSuperview];
    }
    
    [self updateDisplayWithText:@"0"];
    
    [clear_button setTitle:@"AC" forState:UIControlStateNormal];
}

- (void)deleteNumber:(UIButton *)sender
{
    if(!typing_number) return;
    
    [self circleAtNumber:sender];
    
    NSString *nocommas = [[number_display text] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *nosign = [nocommas stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if(nosign.length > 1 && ![nosign isEqualToString:@"0."])
    {
        NSString *formatted = [self formatCommasWithString:[nosign substringToIndex:nosign.length - 1]];
        
        [self updateDisplayWithText:formatted];
        
    } else {
        
        typing_number = NO;
        [self updateDisplayWithText:@"0"];
        [delete_button setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
    }
}

#pragma mark - Extras

- (BOOL)tooLong
{
    NSString *nocommas = [[number_display text] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *nodecimal = [nocommas stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *nosign = [nodecimal stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if(nosign.length > 8) return YES;
    
    return NO;
}

- (void)circleAtNumber:(UIButton *)sender
{
    number_circle = [[UIView alloc] init];
    [number_circle setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    [number_circle setClipsToBounds:YES];
    
    [[sender superview] insertSubview:number_circle atIndex:0];
    
    int diameter = btn_size.width - 10;
    int top_extra = btn_size.height - btn_size.width + 10;
    
    int button_x = sender.frame.origin.x;
    int button_y = sender.frame.origin.y;
    
    [number_circle setAlpha:1];
    [number_circle setFrame:CGRectMake(button_x + 5, button_y + (top_extra / 2.0), diameter, diameter)];
    [[number_circle layer] setCornerRadius:diameter / 2.0];
    
    [MOVE animateView:number_circle properties:@{@"alpha":@0,@"duration":@0.2,@"animation":@((int)UIViewAnimationCurveEaseOut),@"remove":@YES}];
}

#pragma mark - System

- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
