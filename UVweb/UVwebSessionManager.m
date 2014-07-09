//
//  UVwebSessionManager.m
//  UVweb
//
//  Created by Maxime on 08/12/2013.
//  Copyright (c) 2013 UVweb. All rights reserved.
//

#import "UVwebSessionManager.h"
#import "Uv.h"

@interface UVwebSessionManager()

@property(nonatomic, strong) NSURLSession *session;

@end

@implementation UVwebSessionManager

- (id)initAttributes
{
    if((self = [super init]))
    {
        _uvwebBaseUrl = [NSMutableString stringWithString:baseUrl];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        sessionConfig.allowsCellularAccess = YES;
        
        [sessionConfig setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
        
        sessionConfig.timeoutIntervalForRequest = 30.0;
        sessionConfig.timeoutIntervalForResource = 60.0;
        
        _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    }
    
    return self;
}

- (void)showServerUnreachableAlertView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    UIAlertView *alertViewError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur inaccessible." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertViewError show];
}

- (void)uvsOfBranch:(Branch)branch forTableViewController:(UvsViewController*)tableViewController
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    OrderedDictionary *uvs = [[OrderedDictionary alloc] init];
    
    NSURLSessionDataTask *uvsJson = [_session dataTaskWithURL:[NSURL URLWithString:[_uvwebBaseUrl stringByAppendingString:[NSString stringWithFormat:@"uv/app/%@", [BranchEnum webServiceName:branch]]]]
                                     
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                
                                                
                                                if (!error)
                                                {
                                                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                    if (httpResp.statusCode == 200)
                                                    {
                                                        NSError *jsonError;
                                                        
                                                        NSDictionary *uvsFound =
                                                        [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&jsonError];
                                                        
                                                        if (!jsonError)
                                                        {
                                                            NSLog(@"Retour: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                            
                                                            for (NSDictionary *groupLetter in uvsFound)
                                                            {
                                                                [uvs setValue:[[NSMutableArray alloc] init] forKey:(NSString *)groupLetter];
                                                                
                                                                NSDictionary *groupedUvs = uvsFound[groupLetter];
                                                                for (NSDictionary *uv in groupedUvs)
                                                                {
                                                                    Uv* newUv = [[Uv alloc] initWithJSONData:uv];
                                                                    NSLog(@"UV: %@", [newUv name]);
                                                                    
                                                                    [[uvs objectForKey:groupLetter] addObject:newUv];
                                                                }
                                                            }
                                                            
                                                            //Need to sort the NSMutableDictionary keys as they were not ordered in the JSON
                                                            [uvs sortKeysUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                //Updating controller's model in main thread
                                                                [[tableViewController orderedUVs] removeAllObjects];
                                                                tableViewController.orderedUVs = uvs;
                                                                
                                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                [tableViewController reloadDataTable];
                                                            });
                                                        }
                                                    }
                                                    else
                                                    {
                                                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                        [tableViewController reloadDataTable];
                                                    }
                                                }
                                                else
                                                {
                                                    //Can't reach server or no internet connexion
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self showServerUnreachableAlertView];
                                                    });
                                                }
                                            }];
    
    [uvsJson resume];
}


