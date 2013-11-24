//
//  PWBTestViewController.m
//  ;
//
//  Created by Thomas Pischke on 08.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import "MPBTestViewController.h"

@interface MPBTestViewController ()
@property (weak, nonatomic) IBOutlet UIView *mySigView;

@end

@implementation MPBTestViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSignatureFieldWithView:self.mySigView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelled:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
