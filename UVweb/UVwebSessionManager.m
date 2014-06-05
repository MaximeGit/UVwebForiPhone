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

- (void)uvsOfBranch:(Branch)branch forTableViewController:(UvsViewController*)tableViewController
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    OrderedDictionary *uvs = [tableViewController orderedUVs];
    
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
                                                            
                                                            //Removing data from model
                                                            [uvs removeAllObjects];
                                                            
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
                                            }];
    
    [uvsJson resume];
}


- (void)uvDetails:(Uv*)uv forViewController:(UvDetailsViewController*)tableViewController
{
    NSMutableArray* uvComments = tableViewController.uvComments;
    
    //Display the icons that shows we are fecthing data
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //URL of the details in the web service
    NSURL* uvDetailURL = [NSURL URLWithString:[_uvwebBaseUrl stringByAppendingString:@"uv/app/details"]];
    
    //Setting up the POST request
    NSString *postParameters = [NSString stringWithFormat:@"uvname=%@", [uv name]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:uvDetailURL];
    request.HTTPBody = [postParameters dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *uvDetailsJson = [_session dataTaskWithRequest:request
                                     
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
                                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                [tableViewController reloadDataTable];
                                                            });
                                                        }
                                                    }
                                                }
                                                //Removing the network indicator after execution if an error occured
                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                            }];
    
    [uvDetailsJson resume];
}

- (void)recentActivity:(RecentActivityViewController*)recentActivityViewController
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableArray* recentComments = recentActivityViewController.recentComments;
    
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
                                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                [recentActivityViewController reloadDataTable];
                                                            });
                                                        }
                                                    }
                                                    else
                                                    {
                                                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                    }
                                                }
                                            }];
    
    [commentsJson resume];
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