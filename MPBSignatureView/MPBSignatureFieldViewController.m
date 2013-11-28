//
//  PWBSignatureFieldViewController.m
//  mpos.ios.blocks.signatureview
//
//  Created by Thomas Pischke on 08.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import "MPBSignatureFieldViewController.h"
#import "cocos2d/cocos2d.h"
#import "LineDrawer.h"

@interface MPBSignatureFieldViewController ()

@property (nonatomic, weak) CCDirectorIOS *director;
@property (nonatomic, weak) LineDrawer *lineDrawer;

@property (nonatomic, weak) UIColor* signatureColor;
@property CGRect frame;

@end

@implementation MPBSignatureFieldViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.signatureColor = [UIColor blackColor];
        self.frame = self.view.frame;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)setupSignatureFieldBackground
{
    // method can be overwritten by user
}
- (void)setupSignatureFieldComponents
{
    // method can be overwritten by user
}

- (void)setupSignatureFieldWithView:(UIView*)view
{
    self.frame = view.frame;
}

- (void)setupSignatureFieldWithFrame:(CGRect)frame
{
    self.frame = frame;
}

- (void)setupSignatureField
{
    self.signatureView = [CCGLView viewWithFrame:self.frame// landscape signature field
                                     pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
                                     depthFormat:0	//GL_DEPTH_COMPONENT24_OES
                              preserveBackbuffer:NO
                                      sharegroup:nil
                                   multiSampling:NO
                                 numberOfSamples:0];
    
    self.director = (CCDirectorIOS*) [CCDirector sharedDirector];
    
	self.director.wantsFullScreenLayout = YES;
    [self.director setDisplayStats:NO];
    [self.director setAnimationInterval:1.0/60];
	[self.director setProjection:kCCDirectorProjection2D];

	if( ! [self.director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
    
    [self.director setView:self.signatureView];
    [self addChildViewController:self.director];
    
    CCScene *scene = [CCScene node];
    self.lineDrawer = [LineDrawer node];
    self.lineDrawer.color = self.signatureColor;
    [scene addChild:self.lineDrawer];
	[self.director pushScene: scene];
    
    [self.view addSubview:self.signatureView];
}

-(void)willMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        [self tearDownSignatureField];
    }
}

-(void)tearDownSignatureField {
    [self.director willMoveToParentViewController:nil];
    [self.director.view removeFromSuperview];
    [self.director removeFromParentViewController];
    self.director.delegate = nil;
    [self.director setView:nil];
    CC_DIRECTOR_END();
    self.director = nil;
    self.lineDrawer = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self.director isAnimating]) {
        
        [self setupSignatureFieldBackground];
        [self setupSignatureField];
        [self setupSignatureFieldComponents];
        
        [self.director startAnimation];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [self.director stopAnimation];
    [self tearDownSignatureField];
    [super viewWillDisappear:animated];
}

#pragma mark -- Application lifecycle methods
-(void)applicationWillEnterForeground {
    [self.director startAnimation];
}

-(void)applicationWillResignActive {
    [self.director stopAnimation];
}

-(void)clearSignature {
    [self.lineDrawer clearDrawing];
}

-(UIImage *)signature {
    return [self.lineDrawer drawing];
}

@end
