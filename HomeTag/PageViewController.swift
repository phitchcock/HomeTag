//
//  PageViewController.swift
//  HomeTag
//
//  Created by Peter Hitchcock on 11/19/14.
//  Copyright (c) 2014 Peter Hitchcock. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pageHeadings = ["one", "two", "three"]
    var pageImages = ["plus", "plus", "plus"]
    var pageSubHeadings = ["TagHome One", "TagHome 2", "TagHome 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let startingViewController = self.viewControllerAtIndex(0) { setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as PageContentViewController).index
        index++
        return viewControllerAtIndex(index)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as PageContentViewController).index
        index--
        return viewControllerAtIndex(index)
    }

    func viewControllerAtIndex(index: Int) -> PageContentViewController? {
        if index == NSNotFound || index < 0 || index >= pageHeadings.count {
            return nil
        }

        if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }

    /*
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
                return pageHeadings.count
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
            return pageContentViewController.index
        }
        return 0
    }
    */

    func forward(index: Int) {
        if let nextViewController = self.viewControllerAtIndex(index + 1) {
            setViewControllers([nextViewController], direction: .Forward,animated: true, completion: nil)
        }
    }


}
