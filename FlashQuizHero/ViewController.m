//
//  ViewController.m
//  FlashQuizHero
//
//  Created by Julio Reyes on 10/17/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "ViewController.h"
#import "HerokuAPIRequest.h"
#import "FlashCard.h"

@interface ViewController () <HerokuDataDownloaderDelegate>

@property HerokuAPIRequest *downloader;

@property (nonatomic, strong) NSMutableArray *flashcardsets;

@end

@implementation ViewController
@synthesize flashcardsets = _flashcardsets;

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Welcome to Flash Quiz!";
    
    self.flashcardsets = [[NSMutableArray alloc]init];
    self.downloader = [[HerokuAPIRequest alloc]init];
    self.downloader.delegate = self;
    [self.downloader getQuestionsAndAnswers];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API Methods
-(void)DataDownloadDidComplete:(NSArray *)resultingdata{
    
    if (resultingdata != 0) {
        for (FlashCard *card in resultingdata) {
            [self.flashcardsets addObject:card];
        }
        
    }
    
    NSLog(@"%@", self.flashcardsets);
}
@end
