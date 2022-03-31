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

    override func viewDidLoad() {
        super.viewDidLoad()

        let name = ["첫번째", "두번째", "세번째"]

        segmentControl.delegate = self
        segmentControl.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        segmentControl.lineHeight = 2.0
        segmentControl.configure(name)
    }
    
    func thSegmentControl(_ segmentControl: UIView, index: Int, menu: String) {
        print(segmentControl, index, menu)
    }
}

