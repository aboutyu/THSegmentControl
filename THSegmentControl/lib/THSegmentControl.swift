//
//  THSegmentControl.swift
//  THSegmentControl
//
//  Created by TAEHUN YU on 2022/02/15.
//

import UIKit

protocol THSegmentControlDelegate {
    func thSegmentControl(_ segmentControl: UIView, index: Int, menu: String)
}

class THSegmentControl: UIView {
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = UIColor.clear

        return collectionView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 0,
                                            height: self.lineHeight))
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .blue
        return lineView
    }()
    
    var delegate: THSegmentControlDelegate?
    private var items: [String] = []
    private var font: UIFont?
    private var spacing: CGFloat = 0.0
    private var lineHeight: CGFloat = 1.0    
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    private func setupUI() {
        self.makeCollectionView()
        self.makeBottomLine()
    }
    
    private func makeCollectionView() {
        self.addSubview(self.collectionView)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(THSegmentControlCell.self, forCellWithReuseIdentifier: "cell")
        
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
    private func makeBottomLine() {
        self.addSubview(self.lineView)
    }
    
    func configure(_ items: [String], font: UIFont? = nil, spacing: CGFloat = 0, lineHeight: CGFloat = 1.0) {
        self.setupUI()
        self.makeBottomLine()
        
        self.items.removeAll()
        self.items = items
        
        self.font = font
        self.spacing = spacing
        self.lineHeight = lineHeight
        
        self.collectionView.reloadData()
    }
}

extension THSegmentControl {
    
    private func lineWidth() -> CGFloat {
        let originWidth = self.frame.size.width / CGFloat(self.items.count)
        return originWidth - (spacing * 2)
    }
}

extension THSegmentControl: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! THSegmentControlCell
        
        cell.name = self.items[indexPath.row]
        cell.font = self.font
        cell.reload()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.size.width / CGFloat(self.items.count), height: self.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.thSegmentControl(self, index: indexPath.row, menu: items[indexPath.row])
    }
}

class THSegmentControlCell: UICollectionViewCell {
    
    lazy private var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .black
        return label
    }()
    
    var name: String = ""
    var font: UIFont?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func reload() {
        self.addSubview(nameLabel)
        self.backgroundColor = .clear
        
        self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        self.nameLabel.text = name
        
        if let font = self.font { self.nameLabel.font = font }
    }
}
