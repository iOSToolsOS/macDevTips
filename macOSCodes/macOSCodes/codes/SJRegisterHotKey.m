//
//  SJRegisterHotKey.m
//  iOSTools
//
//  Created by Shi Jian on 2018/11/23.
//  Copyright © 2018 shmily. All rights reserved.
//

#import "SJRegisterHotKey.h"

@implementation SJRegisterHotKey

OSStatus GlobalHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData) {
    EventHotKeyID hkCom;
    GetEventParameter(theEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,
                      sizeof(hkCom),NULL,&hkCom);
    int l = hkCom.id;
    switch (l) {
        case kVK_ANSI_V: //do something
            NSLog(@"kVK_ANSI_V按下");
            break;
        case kVK_ANSI_1:
            NSLog(@"kVK_ANSI_1按下");
            break;
        case kVK_ANSI_3:
            NSLog(@"kVK_ANSI_3按下");
            break;
            
    }
    return noErr;
}


/**
 * 添加全局的快捷键
 * control: cmdKey, cmdKey+controlKey, optionKey 等
 **/
+(void)addGlobalHotKey:(UInt32)keyCode control:(UInt32)control {
    EventHotKeyRef       gMyHotKeyRef;
    EventHotKeyID        gMyHotKeyID;
    EventTypeSpec        eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;
    InstallApplicationEventHandler(&GlobalHotKeyHandler,1,&eventType,NULL,NULL);
    gMyHotKeyID.signature = 'm';
    gMyHotKeyID.id = keyCode;
    
    RegisterEventHotKey(keyCode, control, gMyHotKeyID,GetApplicationEventTarget(), 0, &gMyHotKeyRef);
}


/**
 添加应用内快捷键
 */
+(void)addMonitorForEvent {
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged | NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * event) {
        NSUInteger flags = [event modifierFlags] & NSEventModifierFlagDeviceIndependentFlagsMask;
        if (flags == NSEventModifierFlagCommand) { // command + xxx
            if (event.keyCode == 43) { // ,
                // command + ,
                // 触发
            } else if (event.keyCode == 12) { // Q
                // command + Q
                // 触发
            }
        }
        return event;
    }];

}

@end
