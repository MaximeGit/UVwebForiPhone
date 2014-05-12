//
//  Uv.h
//  UVweb
//
//  Created by Maxime on 27/01/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+CustomColors.h"

@interface Uv : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSNumber *globalRate;
@property (nonatomic, strong, readonly) NSNumber *commentCount;
@property (nonatomic) BOOL hasTp;
@property (nonatomic) BOOL hasFinal;

-(id)initWithJSONData:(NSDictionary *)UvJSON;
-(NSString *)getFormattedGlobalRate;
-(NSString *)formattedCeilGlobalRate;
-(NSMutableAttributedString *)attributeStringForName;
-(NSComparisonResult)compareReverseGlobalRate:(Uv *)otherUv;
-(NSComparisonResult)compareName:(Uv *)otherUv;

@end
