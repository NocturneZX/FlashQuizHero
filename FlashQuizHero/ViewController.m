//
//  ViewController.m
//  FlashQuizHero
//
//  Created by Julio Reyes on 10/17/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "ViewController.h"
#import "ResultsViewController.h"

#import "HerokuAPIRequest.h"
#import "FlashCard.h"
#import "UniversalAlertView.h"

@interface ViewController () <HerokuDataDownloaderDelegate>

@property HerokuAPIRequest *downloader;

@property (nonatomic, strong) NSMutableArray *flashcardsets;

@property (nonatomic, assign) int currentindex;
@property (nonatomic, assign) int attempts;
@property (nonatomic, assign) float currentscore;

@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentQuestionLabel;
@property (nonatomic, weak) IBOutlet UITextField *answerTextField;
@property (nonatomic, weak) IBOutlet UIButton *answerButton;

@end

@implementation ViewController

@synthesize flashcardsets = _flashcardsets;
@synthesize timeLabel;
@synthesize currentQuestionLabel;
@synthesize answerTextField;
@synthesize answerButton;

// Globals
int timeTick = 0;
NSTimer *timer;

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Welcome to Flash Quiz!";
    
    self.currentindex = 0;
    self.attempts = 1;
    
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
        
        if (self.flashcardsets.count > 0) {
            NSInteger numberOfQuestions = [self.flashcardsets count];
            
            // Set current score
            self.currentscore = 100 / numberOfQuestions;
            
            [self SetUpQuestion];
        }

    }
    
}

#pragma mark - Quiz Methods
-(void)SetUpQuestion{
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [timer fire];
    
    if (self.currentindex < self.flashcardsets.count) {
        FlashCard *currentFlashCard = [self.flashcardsets objectAtIndex:self.currentindex];
        NSString *currentquestion = currentFlashCard.questions;
        
        int questionnumber = self.currentindex + 1;
        
        self.currentQuestionLabel.text = [NSString stringWithFormat:@"Question #%d: %@"
                                          , questionnumber, currentquestion];
    }
    else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ResultsViewController *result = [storyboard instantiateViewControllerWithIdentifier:@"ResultsViewController"];
        [result loadScore:self.currentscore];
        [self.navigationController pushViewController:result animated:YES];
    }
    
}
-(IBAction)SubmitAnswerPressed:(id)sender{
    [self answerCheck];
}
-(void)answerCheck{
    FlashCard *currentFlashCard = [self.flashcardsets objectAtIndex:self.currentindex];
    NSString *currentanswer = currentFlashCard.answers;
    
    if (![self.answerTextField.text isEqualToString:currentanswer]) {
        
        // Check how many attempts are made. If a wrong answer is given, increment the number of attempts made. If more than three, go to next question.
        switch (self.attempts) {
            case 1:
                self.attempts++;
                [[UniversalAlertView sharedManager]showAlertViewWithTitle:@"STRIKE 1!" Message:@"That was the wrong answer. Try again."];
                break;
            case 2:
                self.attempts++;
                [[UniversalAlertView sharedManager]showAlertViewWithTitle:@"STRIKE 2!" Message:@"This is your final chance. Remember. No Pressure."];
                break;
            case 3:
                [self MoveOnToNextQuestion];
                break;
        }
    }else{
        
        // Handle scoring
        switch (self.attempts) {
            case 1:
                self.currentscore = self.currentscore * 1;
                break;
            case 2:
                self.currentscore = self.currentscore * 0.75;
                break;
            case 3:
                self.currentscore = self.currentscore * 0.5;
                break;
            default:
                break;
        }
        
        self.scoreLabel.text = [NSString stringWithFormat:@"%.02f", self.currentscore];
        
        [self MoveOnToNextQuestion];
    }
}

-(void)MoveOnToNextQuestion{
    self.currentindex++;
    self.attempts = 1;
    self.answerTextField.text = @"";
    self.timeLabel.text = @"0";
    [self SetUpQuestion];
}
-(void)tick{
    timeTick++;
    NSString *timeStr = [[NSString alloc]initWithFormat:@"%d", timeTick];
    if ([timeStr integerValue] > 10) {
        self.timeLabel.textColor = [UIColor blueColor];
    }else if ([timeStr integerValue] > 20){
        self.timeLabel.textColor = [UIColor yellowColor];
    }
    else if ([timeStr integerValue] > 30){
        self.timeLabel.textColor = [UIColor redColor];
    }
    
    self.timeLabel.text =timeStr;
    
}
@end
