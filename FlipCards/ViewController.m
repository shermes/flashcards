//
//  ViewController.m
//  FlipCards
//
//  Created by Scott Hermes on 10/7/14.
//  Copyright (c) 2014 Solstice. All rights reserved.
//

#import "ViewController.h"
#import "Employee.h"
#import <Foundation/NSJSONSerialization.h>
#import <UIKit/UIKit.h>

@interface ViewController ()
@property NSMutableArray *employees;
@property Employee *currentEmployee;
@property int totalEmployees;
@property int matchedEmployees;
@end

@implementation ViewController
- (IBAction)clickedRestart:(id)sender {
    for (Employee *e in self.employees) {
        e.isKnown = NO;
    }
    self.matchedEmployees =0;
    [self hideNameAndTitle:NO];
    [self displayNextEmployee];
    [self hideTopButtons: NO];
}
- (IBAction)nailedItClicked:(id)sender {
    [self nextEmployee:YES];
}
- (IBAction)missedItClick:(id)sender {
    [self nextEmployee:NO];
}
- (IBAction)nameClicked:(id)sender {
    [sender setTitle:self.currentEmployee.name forState:UIControlStateNormal];
}
- (IBAction)titleClicked:(id)sender {
    [sender setTitle:self.currentEmployee.title forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // in the real world, to a get from a REST service, for now load from an JSON file
    [self getEmployeeData];
    self.totalEmployees = (int)self.employees.count;
    self.matchedEmployees = 0;
    [self displayNextEmployee];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Employee Methods
- (void)youWin {
    [self.nameButton setTitle:@"YOU WIN!!!" forState:UIControlStateNormal];
    [self.titleButton setTitle:@"WELL DONE!!!" forState:UIControlStateNormal];
    [self hideTopButtons:YES];
    [self hideNameAndTitle:YES];
    self.backgroundView.image = [UIImage imageNamed:@"youwin"];
}
-(void) hideTopButtons:(BOOL) visibility {
    [self.successButton setHidden:visibility];
    [self.failButton setHidden:visibility];

}
-(void) hideNameAndTitle:(BOOL) visibility {
    [self.nameButton setHidden:visibility];
    [self.titleButton setHidden:visibility];
}

-(void) nextEmployee:(BOOL)identifiedEmployee{
    self.currentEmployee.isKnown = identifiedEmployee;
    self.matchedEmployees += (identifiedEmployee ? 1 : 0);
    if (self.matchedEmployees >= self.totalEmployees) {
        [self youWin];
    }
    else {
        [self displayNextEmployee];
    }
}
-(Employee *) getUnknownEmployee {
    int nextEmployee = (int)arc4random_uniform((self.totalEmployees - self.matchedEmployees));
    Employee *nextUnknowEmployee;
    if (self.matchedEmployees > 0) {
        int countOfUnknownEmployees =0;
        for (Employee *e in self.employees) {
            if (!e.isKnown ) {
                if (countOfUnknownEmployees == nextEmployee) {
                    nextUnknowEmployee = e;
                    break;
                }
                else {
                    countOfUnknownEmployees++;
                }
            }
        }
    }
    else{
        nextUnknowEmployee = self.employees[nextEmployee];
    }
    return nextUnknowEmployee;
}
-(void) displayNextEmployee{
    self.currentEmployee = [self getUnknownEmployee];
    if (self.currentEmployee) {
        self.nameButton.alpha = 0;
        self.titleButton.alpha = 0;
        self.backgroundView.alpha = 0;
        [self hideNameAndTitle:NO];
        [UIView animateWithDuration:1.0 animations:^{
            self.nameButton.alpha = 0.75;
            self.titleButton.alpha = 0.75;
            self.backgroundView.alpha = 1.0;
        }];
        NSLog(@"Employee %@",self.currentEmployee.name);
        self.backgroundView.image = self.currentEmployee.photo;
        [self.nameButton setTitle:@"Name?" forState:UIControlStateNormal];
        [self.titleButton setTitle:@"Title?" forState:UIControlStateNormal];
    }
    else{
        [self youWin];
    }
}
- (void) getEmployeeData{
    NSError* error;
    NSString *employeeJSONPath = [[NSBundle mainBundle] pathForResource:@"employees" ofType:@"json"];
    NSString *employeeJSON = [NSString stringWithContentsOfFile:employeeJSONPath encoding:NSUTF8StringEncoding error:NULL];
    NSData *data = [employeeJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *rawEmployees = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (! error) {
        self.employees = [[NSMutableArray alloc] init];
        
        for (NSDictionary *employee in [rawEmployees objectForKey:@"employees"]) {
            NSLog(@"%@",[employee objectForKey:@"name"]);
            Employee *e = [[Employee alloc]init];
            e.name = [employee objectForKey:@"name"];
            e.title = [employee objectForKey:@"title"];
            NSString *photo = [employee objectForKey:@"photo"];
//            NSString *path = [[NSBundle mainBundle] pathForResource:photo ofType:@"jpg"];
            e.photo = [UIImage imageNamed:photo];
            [self.employees addObject:e];
            
        }
    }
}


@end
