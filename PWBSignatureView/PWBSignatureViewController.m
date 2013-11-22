//
//  PWBSignatureViewController2.m
//  mpos.ios.blocks.signatureview
//
//  Created by Thomas Pischke on 01.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import "PWBSignatureViewController.h"
#import "cocos2d/cocos2d.h"
#import "LineDrawer.h"

@interface PWBSignatureViewController ()

@property (nonatomic, weak) CCDirectorIOS *director;
@property (nonatomic, weak) LineDrawer *lineDrawer;

@property CGRect signatureFrame;

// UI Components
@property (nonatomic, strong) UIImageView* merchantLogoView;
@property (nonatomic, strong) UILabel* merchantNameLabel;
@property (nonatomic, strong) UILabel* amountTextLabel;
@property (nonatomic, strong) UILabel* signatureTextLabel;
@property (nonatomic, strong) UIView* signatureLineView;
@property (nonatomic, strong) UIButton* payButton;
@property (nonatomic, strong) UIButton* cancelButton;
@property (nonatomic, strong) UIImageView* backgroundView;
@property (nonatomic, strong) UIImageView* paperView;

// Callback Blocks
@property (nonatomic, copy) void (^payCallback)(void);
@property (nonatomic, copy) void (^cancelCallback)(void);

@end

@implementation PWBSignatureViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.merchantLogo = [UIImage imageNamed: [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIconFiles"] objectAtIndex:0]];
        self.merchantName = @"payworks";
        self.amountText = @"1.00 €";
        self.signatureText = @"Signature";
        self.signatureColor = [UIColor blueColor];
        
        self.payButtonText = @"Pay";
        self.cancelButtonText = @"Cancel";
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft || [self interfaceOrientation] == UIInterfaceOrientationLandscapeRight) {
            self.signatureFrame = CGRectMake(0, 0, self.view.frame.size.height-2*25, self.view.frame.size.width+20-100); // +20=ignore navbar, -2*25=border left-right, -100=button bar
        } else {
            self.signatureFrame = CGRectMake(0, 0, self.view.frame.size.height+20-2*25, self.view.frame.size.width-100);
        }
        [self setupSignatureFieldWithFrame:self.signatureFrame];
    }
    return self;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self alignComponentsForOrientation:self.interfaceOrientation];
}

- (CGRect)getSignatureFrameForOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return CGRectMake(25, 0, self.signatureFrame.size.width, self.signatureFrame.size.height);
    } else {
        return CGRectMake((self.view.bounds.size.width-self.signatureFrame.size.width)/2, 90, self.signatureFrame.size.width, self.signatureFrame.size.height);
    }
}

- (void)alignComponentsForOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    self.signatureView.layer.frame = [self getSignatureFrameForOrientation:interfaceOrientation];
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {

        self.amountTextLabel.frame = CGRectMake(self.view.bounds.size.width-40-200, 15, 200, 26);
        self.amountTextLabel.textAlignment = NSTextAlignmentRight;
        self.signatureTextLabel.frame = CGRectMake((self.view.bounds.size.width-self.signatureTextLabel.frame.size.width)/2,
                                                   self.signatureView.frame.origin.y+self.signatureView.frame.size.height-15-self.signatureTextLabel.frame.size.height,
                                                   self.signatureTextLabel.frame.size.width,
                                                   self.signatureTextLabel.frame.size.height);
        self.signatureLineView.frame = CGRectMake(self.signatureTextLabel.frame.origin.x, self.signatureTextLabel.frame.origin.y-5, self.signatureTextLabel.frame.size.width, 1);
        self.payButton.frame = CGRectMake(self.view.bounds.size.width-20-220, self.view.bounds.size.height-20-40, 220, 54);
        self.cancelButton.frame = CGRectMake(self.view.bounds.size.width-20-220-10-220, self.view.bounds.size.height-20-40, 220, 54);
        self.backgroundView.frame = CGRectMake(0, 5, self.view.bounds.size.width, self.view.bounds.size.height*7.1/5);
        self.paperView.frame = self.view.bounds;
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGRect maskRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
        maskLayer.path = path;
        CGPathRelease(path);
        self.backgroundView.layer.mask = maskLayer;
        
        maskLayer = [[CAShapeLayer alloc] init];
        maskRect = self.signatureFrame;
        path = CGPathCreateWithRect(maskRect, NULL);
        maskLayer.path = path;
        CGPathRelease(path);
        self.signatureView.layer.mask = maskLayer;
    
        self.paperView.frame = CGRectMake(self.signatureView.layer.frame.origin.x-5, 0, self.signatureView.layer.frame.size.width+10, self.signatureView.layer.frame.size.height);
    } else {
        self.amountTextLabel.frame = CGRectMake(94, 54, 290, 26);
        self.amountTextLabel.textAlignment = NSTextAlignmentLeft;
        self.signatureTextLabel.frame = CGRectMake(20,
                                                   self.signatureView.frame.origin.y+self.signatureView.frame.size.height-15-self.signatureTextLabel.frame.size.height,
                                                   self.view.bounds.size.width-40,
                                                   self.signatureTextLabel.frame.size.height);
        self.signatureLineView.frame = CGRectMake(30, self.signatureTextLabel.frame.origin.y-5, self.signatureTextLabel.frame.size.width-20, 1);
        self.payButton.frame = CGRectMake(20, 330, self.view.bounds.size.width-40, 54);
        self.cancelButton.frame = CGRectMake(20, 385, self.view.bounds.size.width-40, 54);
        self.backgroundView.frame = CGRectMake(0, -445, self.view.bounds.size.width, 2*self.backgroundView.image.size.height);
        
        // mask backgroundView
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGRect maskRect = CGRectMake(0, 445, self.view.bounds.size.width, self.view.bounds.size.height);
        CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
        maskLayer.path = path;
        CGPathRelease(path);
        self.backgroundView.layer.mask = maskLayer;
        
        // mask signature view
        maskLayer = [[CAShapeLayer alloc] init];
        maskRect = CGRectMake((-1)*self.signatureView.frame.origin.x+25, 0, self.view.bounds.size.width-50, self.signatureView.frame.size.height);
        path = CGPathCreateWithRect(maskRect, NULL);
        maskLayer.path = path;
        CGPathRelease(path);
        self.signatureView.layer.mask = maskLayer;
        
        self.paperView.frame = CGRectMake(20, 0, maskRect.size.width+10, 310);
        
    }
}

