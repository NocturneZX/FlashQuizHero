//
//  ResultsViewController.m
//  FlashQuizHero
//
//  Created by Julio Reyes on 10/17/14.
//  Copyright (c) 2014 Julio Reyes. All rights reserved.
//

#import "ResultsViewController.h"
#import "HerokuAPIRequest.h"
@interface ResultsViewController () <HerokuDataDownloaderDelegate>

@property (nonatomic, assign) float finalscore;

@property (nonatomic, strong) NSMutableArray *scoreSets;

@property HerokuAPIRequest *downloader;

@property (nonatomic, weak) IBOutlet UILabel *finalScoreLabel;

@end

@implementation ResultsViewController
@synthesize finalScoreLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scoreSets = [[NSMutableArray alloc]init];
    self.downloader = [HerokuAPIRequest new];
    self.downloader.delegate = self;
    [self.downloader getScores];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadScore:(float) score{
    self.finalscore = score;
    self.finalScoreLabel.text = [NSString stringWithFormat:@"Your final score is: %.02f", score];
}

#pragma mark - API Methods
-(void)DataDownloadDidComplete:(NSArray *)resultingdata{
    for (NSString *score in resultingdata) {
        [self.scoreSets addObject:score];
    }
    
    NSLog(@"Scores: %@", self.scoreSets);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
