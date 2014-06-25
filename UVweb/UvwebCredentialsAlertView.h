//
//  UvwebCredentialsAlertView.h
//  UVweb
//
//  Created by Maxime on 25/06/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UvwebCredentialsAlertView : NSObject

+ (UIAlertView*)getUvwebCredentialsAlertView:(id <UIAlertViewDelegate>)delegate message:(NSString*)message;

@end