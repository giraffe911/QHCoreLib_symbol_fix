//
//  QHTableViewCellContext.h
//  QHCoreLib
//
//  Created by changtang on 2017/11/24.
//  Copyright © 2017年 TCTONY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHTableViewCellContext : NSObject

+ (instancetype)contextFrom:(UITableView *)tableView
                  indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;

// set to [NSNull null] would disable reuse
@property (nonatomic, strong) NSString *reuseIdentifier;

// any thing yout want to pass through
@property (nonatomic, strong) id _Nullable opaque;

@end

#define QHTableViewCellContextMake(_tableView, _indexPath) \
[QHTableViewCellContext contextFrom:_tableView indexPath:_indexPath]

NS_ASSUME_NONNULL_END
