//
//  Uv.h
//  UVweb
//
//  Created by Maxime on 27/01/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+CustomColors.h"
#import "Poll.h"

@interface Uv : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *globalRate;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic) int hasTp;
@property (nonatomic) int hasFinal;
@property (nonatomic, strong) NSMutableArray *polls;

-(id)initWithJSONData:(NSDictionary *)UvJSON;
-(NSString *)getFormattedGlobalRate;
-(NSString *)formattedCeilGlobalRate;
-(NSMutableAttributedString *)attributeStringForName;
-(NSComparisonResult)compareReverseGlobalRate:(Uv *)otherUv;
-(NSComparisonResult)compareName:(Uv *)otherUv;
-(id)initWithName:(NSString *)name andTitle:(NSString *)title;
-(void)addPoll:(Poll*)poll;

@end
