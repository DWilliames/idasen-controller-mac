//
//  AppDelegate.swift
//  Desk Controller
//
//  Created by David Williames on 10/1/21.
//

import Cocoa
import LaunchAtLogin

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        print(LaunchAtLogin.isEnabled)
        LaunchAtLogin.isEnabled = true
        print(LaunchAtLogin.isEnabled)
        
        // Don't show the icon in the Dock
        NSApp.setActivationPolicy(.accessory)
        
        // Setup the right click menu
        let statusBarMenu = NSMenu(title: "Desk Controller Menu")
        statusBarMenu.addItem(withTitle: "Launch on startup", action: nil, keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "Settings", action: nil, keyEquivalent: "")
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(withTitle: "Quit", action: #selector(quit), keyEquivalent: "")

        
        // Set the status bar icon and action
        if let button = statusBarItem.button {
            
            if let image = NSImage(named: "StatusBarButtonImage") {
                image.size = NSSize(width: 24, height: 24)
                button.image = image
            }
            
            button.menu = statusBarMenu
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.action = #selector(AppDelegate.clickedStatusItem(_:))
        }
        
        if let mainViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "ViewControllerId") as? ViewController {
            popover.contentViewController = mainViewController
        }
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let self = self, self.popover.isShown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
    }

    
    @objc func quit() {
        NSApp.terminate(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    @objc func clickedStatusItem(_ sender: NSStatusItem) {
        guard let event = NSApp.currentEvent else {
            return
        }
        
        if event.type == .rightMouseUp {
            // Right clicked
            
            // Pop up the menu programmatically
            if let button = statusBarItem.button, let menu = button.menu {
                menu.popUp(positioning: nil, at: CGPoint(x: -10, y: button.bounds.maxY + 6), in: button)
            }
            
            
            
        } else {
            // Left clicked
            
            togglePopover(sender)
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject?) {
        
        guard let button = statusBarItem.button else {
            return
        }
        
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        eventMonitor?.start()
        
        // On popover showing; force a reconnection with the Table in case the connection is lost
        if let viewController = popover.contentViewController as? ViewController {
            viewController.reconnect()
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    
}
