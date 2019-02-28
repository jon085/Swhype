//
//  MainScreenPageViewController.swift
//  Swhype
//
//  Created by Jono on 17.02.19.
//  Copyright © 2019 Jono. All rights reserved.
//

import UIKit

internal enum ScreenTransitions: Int {
    case screenSettings = 0,
        screenMain = 1,
        screenResults = 2
}

class MainScreenPageViewController: UIPageViewController {

    private var viewControllerCollection: [UIViewController]?
    private var currentViewIndex = 0//, lastViewIndex = 0
//    var mainScreenOwner: MainScreenViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViewControllers()
        dataSource = self
        delegate = self
        setFirstView()
        //        disablePageViewScrolling()
    }
    
    func loadViewControllers() {
        let view0 = UIViewController() //StoryboardHelper.getViewController(storyboardID: StoryboardNames.subScreens, StoryboardPageIDs.swipeScreen)
        let view1 = StoryboardHelper.getViewController(storyboardID: StoryboardNames.subScreens, StoryboardPageIDs.swipeScreen)
        let view2 = StoryboardHelper.getViewController(storyboardID: StoryboardNames.subScreens, StoryboardPageIDs.screen2)

        viewControllerCollection = [view0, view1, view2]
    }

    func setFirstView() {
        navigateTo(index: .screenMain)
    }

    //MARK: - Visual Functions
    func disablePageViewScrolling() {
        if let scrollView = self.view.subviews.filter({$0.isKind(of: UIScrollView.self)}).first as? UIScrollView {
            scrollView.isScrollEnabled = false
        }
    }
    
    //MARK: - Navigation / Page View Transition
    func navigateTo(index: ScreenTransitions) {
        let moveForward = currentViewIndex < index.rawValue
        currentViewIndex = index.rawValue
        
        setView(viewControllerCollection![index.rawValue], moveForward: moveForward)
    }

    private func setView(_ viewControl: UIViewController, moveForward: Bool) {
        guard let _ = viewControllerCollection else { return }
            setViewControllers([viewControl],
                               direction: moveForward ? .forward : .reverse,
                               animated: true,
                               completion: nil)
    }
}

extension MainScreenPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerCollection!.firstIndex(of: viewController) else {
            return nil
        }
        
        let prevIndex = viewControllerIndex - 1

        guard prevIndex >= 0 else {
            return nil // viewControllerCollection!.count > 1 ? viewControllerCollection?.last : nil
        }
        
        guard viewControllerCollection!.count > prevIndex else {
            return nil
        }

        return viewControllerCollection?[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = viewControllerCollection!.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard viewControllerCollection!.count != nextIndex else {
            return nil //viewControllerCollection!.count > 1 ? viewControllerCollection?.first : nil
        }
        
        guard viewControllerCollection!.count > nextIndex else {
            return nil
        }

        return viewControllerCollection?[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let nextView = pendingViewControllers.first, let index = viewControllerCollection?.firstIndex(of: nextView) {
//            mainScreenOwner?.selectSegment(segIndex: index)
            currentViewIndex = index
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
//        if let previousView = previousViewControllers.first, let index = viewControllerCollection?.firstIndex(of: previousView) {
////            mainScreenOwner?.selectSegment(segIndex: index)
////            lastViewIndex = index
//        }
    }
}
