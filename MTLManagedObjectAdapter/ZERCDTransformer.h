//
//  ZERCDTransformer.h
//  Skiguide Zermatt
//
//  Created by Samuel Bichsel on 05.12.18.
//  Copyright © 2018 dreipol gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef id (^ZERValueTransformerBlock)(id value, NSManagedObjectContext *context, BOOL *success, NSError **error);

@interface ZERCDTransformer : NSValueTransformer
@property(nonatomic, strong) NSManagedObjectContext *context;
@end

NS_ASSUME_NONNULL_END
