//
//  MyPageViewController.swift
//  TestPageVC
//
//  Created by Robert Seitsinger on 10/3/16.
//  Copyright © 2016 Infinity Software. All rights reserved.
//

import UIKit

class MyPageViewController: UIPageViewController {

    // fileprivate(set) means - this property is readable throughout the module/app
    // that contains this code, but only writeable from within this file.
    // lazy means - lazy evaluation - the code isn't executed until it's referenced.
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController("Red"),
                self.newColoredViewController("Green"),
                self.newColoredViewController("Blue")]
    }()

    // Include this method to be able to programmatically choose the transition style.
    // TransitionStyle is a read-only property, so, you have to set it during object instantiation.
    // Choose between:  .scroll (default) and .pageCurl
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
//        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
//        super.init(transitionStyle: .pageCurl, navigationOrientation: .vertical, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Page Controller Demo"
        
        dataSource = self
        
        // Get the first view controller from the array of view controllers,
        // and use it to establish the initial array of view controllers
        // that will be managed by the page view controller.
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }

        // Set colors for the page control.
        // We're setting the global page control appearance object.
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.yellow
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.backgroundColor = UIColor.brown
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate func newColoredViewController(_ color: String) -> UIViewController {
        // Instantiate a view controller that is in the storyboard, using the
        // associated storyboard id - which can be set in the Identity Inspector.
        // "Main" here is the name of the storyboard file.
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(color)VC")
    }
}

// MARK: UIPageViewControllerDataSource

extension MyPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllers.count != nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }

    // A page indicator will be visible if both of the following methods are implemented, transition
    // style is 'scroll' and navigation orientation is 'horizontal'.
    //
    // Both methods are called in response to a 'setViewControllers' call, but the presentation index
    // is updated automatically in the case of gesture-driven navigation.
    
    // Return the number of items reflected in the page indicator.
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    // Returns the selected item reflected in the page indicator.
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}