- (void)uvDetails:(Uv*)uv forViewController:(UvDetailsViewController*)tableViewController
{
    NSMutableArray* uvComments = [[NSMutableArray alloc] init];
    
    //Display the icons that shows we are fecthing data
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //URL of the details in the web service
    NSString* uvDetailURLString = [NSString stringWithString:[_uvwebBaseUrl stringByAppendingString:@"uv/app/details/"]];
    NSURL* uvDetailURL = [NSURL URLWithString:[uvDetailURLString stringByAppendingString:uv.name]];
    
    NSURLSessionDataTask *uvDetailsJson = [_session dataTaskWithURL:uvDetailURL
                                     
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                
                                                
                                                if (!error)
                                                {
                                                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                    if (httpResp.statusCode == 200)
                                                    {
                                                        NSError *jsonError;
                                                        
                                                        NSDictionary *uvDetails =
                                                        [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&jsonError];
                                                        
                                                        if (!jsonError)
                                                        {
                                                            //No error occured
                                                            NSLog(@"Retour: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                            
                                                            NSDictionary *uvBasicDetails = uvDetails[@"details"][@"uv"];
                                                            
                                                            //Make sure the TP info exists before using it
                                                            if(![[uvBasicDetails valueForKey:@"tp"] isKindOfClass:[NSNull class]])
                                                            {
                                                                uv.hasTp = [[uvBasicDetails valueForKey:@"tp"] intValue];
                                                            }
                                                            else
                                                            {
                                                                uv.hasTp = 2;
                                                            }
                                                            
                                                            //Make sure the final info exists before using it
                                                            if(![[uvBasicDetails valueForKey:@"final"] isKindOfClass:[NSNull class]])
                                                            {
                                                                uv.hasFinal = [[uvBasicDetails valueForKey:@"final"] intValue];
                                                            }
                                                            else
                                                            {
                                                                uv.hasFinal = 2;
                                                            }
                                                            
                                                            //Setting up the title of the view and its attached UV
                                                            Uv* controllerUv = tableViewController.uv;
                                                            
                                                            controllerUv.title = uvBasicDetails[@"title"];
                                                            controllerUv.globalRate = [NSNumber numberWithDouble:[uvDetails[@"details"][@"averageRate"] doubleValue]];
                                                            
                                                            
                                                            for (NSDictionary *comment in uvDetails[@"details"][@"comments"])
                                                            {
                                                                Comment *newComment = [[Comment alloc] initWithJSONData:comment];
                                                                
                                                                [uvComments addObject:newComment];
                                                            }
                                                            
                                                            NSMutableArray *arrayPolls = [[NSMutableArray alloc] init];
                                                            
                                                            for (NSDictionary *poll in uvDetails[@"details"][@"polls"])
                                                            {
                                                                [arrayPolls addObject: [[Poll alloc] initWithJSONData:poll]];
                                                            }
                                                            
                                                            controllerUv.polls = arrayPolls;
                                                            
                                                            //Sorting the comments
                                                            [uvComments sortUsingSelector:@selector(compareReverseCommentId:)];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                //Updating model in main thread
                                                                [[tableViewController uvComments] removeAllObjects];
                                                                tableViewController.uvComments = uvComments;
                                                                
                                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                [tableViewController reloadDataTable];
                                                            });
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    //Can't reach server or no internet connexion
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self showServerUnreachableAlertView];
                                                    });
                                                }
                                            }];
    
    [uvDetailsJson resume];
}

- (void)recentActivity:(RecentActivityViewController*)recentActivityViewController
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableArray* recentComments = [[NSMutableArray alloc] init];
    
    NSURLSessionDataTask *commentsJson = [_session dataTaskWithURL:[NSURL URLWithString:[_uvwebBaseUrl stringByAppendingString:@"app/recentactivity"]]
                                     
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                
                                                
                                                if (!error)
                                                {
                                                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                    if (httpResp.statusCode == 200)
                                                    {
                                                        NSError *jsonError;
                                                        
                                                        NSDictionary *commentsFound =
                                                        [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&jsonError];
                                                        
                                                        if (!jsonError)
                                                        {
                                                            NSLog(@"Retour: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                            
                                                            for (NSDictionary *commentDictionary in commentsFound[@"comments"])
                                                            {
                                                                Comment *comment = [[Comment alloc] initWithJSONData:commentDictionary];
                                                                Uv *uv = [[Uv alloc] initWithName:commentDictionary[@"name"] andTitle:commentDictionary[@"title"]];
                                                                
                                                                RecentComment *newRecentComment = [[RecentComment alloc] initWithComment:comment andUv:uv];
                                                                
                                                                [recentComments addObject:newRecentComment];
                                                            }
                                                            
                                                            //Need to sort the NSMutableDictionary keys as they were not ordered in the JSON
                                                            [recentComments sortUsingSelector:@selector(compareReverseCommentId:)];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                //Sort model in main thread
                                                                [[recentActivityViewController recentComments] removeAllObjects];
                                                                recentActivityViewController.recentComments = recentComments;
                                                                
                                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                [recentActivityViewController reloadDataTable];
                                                            });
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    //Can't reach server or no internet connexion
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self showServerUnreachableAlertView];
                                                    });
                                                }
                                            }];
    
    [commentsJson resume];
}

/**
 * Function that sends a request to the server to ask if user exists and has commented or not the UV. Once answer received, delegate is called to user the answer.
 */
