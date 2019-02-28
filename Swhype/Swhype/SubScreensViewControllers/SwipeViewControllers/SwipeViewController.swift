//
//  SwipeViewController.swift
//  Swhype
//
//  Created by Jono on 17.02.19.
//  Copyright © 2019 Jono. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController {

    @IBOutlet weak var mainImageContainer: UIView!
    
    private var imageContainer: SwhypeContentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addMainSwipeView()
    }
    
    var swipeMeView: SwhypeContentView!
    
    func addMainSwipeView() {
        swipeMeView = SwhypeContentView.create()
   
        swipeMeView.setActionResponder { direction in
            self.userSwiped(swipeDirection: direction)
        }
        
        mainImageContainer.addSubview(swipeMeView)
    }

    @IBAction func selectedLeft(_ sender: Any) {
        print("No")
//        xxx.previousImage()
        swipeMeView.swipeOff(swipeRight: false)
    }
    
    @IBAction func selectedRight(_ sender: Any) {
        print("Yes")
//        xxx.nextImage()
        swipeMeView.swipeOff(swipeRight: true)
    }
    
    func userSwiped(swipeDirection: Bool) {
        print("UserSwipped -> \(swipeDirection)")
        
        swipeMeView = SwhypeContentView.create()
        
        swipeMeView.setActionResponder { direction in
            self.userSwiped(swipeDirection: direction)
        }
        
        mainImageContainer.addSubview(swipeMeView)
    }
}
