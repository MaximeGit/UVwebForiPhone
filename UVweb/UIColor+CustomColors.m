//
//  UIColor+CustomColors.m
//  UVweb
//
//  Created by Maxime on 28/02/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

//Static method that returns the green color used for UVweb
+(UIColor *)uvwebColor
{
    //Static variable to allocate memory only once for this color
    static UIColor *uvwebColor;
    
    //Make sure to create it only once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uvwebColor = [UIColor colorWithRed:114.0/255.0
                                     green:187.0/255.0
                                      blue:170.0/255.0
                                     alpha:1.0];
    });
    
    return uvwebColor;
}

@end
