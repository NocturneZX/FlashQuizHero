//
//  HerokuAPIRequest.h
//  HerokuAPITest
//
//  Created by Julio Reyes on 10/17/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HerokuDataDownloaderDelegate <NSObject>
    - (void) DataDownloadDidComplete: (NSArray *)resultingdata;
@end

@interface HerokuAPIRequest : NSObject
@property id<HerokuDataDownloaderDelegate>delegate;
    - (void) getQuestionsAndAnswers;
    - (void) getScores;
    - (void) postScore;
@end


