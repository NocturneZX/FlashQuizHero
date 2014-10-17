//
//  UniversalAlertView.h
//  FlashQuizHero
//
//  Created by Julio Reyes on 10/17/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UniversalAlertView : NSObject{
    UIAlertView *alertView;
}

+ (id)sharedManager;

-(void) showAlertViewWithTitle:(NSString *)title Message:(NSString*)message;

@end