- (void)userAllowedToCommentUv:(Uv*)uv username:(NSString*)username password:(NSString*)password delegate:(id <UserAllowedToCommentCompletedProtocol>)delegate
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableString *urlString = [NSMutableString stringWithString:_uvwebBaseUrl];
    [urlString appendString:@"uv/app/comment/cancomment/"];
    [urlString appendString:uv.name];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession* session = [self sessionWithBasicAuthentication:username password:password];
    
    NSURLSessionDataTask *userAllowedToCommentJson = [session dataTaskWithURL:url
                                                      
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          
                                                          if (!error)
                                                          {
                                                              NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                              
                                                              //Checking status code
                                                              if(httpResp.statusCode == 200)
                                                              {
                                                                  NSError *jsonError;
                                                                  
                                                                  NSDictionary *userAllowed =
                                                                  [NSJSONSerialization JSONObjectWithData:data
                                                                                                  options:NSJSONReadingAllowFragments
                                                                                                    error:&jsonError];
                                                                  
                                                                  if (!jsonError)
                                                                  {
                                                                      //Modifications in the main thread with delegate
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                          
                                                                          if ([[userAllowed objectForKey:@"alreadyCommented"] boolValue] == false)
                                                                          {
                                                                              [delegate receivedUserCanCommentUvAnswerFromServer:true textAnser:@"UV non encore commentée." httpCode:(int)httpResp.statusCode];
                                                                          }
                                                                          else
                                                                          {
                                                                              [delegate receivedUserCanCommentUvAnswerFromServer:false textAnser:@"UV déjà commentée." httpCode:(int)httpResp.statusCode];
                                                                          }
                                                                      });
                                                                  }
                                                              }
                                                              else if(httpResp.statusCode == 401)
                                                              {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                      [delegate receivedUserCanCommentUvAnswerFromServer:false textAnser:@"Aucun utilisateur associé aux informations entrées." httpCode:(int)httpResp.statusCode];
                                                                  });
                                                              }
                                                              else if(httpResp.statusCode == 404)
                                                              {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                      [delegate receivedUserCanCommentUvAnswerFromServer:false textAnser:@"Cette UV n'existe pas ou plus." httpCode:(int)httpResp.statusCode];
                                                                  });
                                                              }
                                                              else
                                                              {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                      [delegate receivedUserCanCommentUvAnswerFromServer:false textAnser:@"Erreur lors de la tentative de connexion." httpCode:(int)httpResp.statusCode];
                                                                  });
                                                              }
                                                          }
                                                          else
                                                          {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                  [delegate receivedUserCanCommentUvAnswerFromServer:false textAnser:@"Impossible de contacter le serveur." httpCode:500];
                                                              });

                                                          }
                                                      }];

    [userAllowedToCommentJson resume];
}

/**
 * Function that sends a user comment to UVweb's server
 */
- (void)sendCommentToServer:(NSDictionary*)newComment username:(NSString*)username password:(NSString*)password uv:(Uv*)uv delegate:(id <CommentSentToServerReplyDelegate>)delegate
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //URL to send the comment
    NSMutableString *urlString = [NSMutableString stringWithString:_uvwebBaseUrl];
    [urlString appendString:@"uv/app/comment/"];
    [urlString appendString:uv.name];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    //Making session and put request
    NSURLSession* session = [self sessionWithBasicAuthentication:username password:password];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"PUT"];

    //Filling request with comment data in JSON
    NSError *error;
    NSData *putCommentData = [NSJSONSerialization dataWithJSONObject:newComment options:0 error:&error];
    [request setHTTPBody:putCommentData];
    
    //Sending request and handling server reply
    NSURLSessionDataTask *sendComment = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error)
        {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;

            switch (httpResp.statusCode) {
                case 200:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        [delegate serverDidAcceptComment];
                    });

                    break;
                }
                    
                case 401:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        [delegate serverDidNotAcceptComment:(int) httpResp.statusCode answer:@"Aucun utilisateur associé aux informations entrées."];
                    });
                    break;
                }
                    
                case 404:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        [delegate serverDidNotAcceptComment:(int)httpResp.statusCode answer:@"Cette UV n'existe pas ou plus."];
                    });
                    break;
                }
                    
                default:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        [delegate serverDidNotAcceptComment:(int)httpResp.statusCode answer:@"Erreur lors de la tentative d'insertion du commentaire."];
                    });
                    
                    break;
                }
            }
        }
        else
        {
            //Can't reach server or no internet connexion
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showServerUnreachableAlertView];
            });
        }
    }];
    
    [sendComment resume];
}

- (NSURLSession*) sessionWithBasicAuthentication:(NSString*) username password:(NSString*)password
{
    NSString *credentialsBase64 =[NSString stringWithFormat:@"%@:%@", username, password];
    credentialsBase64 = [[credentialsBase64 dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    
    NSString *authString = [NSString stringWithFormat:@"Basic %@", credentialsBase64];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfig.allowsCellularAccess = YES;
    
    [sessionConfig setHTTPAdditionalHeaders:@{
                                              @"Accept": @"application/json",
                                              @"Authorization": authString,
                                              }];
    
    sessionConfig.timeoutIntervalForRequest = 30.0;
    sessionConfig.timeoutIntervalForResource = 60.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];

    return session;
}

//Singleton design pattern
+ (UVwebSessionManager*)sharedSessionManager
{
    static UVwebSessionManager *_sharedSessionManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedSessionManager = [UVwebSessionManager alloc];
        _sharedSessionManager = [_sharedSessionManager initAttributes];
    });
    
    return _sharedSessionManager;
}

@end