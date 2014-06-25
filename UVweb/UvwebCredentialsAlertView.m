//
//  UvwebCredentialsAlertView.m
//  UVweb
//
//  Created by Maxime on 25/06/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "UvwebCredentialsAlertView.h"

@implementation UvwebCredentialsAlertView

//Singleton design pattern
+ (UIAlertView*)getUvwebCredentialsAlertView:(id <UIAlertViewDelegate>)delegate message:(NSString*)message;
{
    UIAlertView *credentialsAlertView;
    
    credentialsAlertView = [[UIAlertView alloc] initWithTitle:@"Compte UVweb" message:message delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles: @"Valider", nil];
        
    credentialsAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    [credentialsAlertView setDelegate:delegate];
    
    return credentialsAlertView;
}

@end
