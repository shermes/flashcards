//
//  Employee.h
//  FlipCards
//
//  Created by Scott Hermes on 10/8/14.
//  Copyright (c) 2014 Solstice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Employee : NSObject
@property (strong, nonatomic) NSString *name;
@property ( strong, nonatomic) NSString *title;
@property BOOL isKnown;
@property (strong, nonatomic) UIImage *photo;
@end
