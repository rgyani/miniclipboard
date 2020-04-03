//
//  AppDelegate.swift
//  Clipboard
//
//  Created by Gyani, Ravi, SKY on 01.04.20.
//  Copyright © 2020 Gyani, Ravi, SKY. All rights reserved.
//

import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let popover = NSPopover()
    
    func applicationWillResignActive(_ notification: Notification) {
        print("resign active")
        closePopover(sender:notification)
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        guard let statusButton = statusBarItem.button else { return }
        statusButton.image = NSImage(named:NSImage.Name("StatusBarIcon"))
        statusButton.action = #selector(togglePopover(_:))
        popover.contentViewController = ClipboardViewController.freshController()
        
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusBarItem.button {
            //            eventMonitor?.start()
            popover.behavior = NSPopover.Behavior.transient;
            NSApp.activate(ignoringOtherApps: true)
            
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        //        eventMonitor?.stop()
        
    }
    
}

