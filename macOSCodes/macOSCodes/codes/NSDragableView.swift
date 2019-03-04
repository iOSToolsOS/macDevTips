//
//  SJDragableView.swift
//  iOSTools
//
//  Created by Shi Jian on 2018/11/30.
//  Copyright © 2018 shmily. All rights reserved.
//

import Cocoa

class SJDragableView: NSView {
    
    var dragDelegate : SJDragDelegate?
    
    let acceptTypes = ["png", "jpg", "jpeg"]
    let NSFilenamesPboardType = NSPasteboard.PasteboardType("NSFilenamesPboardType")
    
    let normalAlpha: CGFloat = 0
    let highlightAlpha: CGFloat = 0.2
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerForDraggedTypes([
            NSPasteboard.PasteboardType.backwardsCompatibleFileURL,
            NSPasteboard.PasteboardType(rawValue: kUTTypeItem as String)
            ])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        self.layer?.backgroundColor = NSColor(white: 1, alpha: highlightAlpha).cgColor
        let res = checkExtension(sender)
        if let aDelegate = self.dragDelegate {
            aDelegate.draggingEntered()
        }
        if res {
            return NSDragOperation.generic
        }
        return NSDragOperation()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor(white: 1, alpha: normalAlpha).cgColor
        if let aDelegate = self.dragDelegate {
            aDelegate.draggingExit()
        }
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        self.layer?.backgroundColor = NSColor(white: 1, alpha: normalAlpha).cgColor
        return true
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        var files = [URL]()
        if let board = sender.draggingPasteboard.propertyList(forType: NSFilenamesPboardType) as? NSArray {
            for path in board {
                let url = URL(fileURLWithPath: path as! String)
                let fileExtension = url.pathExtension.lowercased()
                if acceptTypes.contains(fileExtension) {
                    files.append(url)
                }
            }
        }
        
        self.dragDelegate?.draggingFileAccept(files)
        
        return true
    }
    
    func checkExtension(_ draggingInfo: NSDraggingInfo) -> Bool {
        if let board = draggingInfo.draggingPasteboard.propertyList(forType: NSFilenamesPboardType) as? NSArray {
            for path in board {
                let url = URL(fileURLWithPath: path as! String)
                let fileExtension = url.pathExtension.lowercased()
                if acceptTypes.contains(fileExtension) {
                    return true
                }
            }
        }
        return false
    }
}

protocol SJDragDelegate {
    func draggingEntered()
    func draggingExit()
    func draggingFileAccept(_ files: [URL])
}

extension SJDragDelegate {
    func draggingEntered() {}
    func draggingExit() {}
}


extension NSPasteboard.PasteboardType {
    static let backwardsCompatibleFileURL: NSPasteboard.PasteboardType = {
        if #available(OSX 10.13, *) {
            return NSPasteboard.PasteboardType.fileURL
        } else {
            return NSPasteboard.PasteboardType(kUTTypeFileURL as String)
        }
    } ()
}
