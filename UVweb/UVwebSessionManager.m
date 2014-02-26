//
//  UVwebSessionManager.m
//  UVweb
//
//  Created by Maxime on 08/12/2013.
//  Copyright (c) 2013 UVweb. All rights reserved.
//

#import "UVwebSessionManager.h"
#import "Uv.h"

@implementation UVwebSessionManager

- (id)initWithBaseurl:(NSString *) baseUrl
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

- (void) getAllUvsAndRefreshTable:(NSMutableArray*)uvs table:(UITableView*)table uvss:(OrderedDictionary*)uvss
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionDataTask *uvsJson = [_session dataTaskWithURL:[NSURL URLWithString:_uvwebBaseUrl]
                                     
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                
                                                
                                                if (!error) {
                                                    NSLog(@"%@", _uvwebBaseUrl);
                                                    
                                                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                    if (httpResp.statusCode == 200) {
                                                        
                                                        NSError *jsonError;
                                                        
                                                        NSDictionary *uvsFound =
                                                        [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&jsonError];
                                                        
                                                        if (!jsonError) {
                                                            NSLog(@"Retour: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                            
                                                            for (NSDictionary *groupLetter in uvsFound) {
                                                                
                                                                [uvss setValue:[[NSMutableArray alloc] init] forKey:(NSString *)groupLetter];
                                                                
                                                                NSDictionary *groupedUvs = uvsFound[groupLetter];
                                                                for (NSDictionary *uv in groupedUvs) {
                                                                    Uv* newUv = [[Uv alloc] initWithJSONData:uv];
                                                                  //  NSLog(@"UV: %@", uv[@"name"]);
                                                                    NSLog(@"UV: %@", [newUv name]);
                                                                    
                                                                    [[uvss objectForKey:groupLetter] addObject:newUv];
                                                                    
                                                                    [uvs addObject:newUv];
                                                                }
                                                            }
                                                            [uvss sortKeysUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

                                                            //Sorting the UVs
                                                            [uvs sortUsingComparator:
                                                             ^NSComparisonResult(id uv1, id uv2) {
                                                                 return [((Uv*)uv1).name compare:((Uv*)uv2).name];
                                                             }];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                [table reloadData];
                                                            });
                                                        }
                                                    }
                                                }
                                            }];
    
    [uvsJson resume];
}


@end