- (void)registerOnPay:(void (^)(void))payBlock onCancel:(void (^)(void))cancelBlock {
    self.payCallback = payBlock;
    self.cancelCallback = cancelBlock;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self alignComponentsForOrientation:[self interfaceOrientation]];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self alignComponentsForOrientation:[self interfaceOrientation]];
}
- (void)setupSignatureFieldBackground
{
    UIImage* background = [[UIImage imageNamed:@"temp_till_bg_landscape.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 25, 490, 25)];
    self.backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, self.view.bounds.size.height*7.1/5)];
    self.backgroundView.image = background;
    self.backgroundView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.backgroundView];
    
    UIImage* paper = [[UIImage imageNamed:@"temp_paper_middle_landscape.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 25)];
    self.paperView = [[UIImageView alloc]init];
    self.paperView.image = paper;
    self.paperView.backgroundColor = [UIColor clearColor];
    self.paperView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.paperView];
    
}
- (void)setupSignatureFieldComponents
{
    // Merchant Logo
    self.merchantLogoView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 9, 50, 40)];
    self.merchantLogoView.image = self.merchantLogo;
    self.merchantLogoView.contentMode = UIViewContentModeCenter;
    self.merchantLogoView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Merchant Name
    self.merchantNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(97, 15, 120, 28)];
    self.merchantNameLabel.backgroundColor = [UIColor clearColor];
    [self.merchantNameLabel setText:self.merchantName];
    [self.merchantNameLabel setFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:11]];
    
    // Amount Text
    self.amountTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(201, 17, 200, 26)];
    self.amountTextLabel.backgroundColor = [UIColor clearColor];
    [self.amountTextLabel setText:self.amountText];
    self.amountTextLabel.textAlignment = NSTextAlignmentRight;
    [self.amountTextLabel setFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:32]];
    
    // Signature Text
    self.signatureTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 40)];
    [self.signatureTextLabel setText:self.signatureText];
    [self.signatureTextLabel setFont:[UIFont fontWithName:@"CourierNewPSMT" size:11]];
    self.signatureTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.signatureTextLabel.numberOfLines = 0;
    [self.signatureTextLabel sizeToFit];
    self.signatureTextLabel.textAlignment = NSTextAlignmentCenter;
    self.signatureTextLabel.backgroundColor = [UIColor clearColor];
    
    self.signatureLineView = [[UIView alloc] initWithFrame:CGRectMake(20, 415, 280, 1)];
    self.signatureLineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.signatureLineView];
    
    UIImage *imageGreenNormal = [[UIImage imageNamed:@"temp_btn_green_idle.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)];
    UIImage *imageGreenHighlight = [[UIImage imageNamed:@"temp_btn_green_active.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)];
    
    UIImage *imageRedNormal = [[UIImage imageNamed:@"LogIn_btn_logout_idle.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)];
    UIImage *imageRedHighlight = [[UIImage imageNamed:@"LogIn_btn_logout_active.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)];
    
    // pay button
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payButton setTitle:self.payButtonText forState:UIControlStateNormal];
    [[self.payButton titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
    [self.payButton addTarget:self
               action:@selector(btnPay)
     forControlEvents:UIControlEventTouchUpInside];
    [self.payButton setBackgroundImage:imageGreenNormal forState:UIControlStateNormal];
    [self.payButton setBackgroundImage:imageGreenHighlight forState:UIControlStateHighlighted];
    [self.payButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f)];
    
    // cancel button
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:self.cancelButtonText forState:UIControlStateNormal];
    [[self.cancelButton titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
    [self.cancelButton addTarget:self
                       action:@selector(btnCancel)
             forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setBackgroundImage:imageRedNormal forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:imageRedHighlight forState:UIControlStateHighlighted];
    [self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f)];
    
    // insert
    [self.view addSubview:self.merchantLogoView];
    [self.view addSubview:self.merchantNameLabel];
    [self.view addSubview:self.amountTextLabel];
    [self.view addSubview:self.signatureTextLabel];
    [self.view addSubview:self.payButton];
    [self.view addSubview:self.cancelButton];
}
- (void)btnPay
{
    self.payCallback();
}
- (void)btnCancel
{
    self.cancelCallback();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
