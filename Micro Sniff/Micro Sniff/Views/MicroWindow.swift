//
//  ViewController.swift
//  MicMonitor
//
//  Created by Trung Phan on 2/17/20.
//  Copyright © 2020 Dwarvesf. All rights reserved.
//

import Cocoa

class MicroWindow: NSWindow {
    
    static let microViewWidth: CGFloat = 100
    static let hPadding:CGFloat = 10
    static let vPadding:CGFloat = 50
    static let statusBarHeight: CGFloat = 22
    
    typealias MicTitle = String
    var micTitle: ((MicTitle)->())? = nil
    
    var lastLocationInScreen: NSPoint = .zero
    
    class func initForMainScreen() -> MicroWindow? {
        guard let screen = NSScreen.main else {return nil}
        
        let screenRect = screen.frame
        
        let frame = NSRect(origin: CGPoint(x: screenRect.size.width - hPadding - microViewWidth, y: screenRect.height - vPadding - microViewWidth - statusBarHeight), size: CGSize(width: microViewWidth, height: microViewWidth))
        
        let overlayWindow = MicroWindow(contentRect: frame, styleMask: [.borderless], backing: .buffered, defer: false, screen: screen)
        overlayWindow.backgroundColor = .clear
        overlayWindow.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        overlayWindow.level = .mainMenu
        overlayWindow.order(.above, relativeTo: 0)
        overlayWindow.isReleasedWhenClosed = false
        overlayWindow.titleVisibility = .hidden
        overlayWindow.styleMask.remove(.titled)
        overlayWindow.displaysWhenScreenProfileChanges = true
        let visualEffect = NSVisualEffectView()
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.material = .light
        visualEffect.state = .active
        visualEffect.wantsLayer = true
        visualEffect.layer?.backgroundColor = .clear
        visualEffect.layer?.cornerRadius = 10.0
        
        overlayWindow.contentView?.addSubview(visualEffect)

        guard let constraints = overlayWindow.contentView else { return nil }
        
        NSLayoutConstraint.activate([
            visualEffect.leadingAnchor.constraint(equalTo: constraints.leadingAnchor),
            visualEffect.trailingAnchor.constraint(equalTo: constraints.trailingAnchor),
            visualEffect.topAnchor.constraint(equalTo: constraints.topAnchor),
            visualEffect.bottomAnchor.constraint(equalTo: constraints.bottomAnchor)
        ])
        
        let micTitleLabel = NSTextField()
        micTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        micTitleLabel.isBezeled = false
        micTitleLabel.drawsBackground = false
        micTitleLabel.isEditable = false
        micTitleLabel.alignment = .center
        micTitleLabel.alphaValue = 0.3
        overlayWindow.micTitle = {[weak micTitleLabel] micTitle in
            micTitleLabel?.stringValue = micTitle
        }
        visualEffect.addSubview(micTitleLabel)
        
        let imageView = CustomIconAnimationView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        visualEffect.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: visualEffect.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: visualEffect.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: visualEffect.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            micTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: visualEffect.topAnchor, constant: 10),
            micTitleLabel.centerXAnchor.constraint(equalTo: visualEffect.centerXAnchor),
            micTitleLabel.bottomAnchor.constraint(equalTo: visualEffect.bottomAnchor, constant: -10),
            micTitleLabel.widthAnchor.constraint(equalToConstant: microViewWidth)
        ])
        
        return overlayWindow
    }
    
    func openWithAnimation() {
        self.makeKeyAndOrderFront(nil)
        self.alphaValue = 0
        NSAnimationContext.runAnimationGroup({ _ in
            NSAnimationContext.current.duration = 0.5
            self.animator().alphaValue = 1
        })
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        // Set closehand cursor
        self.contentView?.addCursorRect(self.frame, cursor: .closedHand)
        let closedHand = NSCursor.closedHand
        closedHand.set()
        
        self.lastLocationInScreen = self.convertPoint(toScreen: event.locationInWindow)
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDown(with: event)
        
        let newDragLocation = self.convertPoint(toScreen: event.locationInWindow)
        var thisOrigin = self.frame.origin
        thisOrigin.x += -self.lastLocationInScreen.x + newDragLocation.x
        thisOrigin.y += -self.lastLocationInScreen.y + newDragLocation.y
        self.setFrameOrigin(thisOrigin)
        self.lastLocationInScreen = newDragLocation
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        // Set arrow cursor
        let arrow = NSCursor.arrow
        arrow.set()
        
        let newDragLocation = self.convertPoint(toScreen: event.locationInWindow)
        var thisOrigin = self.frame.origin
        thisOrigin.x += -self.lastLocationInScreen.x + newDragLocation.x
        thisOrigin.y += -self.lastLocationInScreen.y + newDragLocation.y
        
        relocationToNearestEdge(lastLocationInScreen: thisOrigin)
    }
    
    private func relocationToNearestEdge(lastLocationInScreen: NSPoint) {
        //Check current point and auto move to left or right edge
        
        guard  let screen = self.screen else {return}

        
        let screenLeading = screen.frame.minX
        let screenTrailing = screen.frame.maxX
        let screenTop = screen.frame.maxY
        let screenBottom = screen.frame.minY
        
        let screenHCenter = screen.frame.midX

        
        let leadingX = Self.hPadding + screenLeading
        let trailingX = screenTrailing - Self.hPadding - Self.microViewWidth
        
        var yPosition = lastLocationInScreen.y
        var xPosition = lastLocationInScreen.x
        
        if xPosition >= screenHCenter {
            xPosition = trailingX
        } else {
            xPosition = leadingX
        }
        
        let paddingTop = screenTop - Self.microViewWidth - Self.statusBarHeight
        if yPosition > paddingTop {
            yPosition = screenTop - Self.vPadding - Self.microViewWidth - Self.statusBarHeight
        } else if yPosition < screenBottom + Self.vPadding {
            yPosition = screenBottom + Self.vPadding
        }
        
        let finalPosition = NSPoint(x: xPosition, y: yPosition)
        
        self.setFrame(NSRect(origin: finalPosition, size: CGSize(width: Self.microViewWidth, height: Self.microViewWidth)), display: true, animate: true)
    }
    
}

class CustomIconAnimationView: NSView {
    
    private var imageView: NSImageView!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.opacityAnimation()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.imageView = NSImageView(image: #imageLiteral(resourceName: "ico_overlay_mic"))
        self.imageView.imageScaling = .scaleProportionallyUpOrDown
        self.imageView.alphaValue = 1
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    func opacityAnimation() {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values     = [0, 0.7, 0.3, 0.5, 0.3, 0.8, 1, 0.5, 0.3, 1]
        opacityAnimation.keyTimes   = [0, 0.3, 0.4, 0.5, 0.6, 0.7, 1, 1.2, 1.4, 2]
        opacityAnimation.duration = 2
        opacityAnimation.repeatDuration = .infinity
        opacityAnimation.autoreverses = true
        
        self.imageView.layer?.add(opacityAnimation, forKey: "image.opacity")
    }
}
