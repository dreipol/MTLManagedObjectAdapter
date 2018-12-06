//
//  MTLContextValueTransformer.m
//  Skiguide Zermatt
//
//  Created by Samuel Bichsel on 05.12.18.
//  Copyright © 2018 dreipol gmbh. All rights reserved.
//

#import "MTLContextValueTransformer.h"
@interface ZERReversibleValueTransformer : MTLContextValueTransformer
@end
@interface MTLContextValueTransformer()
@property (nonatomic, copy, readonly) MTLContextValueTransformerBlock forwardBlock;
@property (nonatomic, copy, readonly) MTLContextValueTransformerBlock reverseBlock;

@end

@implementation MTLContextValueTransformer

#pragma mark Lifecycle

+ (instancetype)transformerUsingForwardBlock:(MTLContextValueTransformerBlock)forwardBlock {
    return [[self alloc] initWithForwardBlock:forwardBlock reverseBlock:nil];
}

+ (instancetype)transformerUsingReversibleBlock:(MTLContextValueTransformerBlock)reversibleBlock {
    return [self transformerUsingForwardBlock:reversibleBlock reverseBlock:reversibleBlock];
}

+ (instancetype)transformerUsingForwardBlock:(MTLContextValueTransformerBlock)forwardBlock reverseBlock:(MTLContextValueTransformerBlock)reverseBlock {
    return [[MTLContextValueTransformer alloc] initWithForwardBlock:forwardBlock reverseBlock:reverseBlock];
}

- (id)initWithForwardBlock:(MTLContextValueTransformerBlock)forwardBlock reverseBlock:(MTLContextValueTransformerBlock)reverseBlock {
    NSParameterAssert(forwardBlock != nil);

    self = [super init];
    if (self == nil) return nil;

    _forwardBlock = [forwardBlock copy];
    _reverseBlock = [reverseBlock copy];

    return self;
}

#pragma mark NSValueTransformer

+ (BOOL)allowsReverseTransformation {
    return NO;
}

+ (Class)transformedValueClass {
    return NSObject.class;
}

- (id)transformedValue:(id)value {
    NSError *error = nil;
    BOOL success = YES;

    return self.forwardBlock(value, self.context, &success, &error);
}

- (id)transformedValue:(id)value success:(BOOL *)outerSuccess error:(NSError **)outerError {
    NSError *error = nil;
    BOOL success = YES;

    id transformedValue = self.forwardBlock(value,self.context, &success, &error);

    if (outerSuccess != NULL) *outerSuccess = success;
    if (outerError != NULL) *outerError = error;

    return transformedValue;
}

@end

@implementation ZERReversibleValueTransformer

#pragma mark Lifecycle

- (id)initWithForwardBlock:(MTLContextValueTransformerBlock)forwardBlock reverseBlock:(MTLContextValueTransformerBlock)reverseBlock {
    NSParameterAssert(reverseBlock != nil);
    return [super initWithForwardBlock:forwardBlock reverseBlock:reverseBlock];
}

#pragma mark NSValueTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)reverseTransformedValue:(id)value {
    NSError *error = nil;
    BOOL success = YES;

    return self.reverseBlock(value, self.context, &success, &error);
}

- (id)reverseTransformedValue:(id)value success:(BOOL *)outerSuccess error:(NSError **)outerError {
    NSError *error = nil;
    BOOL success = YES;

    id transformedValue = self.reverseBlock(value, self.context, &success, &error);

    if (outerSuccess != NULL) *outerSuccess = success;
    if (outerError != NULL) *outerError = error;

    return transformedValue;
}

@end
