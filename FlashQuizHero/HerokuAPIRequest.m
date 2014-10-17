//
//  HerokuAPIRequest.m
//  HerokuAPITest
//
//  Created by Julio Reyes on 10/17/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "HerokuAPIRequest.h"
#import "FlashCard.h"
#import "UniversalAlertView.h"

@implementation HerokuAPIRequest

-(id)init{
    if (self) {
        
    }
    return self;
}

-(void)getQuestionsAndAnswers{
    
    NSMutableArray *arrayOfQuestionsAndAnswers = [[NSMutableArray alloc] init];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://flashquiz-api.herokuapp.com/flash_cards"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:100];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(!error)
        {
            @try {
                __autoreleasing NSError *parsingError = [[NSError alloc] init];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parsingError];
                NSLog(@"NSJSONSerialization Dict: %@", dict);
                if (dict || [dict count] > 0) {
                    for (NSDictionary *eachCard in dict) {
                        FlashCard *flashcard = [[FlashCard alloc]init];
                        
                        NSString *question = [eachCard valueForKey:@"question"];
                        NSString *answer = [eachCard valueForKey:@"answer"];
                        
                        // Setup the FlashCard class
                        flashcard.questions = question;
                        flashcard.answers = answer;
                        
                        //Add PhotoObject into the array
                        [arrayOfQuestionsAndAnswers addObject:flashcard];
                    }
                    
                    // Send data to the main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // do work here
                        [self.delegate DataDownloadDidComplete:arrayOfQuestionsAndAnswers];
                    });
                }else{
                    [[UniversalAlertView sharedManager]showAlertViewWithTitle:@"WHOOPS!" Message:@"Well, isn't that nice? It seems our servers are funky today. No questions for today. We're sorry."];
                    
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"Exception: %@", [exception description]);
            }
            @finally {
                // Nada
            }
        }
        else{
            NSLog(@"Response Error: %@", [error description]);
        }
    }];
}

-(void)getScores{
    NSMutableArray *arrayOfScores = [[NSMutableArray alloc] init];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://flashquiz-api.herokuapp.com/scores"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:100];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(!error)
        {
            @try {
                __autoreleasing NSError *parsingError = [[NSError alloc] init];
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parsingError];
                NSLog(@"NSJSONSerialization Dict: %@", dict);
                
                NSString *score = [dict valueForKey:@"value"];
                [arrayOfScores addObject:score];
                
                // Send data to the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    // do work here
                    [self.delegate DataDownloadDidComplete:arrayOfScores];
                });
                
            }
            @catch (NSException *exception) {
                NSLog(@"Exception: %@", [exception description]);
            }
            @finally {
                // Nada
            }
        }
        else{
            NSLog(@"Response Error: %@", [error description]);
        }
    }];
}

-(void)postScore:(float)finalScore{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://flashquiz-api.herokuapp.com/scores"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:100];
    [request setHTTPMethod:@"POST"];
    
    NSData *data = [[NSString stringWithFormat:@"%f", finalScore] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(!error)
        {
            @try {
                NSLog(@"Done!");
            }
            @catch (NSException *exception) {
                NSLog(@"Exception: %@", [exception description]);
            }
            @finally {
                // Nada
            }
        }
        else{
            NSLog(@"Response Error: %@", [error description]);
        }
    }];
}

@end
