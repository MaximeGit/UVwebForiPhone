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

- (void)getAllUvsAndRefreshTable:(UITableView*)table uvs:(OrderedDictionary*)uvs
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionDataTask *uvsJson = [_session dataTaskWithURL:[NSURL URLWithString:[_uvwebBaseUrl stringByAppendingString:@"all"]]
                                     
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                
                                                
                                                if (!error)
                                                {
                                                    NSLog(@"%@", _uvwebBaseUrl);
                                                    
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
                                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                [table reloadData];
                                                            });
                                                        }
                                                    }
                                                    else
                                                    {
                                                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                    }
                                                }
                                            }];
    
    [uvsJson resume];
}

- (void)uvDetails:(Uv*)uv forTable:(UITableView*)table uvComments:(NSMutableArray*)uvComments
{
    //Display the icons that shows we are fecthing data
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //URL of the details in the web service
    NSURL* uvDetailURL = [NSURL URLWithString:[_uvwebBaseUrl stringByAppendingString:@"details"]];
    
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
                                                            NSLog(@"Retour: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                            
                                                            NSDictionary *uvBasicDetails = uvDetails[@"details"][@"uv"][0];
                                                            
                                                            if(![[uvBasicDetails valueForKey:@"tp"] isKindOfClass:[NSNull class]])
                                                            {
                                                                uv.hasTp = [[uvBasicDetails valueForKey:@"tp"] boolValue];
                                                            }
                                                            
                                                            if(![[uvBasicDetails valueForKey:@"final"] isKindOfClass:[NSNull class]])
                                                            {
                                                                uv.hasFinal = [[uvBasicDetails valueForKey:@"final"] boolValue];
                                                            }
                                                            
                                                            for (NSDictionary *comment in uvDetails[@"details"][@"comments"])
                                                            {
                                                                Comment *newComment = [[Comment alloc] initWithJSONData:comment];
                                                                
                                                                [uvComments addObject:newComment];
                                                            }
                                                            
                                                            //Sorting the comments
                                                            [uvComments sortUsingComparator: ^NSComparisonResult(id obj1, id obj2){
                                                                
                                                                Comment *c1 = (Comment*)obj1;
                                                                Comment *c2 = (Comment*)obj2;
                                                                
                                                                return [c2.commentId compare:c1.commentId];
                                                            }];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                [table reloadData];
                                                            });
                                                        }
                                                    }
                                                }
                                                //Removing the network indicator after execution if an error occured
                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                            }];
    
    [uvDetailsJson resume];
}

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