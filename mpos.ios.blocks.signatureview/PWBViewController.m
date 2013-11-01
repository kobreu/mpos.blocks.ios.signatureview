//
//  PWSVViewController.m
//  mpos.ios.blocks.signatureview
//
//  Created by Thomas Pischke on 01.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import "PWBViewController.h"
#import "PWBSignatureView.h"
#import <QuartzCore/QuartzCore.h>

@interface PWBViewController ()

@end

@implementation PWBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    PWBSignatureView* signatureView = [[PWBSignatureView alloc]initWithFrame:CGRectMake(0, 0, self.view.layer.frame.size.width, self.view.layer.frame.size.height)];
    [self.view addSubview:signatureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
