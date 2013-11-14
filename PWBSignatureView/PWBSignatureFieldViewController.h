//
//  PWBSignatureFieldViewController.h
//  mpos.ios.blocks.signatureview
//
//  Created by Thomas Pischke on 08.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d/cocos2d.h"

@interface PWBSignatureFieldViewController : UIViewController <CCDirectorDelegate>

@property (nonatomic, weak) CCGLView* signatureView;

/**
 * Lays out the signature field for capturing the signature using cocos2D
 */
-(void)setupSignatureFieldWithFrame:(CGRect)frame;
-(void)setupSignatureFieldWithView:(UIView*)view;

- (void)setupSignatureFieldComponents;

/**
 * Clears the signature currently on the screen
 */
-(void)clearSignature;

/**
 * Returns the signature currently on the screen
 * @return The signature entered by the user as a UIImage
 */
-(UIImage*) signature;

-(void)tearDownSignatureField;

@end

@protocol PWTSignatureFieldViewControllerDelegate <NSObject>

- (void)signatureDidClear:(PWBSignatureFieldViewController*)aController;
- (void)signatureDidChange:(PWBSignatureFieldViewController*)aController;

@end

