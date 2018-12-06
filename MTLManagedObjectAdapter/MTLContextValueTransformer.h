//
//  MTLContextValueTransformer.h
//  Skiguide Zermatt
//
//  Created by Samuel Bichsel on 05.12.18.
//  Copyright © 2018 dreipol gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/NSManagedObjectContext.h>

NS_ASSUME_NONNULL_BEGIN
typedef _Nullable id (^MTLContextValueTransformerBlock)(id value, NSManagedObjectContext *context, BOOL *success, NSError **error);

@interface MTLContextValueTransformer : NSValueTransformer
@property(nonatomic, strong) NSManagedObjectContext *context;

/// Returns a transformer which transforms values using the given block. Reverse
/// transformations will not be allowed.
+ (instancetype)transformerUsingForwardBlock:(MTLContextValueTransformerBlock)transformation;

/// Returns a transformer which transforms values using the given block, for
/// forward or reverse transformations.
+ (instancetype)transformerUsingReversibleBlock:(MTLContextValueTransformerBlock)transformation;

/// Returns a transformer which transforms values using the given blocks.
+ (instancetype)transformerUsingForwardBlock:(MTLContextValueTransformerBlock)forwardTransformation reverseBlock:(MTLContextValueTransformerBlock)reverseTransformation;
@end

NS_ASSUME_NONNULL_END
