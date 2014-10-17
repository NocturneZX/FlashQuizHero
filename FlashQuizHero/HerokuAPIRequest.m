//
//  HerokuAPIRequest.m
//  HerokuAPITest
//
//  Created by Julio Reyes on 10/17/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "HerokuAPIRequest.h"
#import "FlashCard.h"

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
                
                FlashCard *flashcard = [[FlashCard alloc]init];
                
                NSString *question = [dict valueForKey:@"question"];
                NSString *answer = [dict valueForKey:@"answer"];
                
                // Setup the FlashCard class
                flashcard.questions = question;
                flashcard.answers = answer;
                
                //Add PhotoObject into the array
                [arrayOfQuestionsAndAnswers addObject:flashcard];

                
                NSLog(@"Array: %@", arrayOfQuestionsAndAnswers);

                
                // Send data to the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    // do work here
                    [self.delegate DataDownloadDidComplete:arrayOfQuestionsAndAnswers];
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

-(void)getScores{
    
}

-(void)postScore{
    
}

@end
