//
//  AppDelegate.swift
//  AutoLaunchHelper
//
//  Created by David Williames on 11/1/21.
//

import Cocoa

@main
class HelperAppDelegate: NSObject {

    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

extension HelperAppDelegate: NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        
        
        let mainAppIdentifier = "com.davidwilliames.Desk-Controller"
                let runningApps = NSWorkspace.shared.runningApplications
                let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty

                if !isRunning {
                    DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.terminate), name: .killLauncher, object: mainAppIdentifier)

                    let path = Bundle.main.bundlePath as NSString
                    var components = path.pathComponents
                    components.removeLast()
                    components.removeLast()
                    components.removeLast()
                    components.append("MacOS")
                    components.append("MainApplication") //main app name

                    let newPath = NSString.path(withComponents: components)
                    
                    NSWorkspace.shared.open(URL(fileURLWithPath: newPath))
//                    NSWorkspace.shared.launchApplication(newPath)
                }
                else {
                    self.terminate()
                }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}


