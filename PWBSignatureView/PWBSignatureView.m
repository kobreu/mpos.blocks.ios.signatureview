//
//  PWSVSignatureView.m
//  mpos.ios.blocks.signatureview
//
//  Created by Thomas Pischke on 01.11.13.
//  Copyright (c) 2013 payworks. All rights reserved.
//

#import "PWBSignatureView.h"

@implementation PWBSignatureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel* label = [[UILabel alloc] initWithFrame:frame];
        label.text = @"TestView";
        
        [self addSubview:label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
