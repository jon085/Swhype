//
//  MainConentView.swift
//  Swhype
//
//  Created by Jono on 17.02.19.
//  Copyright © 2019 Jono. All rights reserved.
//

import UIKit

class SwhypeContentView: UIView {

    @IBOutlet weak var mainImage: UIImageView!
    
    private var currentImageIndex: Int = 0
    private var imageCollection: [UIImage]?
    private var swipedRight: Bool = false
    private var selectionMade: Bool = false

    let growthToShrinkAtEdgePercentage: CGFloat = 40.0 //Scale for shrinkage to passing the side of the screen. 0 - 100 [100 shrinks at the edge, less happens after]
    let rotationPercentage: CGFloat = 60.0
    let swipeLengthToRegisterSwipe: CGFloat = 150.0
    
    private var startingCenter: CGPoint!
    private var startingTransform: CGAffineTransform!
    private var draggedX: CGFloat = 0
    
    private var swipedActionHandler: (Bool) -> Void = { _ in }
    
    private var swipeAnimationTriggered = false
    private var didCompleteSwipeAnimation = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func didMoveToSuperview() {
        panGesture()
        tapGesture()
        setupTestData()
        
        var mainView: UIView = self
        ConstraintHelper.takeOwner(alterView: &mainView)
    }
    
    func setActionResponder(swipeHandler: @escaping (Bool) -> Void = { _ in }) {
        self.swipedActionHandler = swipeHandler
    }
    
    func setupTestData() {
        imageCollection = []
        imageCollection?.append(UIImage(named: "cuterabbit")!)
        imageCollection?.append(UIImage(named: "dogcup")!)
        imageCollection?.append(UIImage(named: "piratebox")!)
        imageCollection?.append(UIImage(named: "unicorn")!)
    }
    
    class func create() -> SwhypeContentView {
        let nib = UINib(nibName: "SwhypeContentView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? SwhypeContentView

        return view!
    }
    
    private func panGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(imagePanGestureHandler(_:)))
        mainImage.isUserInteractionEnabled = true
        mainImage.addGestureRecognizer(panGesture)
    }
    
    private func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapGestureHandler(_:)))
        mainImage.isUserInteractionEnabled = true
        mainImage.addGestureRecognizer(tapGesture)
    }

    @objc private func imageTapGestureHandler(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizer.State.recognized
        {
//            print(recognizer.location(in: recognizer.view))
            handleTapPostition(tapGesture: recognizer)
        }
    }
    
    @objc private func imagePanGestureHandler(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let moveView = gesture.view!
        
        if gesture.state == .began {
            startingCenter = moveView.center
            startingTransform = moveView.transform
            draggedX = moveView.center.x
        } else if gesture.state == .ended {
            if !selectionMade {
                UIView.animate(withDuration: 0.3) {
                    moveView.center = self.startingCenter
                    moveView.transform = self.startingTransform
                }
            } else {
                swipeOff(swipeRight: swipedRight)
            }
        }
        
        if gesture.state == .changed {
            draggedX += translation.x
            
            let swipeDistance = draggedX - startingCenter.x
            
            moveView.center = CGPoint(x: moveView.center.x + translation.x, y: moveView.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self)
            
            let scrRefWidth = UIScreen.main.bounds.width

            let maxShrinkThreshold = scrRefWidth / ((CGFloat(growthToShrinkAtEdgePercentage / 100.0) * 2.0))
            let scaleMeasure = 1 - abs(swipeDistance) / maxShrinkThreshold
            
            let maxRotateThreshold = scrRefWidth / ((CGFloat(rotationPercentage / 100.0) * CGFloat.pi))
            let rotateMeasure = swipeDistance / maxRotateThreshold
            
            var transformation = CGAffineTransform.identity
            transformation = transformation.rotated(by: rotateMeasure)
            transformation = transformation.scaledBy(x: scaleMeasure, y: scaleMeasure)

            moveView.transform = transformation
            
            if swipeDistance > swipeLengthToRegisterSwipe {
                selectionMade = true
                swipedRight = true
            } else if swipeDistance < -swipeLengthToRegisterSwipe {
                selectionMade = true
                swipedRight = false
            }
        }
    }
    
    private func handleTapPostition(tapGesture: UITapGestureRecognizer) {
        guard let tappedView = tapGesture.view else { return }
        let position = tapGesture.location(in: tappedView)
        
        if position.x < tappedView.frame.size.width / 2 {
            print("Pressed Left")
            previousImage()
        } else {
            print("Pressed Right")
            nextImage()
        }
    }

    func previousImage() {
        
        guard let count = imageCollection?.count, count > 0 else { return }
        
        currentImageIndex -= 1
        if currentImageIndex < 0 {
            currentImageIndex = 0
        }
        
        mainImage.image = imageCollection?[currentImageIndex]
        
        print("P-CurrIndx: \(currentImageIndex)")
    }
    
    func nextImage() {
        guard let count = imageCollection?.count, count > 0 else { return }
        currentImageIndex += 1
        if currentImageIndex >= count {
            currentImageIndex = count - 1
        }
        
            mainImage.image = imageCollection?[currentImageIndex]
        
        print("N-CurrIndx: \(currentImageIndex)")
    }

    func swipeOff(swipeRight: Bool) {
        var currentPlacement = mainImage.frame
        let outsidePosition = UIScreen.main.bounds.size.width + 100
        currentPlacement.origin.x = swipeRight ? outsidePosition : -outsidePosition
        
        if !swipeAnimationTriggered && !didCompleteSwipeAnimation {
            swipeAnimationTriggered = true
            didCompleteSwipeAnimation = false
        } else if swipeAnimationTriggered && !didCompleteSwipeAnimation {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.mainImage.frame = currentPlacement
        }) { completed in
            self.didCompleteSwipeAnimation = completed
            self.swipeAnimationTriggered = false
            
            print("Completed Off screen animation")
            self.removeFromSuperview()
            self.swipedActionHandler(swipeRight)
        }
    }
}
