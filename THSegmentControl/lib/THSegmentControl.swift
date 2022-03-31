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
    
    lazy var bottomView: UIView = {
        let lineView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 0,
                                            height: self.lineHeight))
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor(red: 219 / 255, green: 218 / 255, blue: 222 / 255, alpha: 1.0)
        return lineView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 0,
                                            height: self.lineHeight))
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    // 메뉴를 갱신할 때 item과 startedItem에 대한 세팅은 필요하기 때문에 갱신할 때 받는다.
    private var items: [String] = []
    private var startedItem: Int = 0
    private var selectedItem: Int = 0
    
    // 메뉴를 갱신하더라도 처음 설정값이 변하는게 드문 경우는 메뉴 갱신할 때 파라미터로 받지 않는다.
    var delegate: THSegmentControlDelegate?
    var animation: Bool = false
    var selectedItemColor: UIColor = UIColor(red: 18 / 255, green: 39 / 255, blue: 71 / 255, alpha: 1.0)
    var diselectedItemColor: UIColor = UIColor(red: 128 / 255, green: 135 / 255, blue: 142 / 255, alpha: 1.0)
    
    var font: UIFont?
    var spacing: CGFloat = 10.0
    var lineHeight: CGFloat = 1.0
    var lineColor: UIColor = UIColor(red: 27 / 255, green: 188 / 255, blue: 255 / 255, alpha: 1.0)
    
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
    
    private func makeMenuLine() {
        self.addSubview(self.lineView)
        
        self.lineView.frame = CGRect(x: self.linePosition(num: self.startedItem),
                                     y: self.frame.size.height - (lineHeight + 1),
                                     width: self.lineWidth(),
                                     height: self.lineHeight)
        self.lineView.backgroundColor = self.lineColor
    }
    
    private func makeBottomLine() {
        self.addSubview(self.bottomView)
        
        self.bottomView.frame = CGRect(x: 0,
                                     y: self.frame.size.height - 1,
                                     width: self.frame.size.width,
                                     height: 1)
    }
    
    func configure(_ items: [String], startedItem: Int = 0) {
        self.items.removeAll()
        self.items = items
        self.selectedItem = self.startedItem
        
        self.setupUI()
        self.makeBottomLine()
        self.makeMenuLine()
        
        self.collectionView.reloadData()
    }
}

extension THSegmentControl {
    private func moveBottomLine(_ position: Int) {
        let x = linePosition(num: position)
        DispatchQueue.main.async {
            if self.animation {
                UIView.animate(withDuration: 0.3) {
                    self.moveBottomLinePosition(x)
                }
            } else {
                self.moveBottomLinePosition(x)
            }
        }
    }
    
    private func moveBottomLinePosition(_ x: CGFloat) {
        self.lineView.frame.origin.x = x
    }
    
    private func linePosition(num: Int) -> CGFloat {
        if (num >= self.items.count) || num == 0 { return self.spacing }
        
        let numToCGFloat = CGFloat(num)
        let pos = (self.spacing * (numToCGFloat * 2)) + (lineWidth() * numToCGFloat)
        return pos + (self.spacing * (numToCGFloat + 1))
    }
    
    private func lineWidth() -> CGFloat {
        return (self.frame.size.width / CGFloat(self.items.count)) - (self.spacing * 3)
    }
}

extension THSegmentControl: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    private func itemColor(_ row: Int) -> UIColor {
        return (row == self.selectedItem) ? self.selectedItemColor : self.diselectedItemColor
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! THSegmentControlCell
        let row = indexPath.row
        
        cell.name = self.items[row]
        cell.font = self.font
        cell.color = itemColor(row)
        cell.reload()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.size.width / CGFloat(self.items.count), height: self.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItem = indexPath.row
        
        self.moveBottomLine(self.selectedItem)
        self.collectionView.reloadData()
        self.delegate?.thSegmentControl(self, index: self.selectedItem, menu: items[self.selectedItem])
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
    var color: UIColor?
    
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
        if let color = self.color { self.nameLabel.textColor = color }
    }
}
