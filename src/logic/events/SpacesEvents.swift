import Cocoa

class SpacesEvents {
    static func observe() {
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.activeSpaceDidChangeNotification, object: nil, queue: nil, using: { notification in
            logger.d(notification.name)
            Spaces.refreshAllIdsAndIndexes()
            Spaces.updateCurrentSpace()
            // if UI was kept open during Space transition, the Spaces may be obsolete; we refresh them
            Windows.list.forEachAsync { $0.updatesWindowSpace() }
            // from macos 12.2 beta onwards, we can't get other-space windows; grabbing windows when switching spaces mitigates the issue
            // also, updating windows on Space transition works around an issue with Safari where its fullscreen windows spawn not in fullscreen.
            // resize/move events happen and the window is still not fullscreen. AltTab doesn't get informed that the window is later fullscreen.
            // updating on Space change helps correct the window to being fullscreen
            Applications.manuallyUpdateWindows()
        })
    }
}