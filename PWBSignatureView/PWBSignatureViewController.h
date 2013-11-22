//
//  PWBSignatureViewController2.h
//  mpos.ios.blocks.signatureview
//
//  Created by Thomas Pischke on 01.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWBSignatureFieldViewController.h"

@interface PWBSignatureViewController : PWBSignatureFieldViewController

// Customizable properties
@property (nonatomic, strong) UIImage* merchantLogo;
@property (nonatomic, strong) NSString* merchantName;
@property (nonatomic, strong) NSString* amountText;
@property (nonatomic, strong) NSString* signatureText;
@property (nonatomic, strong) UIColor* signatureColor;
@property (nonatomic, strong) NSString* payButtonText;
@property (nonatomic, strong) NSString* cancelButtonText;

- (void)registerOnPay:(void (^)(void))payBlock onCancel:(void (^)(void))cancelBlock;

@end