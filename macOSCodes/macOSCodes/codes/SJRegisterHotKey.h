//
//  SJRegisterHotKey.h
//  iOSTools
//
//  Created by Shi Jian on 2018/11/23.
//  Copyright © 2018 shmily. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJRegisterHotKey : NSObject


/**
 * 添加全局的快捷键
 **/
+(void)addGlobalHotKey:(UInt32)keyCode control:(UInt32)control;



/**
 添加应用内快捷键
 */
+(void)addMonitorForEvent;



@end

NS_ASSUME_NONNULL_END


typedef enum : NSUInteger {
    SJGlobalKeyTypeCopy,
    SJGlobalKeyTypePaste,
    SJGlobalKeyTypeShow,
    SJGlobalKeyTypePrefer,
    SJGlobalKeyTypeQuit,
    SJGlobalKeyTypeHelp
    
} SJGlobalKeyType;
