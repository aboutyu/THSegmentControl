//
//  THPageControl.swift
//  THSegmentControl
//
//  Created by TAEHUN YU on 2022/04/05.
//

import UIKit

protocol THPageControlDelegate {
    func thPageControl(_ pageControl: UIView, index: Int)
}

class THPageControl: UIView {
    
    lazy var pageViewController: UIPageViewController = {
        var pageController = UIPageViewController()
        pageController = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: nil)
        pageController.view.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.frame.width,
                                           height: self.frame.height)
        pageController.view.backgroundColor = .clear
        
        return pageController
    }()
    
    // 메뉴를 갱신할 때 item과 startedItem에 대한 세팅은 필요하기 때문에 갱신할 때 받는다.
    private var items: [UIViewController] = []
    private var startedItem: Int = 0
    private var target = UIViewController()
    
    private var selectedItem: Int = 0
    
    var delegate: THPageControlDelegate?
    var animation: Bool = false
    var scrolled: Bool = false
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    private func setupUI() {
        self.addSubview(self.pageViewController.view)
        
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        self.pageViewController.view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.pageViewController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.pageViewController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.pageViewController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        self.pageViewController.setViewControllers([items[startedItem]], direction: .forward, animated: true, completion: nil)
        self.pageViewController.didMove(toParent: target)
        
        for pageView in self.pageViewController.view.subviews {
            if let scrollView = pageView as? UIScrollView {
                scrollView.isScrollEnabled = self.scrolled
            }
        }
    }
    
    private func setTagIndex() {
        var i: Int = 0
        for _ in self.items {
            self.items[i].view.tag = i
            i += 1
        }
    }
    
    func configure(_ target: UIViewController, items: [UIViewController], startedView: Int = 0) {
        self.items.removeAll()
        self.items = items
        self.startedItem = startedView
        self.selectedItem = self.startedItem
        self.target = target
        
        self.setTagIndex()
        self.setupUI()
    }
    
    func moveTo(_ item: Int) {
        print(item, self.selectedItem, self.items.count)
        if (self.items.count > item) && item != self.selectedItem {
            let direction: UIPageViewController.NavigationDirection = {
                if self.selectedItem > item {
                    return .reverse
                }
                return .forward
            }()
            
            self.selectedItem = item
            self.pageViewController.setViewControllers([self.items[self.selectedItem]],
                                                       direction: direction,
                                                       animated: self.animation,
                                                       completion: nil)
        }
    }
}

extension THPageControl: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    private func getItemIndex(_ item: UIViewController?) -> Int? {
        guard let index = item else { return nil }
        return self.items.firstIndex(of: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.getItemIndex(viewController), index != 0 else { return nil }
        return items[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = items.firstIndex(of: viewController), index != (items.count - 1) else { return nil }
        return items[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if finished {
            let index = pageViewController.viewControllers!.first!.view.tag
            self.delegate?.thPageControl(self, index: index)
            self.selectedItem = index
        }
    }
}
