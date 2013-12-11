/*
 * mPOS SKD Building Blocks: http://www.payworksmobile.com
 *
 * Copyright (c) 2013 payworks GmbH
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "MPBSignatureFieldViewController.h"
#import "cocos2d/cocos2d.h"
#import "LineDrawer.h"

@interface MPBSignatureFieldViewController ()

@property (nonatomic, weak) CCDirectorIOS *director;
@property (nonatomic, weak) LineDrawer *lineDrawer;

@property (nonatomic, weak) UIView *viewToAdd;

@property (nonatomic, weak) UIColor* signatureColor;
@property CGRect frame;

@end

@implementation MPBSignatureFieldViewController

- (id)init {
    self = [super init];
    if (self) {
        self.signatureColor = [UIColor blackColor];
        self.frame = self.view.frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setupSignatureFieldBackground {
    // method can be overwritten by user to add background components to the signature field
}
- (void)setupSignatureFieldComponents {
    // method can be overwritten by user to add frontend components to the signature field
}

- (void)setupSignatureFieldWithView:(UIView*)view {
    self.frame = view.frame;
    self.viewToAdd = view;
}

- (void)setupSignatureFieldWithFrame:(CGRect)frame {
    self.frame = frame;
    self.viewToAdd = self.view;
}

- (void)setupSignatureField {
    self.signatureView = [CCGLView viewWithFrame:self.frame
                                     pixelFormat:kEAGLColorFormatRGB565
                                     depthFormat:0
                              preserveBackbuffer:NO
                                      sharegroup:nil
                                   multiSampling:NO
                                 numberOfSamples:0];
    
    self.director = (CCDirectorIOS*) [CCDirector sharedDirector];
    
	self.director.wantsFullScreenLayout = YES;
    [self.director setDisplayStats:NO];
    [self.director setAnimationInterval:1.0/60];
	[self.director setProjection:kCCDirectorProjection2D];
    
    [self.director setView:self.signatureView];
    [self addChildViewController:self.director];
    
    CCScene *scene = [CCScene node];
    self.lineDrawer = [LineDrawer node];
    self.lineDrawer.color = self.signatureColor;
    self.lineDrawer.delegate = self;
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

- (void)lineDrawerDidChange:(LineDrawer *)aDrawer;
{
    if(self.onSignatureChange) {
        self.onSignatureChange();
    }
}

- (void)lineDrawerDidClear:(LineDrawer *)aDrawer;
{
    if(self.onSignatureClear) {
        self.onSignatureClear();
    }
}

@end
