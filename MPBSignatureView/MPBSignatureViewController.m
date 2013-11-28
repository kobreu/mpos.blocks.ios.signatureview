//
//  MPBSignatureViewController7.m
//  mpos.ios.blocks.signatureview
//
//  Created by Thomas Pischke on 24.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import "MPBSignatureViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface MPBSignatureViewController ()

@property CGRect signatureFrame;

// UI Components
@property (nonatomic, strong) UILabel* merchantNameLabel;
@property (nonatomic, strong) UILabel* amountTextLabel;
@property (nonatomic, strong) UILabel* signatureTextLabel;
@property (nonatomic, strong) UIView* signatureLineView;
@property (nonatomic, strong) UIButton* payButton;
@property (nonatomic, strong) UIButton* cancelButton;
@property (nonatomic, strong) UIView* topBackground;
@property (nonatomic, strong) UIView* bottomBackground;

@property (nonatomic, strong) UIColor* colorGrey;
@property (nonatomic, strong) UIColor* colorBackground;


// Callback Blocks
@property (nonatomic, copy) void (^payCallback)(void);
@property (nonatomic, copy) void (^cancelCallback)(void);

@property CGRect bounds;

@end

@implementation MPBSignatureViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.merchantName = @"Merchant";
        self.amountText = @"1.00 €";
        self.signatureText = @"Signature";
        self.signatureColor = [UIColor blueColor];
        
        self.payButtonText = @"Pay";
        self.cancelButtonText = @"Cancel";
        self.buttonColor = [UIColor colorWithRed:21.0f/255.0f green:126.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
        self.colorGrey = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:147.0f/255.0f alpha:1.0];
        self.colorBackground = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        //if (self.view.frame.size.width > self.view.frame.size.height) {
            // landscape
        //} else {
            // portrait
            NSLog(@"created in portrait mode");
            NSLog(@"%@", NSStringFromCGRect(self.view.frame));
            NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
            NSLog(@"%@", NSStringFromCGRect([[UIScreen mainScreen] bounds]));
            self.bounds = [[UIScreen mainScreen]bounds];
            // ignore navbar
            self.bounds = CGRectMake(0, 0, self.bounds.size.width-20, self.bounds.size.height);
            self.signatureFrame = CGRectMake(0, 44, self.bounds.size.height, self.bounds.size.width-88);
        //}
        
        [self setupSignatureFieldWithFrame:self.signatureFrame];

    }
    return self;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)registerOnPay:(void (^)(void))payBlock onCancel:(void (^)(void))cancelBlock {
    self.payCallback = payBlock;
    self.cancelCallback = cancelBlock;
}

- (void)setupSignatureFieldComponents
{
    
    // Merchant Name
    self.merchantNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.bounds.size.height/2-10, 34)];
    self.merchantNameLabel.backgroundColor = [UIColor clearColor];
    [self.merchantNameLabel setText:self.merchantName];
    self.amountTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.merchantNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32]];
    
    // Amount Text
    self.amountTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.height/2, 5, self.bounds.size.height/2-10, 34)];
    self.amountTextLabel.backgroundColor = [UIColor clearColor];
    [self.amountTextLabel setText:self.amountText];
    self.amountTextLabel.textAlignment = NSTextAlignmentRight;
    [self.amountTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32]];
    
    // Signature Text
    self.signatureTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.width-88, self.bounds.size.height, 44)];
    [self.signatureTextLabel setText:self.signatureText];
    [self.signatureTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    self.signatureTextLabel.textColor = self.colorGrey;
    self.signatureTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.signatureTextLabel.numberOfLines = 0;
    [self.signatureTextLabel sizeToFit];
    self.signatureTextLabel.frame = CGRectMake(0, self.bounds.size.width-44-10-self.signatureTextLabel.frame.size.height, self.bounds.size.height, self.signatureTextLabel.frame.size.height);
    self.signatureTextLabel.textAlignment = NSTextAlignmentCenter;
    self.signatureTextLabel.backgroundColor = [UIColor clearColor];
    
    self.signatureLineView = [[UIView alloc] initWithFrame:CGRectMake(0.382*self.bounds.size.height, self.bounds.size.width-44, 0.5f, 46)];
    self.signatureLineView.backgroundColor = self.colorGrey;
    
    // pay button
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.frame = CGRectMake(0.382*self.bounds.size.height, self.bounds.size.width-44, 0.618*self.bounds.size.height, 44);
    [self.payButton setTitle:self.payButtonText forState:UIControlStateNormal];
    [[self.payButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.payButton addTarget:self
                       action:@selector(btnPay)
             forControlEvents:UIControlEventTouchUpInside];
    [self.payButton setTitleColor:self.buttonColor forState:UIControlStateNormal];
    //[self.payButton setBackgroundImage:imageGreenNormal forState:UIControlStateNormal];
    //[self.payButton setBackgroundImage:imageGreenHighlight forState:UIControlStateHighlighted];
    [self.payButton setBackgroundColor:[UIColor clearColor]];
    //[self.payButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f)];
    
    // cancel button
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(0, self.bounds.size.width-44, 0.382*self.bounds.size.height, 44);
    [self.cancelButton setTitle:self.cancelButtonText forState:UIControlStateNormal];
    [[self.cancelButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.cancelButton addTarget:self
                          action:@selector(btnCancel)
                forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitleColor:self.buttonColor forState:UIControlStateNormal];
    //[self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f)];
    
    // top background box
    self.topBackground = [[UIView alloc]initWithFrame:CGRectMake(-2, -2, self.bounds.size.height+4,46)];
    self.topBackground.backgroundColor = self.colorBackground;
    [self.topBackground.layer setBorderWidth:0.5f];
    [self.topBackground.layer setBorderColor:self.colorGrey.CGColor];
    
    // bottom background box
    self.bottomBackground = [[UIView alloc]initWithFrame:CGRectMake(-2, self.bounds.size.width-44, self.bounds.size.height+4,46)];
    self.bottomBackground.backgroundColor = self.colorBackground;
    [self.bottomBackground.layer setBorderWidth:0.7f];
    [self.bottomBackground.layer setBorderColor:self.colorGrey.CGColor];
    
    // insert
    [self.view addSubview:self.topBackground];
    [self.view addSubview:self.bottomBackground];
    [self.view addSubview:self.merchantNameLabel];
    [self.view addSubview:self.amountTextLabel];
    [self.view addSubview:self.signatureTextLabel];
    [self.view addSubview:self.payButton];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.signatureLineView];
}
- (void)btnPay
{
    self.payCallback();
}
- (void)btnCancel
{
    self.cancelCallback();
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
