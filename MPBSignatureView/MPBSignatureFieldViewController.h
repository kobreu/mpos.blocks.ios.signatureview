//
//  PWBSignatureFieldViewController.h
//  mpos.ios.blocks.signatureview
//
//  Created by Thomas Pischke on 08.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d/cocos2d.h"

@interface MPBSignatureFieldViewController : UIViewController <CCDirectorDelegate>

@property (nonatomic, weak) CCGLView* signatureView;

- (void)setupSignatureFieldWithFrame:(CGRect)frame;
- (void)setupSignatureFieldWithView:(UIView*)view;
- (void)tearDownSignatureField;

- (void)setupSignatureFieldComponents;

- (void)clearSignature;
- (UIImage*) signature;

@end

@protocol PWTSignatureFieldViewControllerDelegate <NSObject>

- (void)signatureDidClear:(MPBSignatureFieldViewController*)aController;
- (void)signatureDidChange:(MPBSignatureFieldViewController*)aController;

@end

