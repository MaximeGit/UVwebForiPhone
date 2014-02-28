//
//  Uv.h
//  UVweb
//
//  Created by Maxime on 27/01/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Uv : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSNumber *globalRate;
@property (nonatomic, strong, readonly) NSNumber *commentCount;
//@property (nonatomic, assign, readonly) int commentCount;

-(id)initWithJSONData:(NSDictionary *)UvJSON;
-(NSString *)getFormattedGlobalRate;
-(NSMutableAttributedString *)attributeStringForName;

@end
