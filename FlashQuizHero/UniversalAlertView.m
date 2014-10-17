//
//  UniversalAlertView.m
//  FlashQuizHero
//
//  Created by Julio Reyes on 10/17/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "UniversalAlertView.h"

@implementation UniversalAlertView

+ (id)sharedManager {
    static UniversalAlertView *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString*)message{
    
    alertView = [[UIAlertView alloc] initWithTitle:title
                                           message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    
}

@end
