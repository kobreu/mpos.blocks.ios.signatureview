//
//  MPBSignatureViewController7.h
//  mpos.ios.blocks.signatureview
//
//  Created by Thomas Pischke on 24.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBSignatureFieldViewController.h"

@interface MPBSignatureViewController : MPBSignatureFieldViewController

// Customizable properties
@property (nonatomic, strong) NSString* merchantName;
@property (nonatomic, strong) NSString* amountText;
@property (nonatomic, strong) NSString* signatureText;
@property (nonatomic, strong) UIColor* signatureColor;
@property (nonatomic, strong) NSString* payButtonText;
@property (nonatomic, strong) NSString* cancelButtonText;
@property (nonatomic, strong) UIColor* buttonColor;

- (void)registerOnPay:(void (^)(void))payBlock onCancel:(void (^)(void))cancelBlock;

@end