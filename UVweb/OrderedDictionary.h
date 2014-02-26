#import <Foundation/Foundation.h>

@interface OrderedDictionary : NSMutableDictionary

@property(nonatomic, strong) NSMutableDictionary *dictionary;
@property(nonatomic, strong) NSMutableArray *array;


- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex;
- (id)keyAtIndex:(NSUInteger)anIndex;
- (NSEnumerator *)reverseKeyEnumerator;
- (void)sortKeysUsingSelector:(SEL)comparator;
- (NSArray*)allKeysSorted;

@end
