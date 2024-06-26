//
//  ViewController.m
//  DistCalApp
//
//  Created by Mert Özcan on 14.05.2024.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface ViewController ()

@property (nonatomic) DGDistanceRequest *req;

@property (weak, nonatomic) IBOutlet UITextField *startLocation;

@property (weak, nonatomic) IBOutlet UITextField *endLocation;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.unitController setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Futura-Bold" size:14.0]} forState:UIControlStateNormal];

}

- (IBAction)calculateButtonTapped:(id)sender {
    self.calculateButton.enabled = NO;
    
    self.req = [DGDistanceRequest alloc];
    NSString *start = self.startLocation.text;
    NSString *end = self.endLocation.text;
    NSArray *dest = @[end];
    
    self.req = [self.req initWithLocationDescriptions:dest sourceDescription:start];
    
    __weak ViewController *weakSelf = self;
    
    self.req.callback = ^void(NSArray *response) {
        ViewController *strongSelf = weakSelf;
        if (!strongSelf) return;
        
        NSNull *badResult = [NSNull null];
        
        if (response[0] != badResult) {
            double num ;
            if (strongSelf.unitController.selectedSegmentIndex == 0) {
                num = ([response[0] floatValue] / 1.0);
                NSString *x = [NSString stringWithFormat:@"%.2f m", num];
                strongSelf.distanceLabel.text = x;
            } else if (strongSelf.unitController.selectedSegmentIndex == 1){
                num = ([response[0] floatValue] / 1000.0);
                NSString *x = [NSString stringWithFormat:@"%.2f km", num];
                strongSelf.distanceLabel.text = x;
            } else {
                num = ([response[0] floatValue] / 1609.34);
                NSString *x = [NSString stringWithFormat:@"%.2f miles", num];
                strongSelf.distanceLabel.text = x;
            }
        } else {
            strongSelf.distanceLabel.text = @"Error!";
        }
        
        strongSelf.req = nil;
        strongSelf.calculateButton.enabled = YES;
    };
    
    [self.req start];
}

@end
