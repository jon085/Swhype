//
//  StoryboardHelper.swift
//  Swhype
//
//  Created by Jono on 17.02.19.
//  Copyright © 2019 Jono. All rights reserved.
//

import UIKit

enum StoryboardNames: String {
    case main = "Main",
         subScreens = "SubScreens"
}

enum StoryboardPageIDs: String {
    case swipeScreen = "swipeview",
         screen2 = "screen2"
}

class StoryboardHelper {
    
    //MARK: - Get the View Controllers
    public static func getViewController(storyboardID: StoryboardNames, _ viewName: StoryboardPageIDs? = nil) -> UIViewController {
        if let viewName = viewName {
            return UIStoryboard(name: storyboardID.rawValue, bundle: nil).instantiateViewController(withIdentifier: viewName.rawValue)
        } else {
            return UIStoryboard(name: storyboardID.rawValue, bundle: nil).instantiateInitialViewController()!
        }
    }

}
