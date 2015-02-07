//
//  Feed.h
//  RSS
//
//  Created by Austin Eckman on 2/2/15.
//  Copyright (c) 2015 Austin Eckman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Feed : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;

@end
