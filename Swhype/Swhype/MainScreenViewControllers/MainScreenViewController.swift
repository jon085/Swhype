//
//  ViewController.swift
//  Swhype
//
//  Created by Jono on 17.02.19.
//  Copyright © 2019 Jono. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    private var pageViewController: MainScreenPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MainScreenPageViewController {
            pageViewController = segue.destination as? MainScreenPageViewController
//            pageViewController?.mainScreenOwner = self
        }
    }

    @IBAction func tabButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("Settings")
            pageViewController?.navigateTo(index: .screenSettings)
        case 1:
            print("Main")
            pageViewController?.navigateTo(index: .screenMain)
        case 2:
            print("Results")
            pageViewController?.navigateTo(index: .screenResults)
        default:
            break
        }
    }
    
}

