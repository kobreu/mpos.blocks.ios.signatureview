//
//  PWBTestViewController.m
//  ;
//
//  Created by Thomas Pischke on 08.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import "PWBTestViewController.h"

@interface PWBTestViewController ()
@property (weak, nonatomic) IBOutlet UIView *mySigView;

@end

@implementation PWBTestViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelled:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
