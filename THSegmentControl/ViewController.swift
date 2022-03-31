//
//  ViewController.swift
//  THSegmentControl
//
//  Created by TAEHUN YU on 2021/06/03.
//

import UIKit

class ViewController: UIViewController, THSegmentControlDelegate {
    
    @IBOutlet weak var segmentControl: THSegmentControl!
    @IBOutlet weak var containerView: UIView!
    
    lazy var pageController: UIPageViewController = {
        var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.view.backgroundColor = .yellow
        return pageController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController.view.frame = containerView.frame
        containerView.addSubview(pageController.view)
//
        let name = ["첫번째", "두번째", "세번째", "네번째"]

        segmentControl.delegate = self
        segmentControl.configure(name, font: UIFont.systemFont(ofSize: 16, weight: .heavy))
    }
    
    func thSegmentControl(_ segmentControl: UIView, index: Int, menu: String) {
        print(segmentControl, index, menu)
    }
}

