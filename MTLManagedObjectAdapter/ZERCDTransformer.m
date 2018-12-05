//
//  ZERCDTransformer.m
//  Skiguide Zermatt
//
//  Created by Samuel Bichsel on 05.12.18.
//  Copyright © 2018 dreipol gmbh. All rights reserved.
//

#import "ZERCDTransformer.h"
@interface ZERReversibleValueTransformer : ZERCDTransformer
@end
@interface ZERCDTransformer()
@property (nonatomic, copy, readonly) ZERValueTransformerBlock forwardBlock;
@property (nonatomic, copy, readonly) ZERValueTransformerBlock reverseBlock;

@end

@implementation ZERCDTransformer

#pragma mark Lifecycle

+ (instancetype)transformerUsingForwardBlock:(ZERValueTransformerBlock)forwardBlock {
    return [[self alloc] initWithForwardBlock:forwardBlock reverseBlock:nil];
}

+ (instancetype)transformerUsingReversibleBlock:(ZERValueTransformerBlock)reversibleBlock {
    return [self transformerUsingForwardBlock:reversibleBlock reverseBlock:reversibleBlock];
}

+ (instancetype)transformerUsingForwardBlock:(ZERValueTransformerBlock)forwardBlock reverseBlock:(ZERValueTransformerBlock)reverseBlock {
    return [[ZERCDTransformer alloc] initWithForwardBlock:forwardBlock reverseBlock:reverseBlock];
}

- (id)initWithForwardBlock:(ZERValueTransformerBlock)forwardBlock reverseBlock:(ZERValueTransformerBlock)reverseBlock {
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

- (id)initWithForwardBlock:(ZERValueTransformerBlock)forwardBlock reverseBlock:(ZERValueTransformerBlock)reverseBlock {
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
