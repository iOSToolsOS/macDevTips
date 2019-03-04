//
//  LaunchAtLogin.swift
//  iOSTools
//
//  Created by Shi Jian on 2019/3/4.
//  Copyright © 2019 shmily. All rights reserved.
// 开机自启动

import Cocoa



private func getLoginItems() -> LSSharedFileList? {
    let allocator = CFAllocatorGetDefault().takeRetainedValue()
    let kLoginItems = kLSSharedFileListSessionLoginItems.takeUnretainedValue()
    guard let loginItems = LSSharedFileListCreate(allocator, kLoginItems, nil) else {
        return nil
    }
    return loginItems.takeRetainedValue()
}

private func existingItem(itemUrl: URL) -> LSSharedFileListItem? {
    guard let loginItems = getLoginItems() else {
        return nil
    }
    
    var seed: UInt32 = 0
    if let currentItems = LSSharedFileListCopySnapshot(loginItems, &seed).takeRetainedValue() as? [LSSharedFileListItem] {
        for item in currentItems {
            let resolutionFlags = UInt32(kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes)
            if let cfurl = LSSharedFileListItemCopyResolvedURL(item, resolutionFlags, nil) {
                let url = cfurl.takeRetainedValue() as URL
                if itemUrl == url {
                    return item
                }
            }
            
        }
    }
    return nil
}

func setLaunchAtLogin(enabled: Bool) {
    guard let loginItems = getLoginItems() else { return }
    
    let itemUrl = Bundle.main.bundleURL
    if let item = existingItem(itemUrl: itemUrl) {
        if (!enabled) {
            LSSharedFileListItemRemove(loginItems, item)
        }
    } else {
        if (enabled) {
            LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemBeforeFirst.takeUnretainedValue(), nil, nil, itemUrl as CFURL, nil, nil)
        }
    }
}
