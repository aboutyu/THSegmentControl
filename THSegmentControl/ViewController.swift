//
//  ViewController.swift
//  THSegmentControl
//
//  Created by TAEHUN YU on 2021/06/03.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: THSegmentControl!
    @IBOutlet weak var pageControl: THPageControl!
    
    let name = ["first", "second", "third"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSegmentUI()
        configurePageControlUI()
    }
    
    // configure THSegmentControl
    private func configureSegmentUI() {
        segmentControl.delegate = self
        segmentControl.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        segmentControl.lineHeight = 2.0
        
        segmentControl.animation = true
        segmentControl.configure(name)
    }
    
    // configure THPageControl
    private func configurePageControlUI() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let firstVC = storyboard.instantiateViewController(withIdentifier: "FirstVC") as! FirstVC
        let secondVC = storyboard.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
        let thirdVC = storyboard.instantiateViewController(withIdentifier: "ThirdVC") as! ThirdVC
        
        pageControl.delegate = self
        pageControl.animation = true
        pageControl.scrolled = true
        pageControl.configure(self, items: [firstVC, secondVC, thirdVC])
    }
}

extension ViewController: THSegmentControlDelegate {
    func thSegmentControl(_ segmentControl: UIView, index: Int, menu: String) {
        pageControl.moveTo(index)
    }
}

extension ViewController: THPageControlDelegate {
    func thPageControl(_ pageControl: UIView, index: Int) {
        segmentControl.moveTo(index)
    }
}

