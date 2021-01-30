//
//  HeaderView.swift
//  BookList
//
//  Created by Gregory Oberemkov on 26.01.2021.
//

import UIKit
import SnapKit

final class HeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = title
        return titleLabel
    }()
    private let title: String
    private var cachedMinimumSize: CGSize?
    weak var scrollView: UIScrollView?

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private var minimumHeight: CGFloat {
        get {
            guard let scrollView = scrollView else { return 0 }
            if let cachedSize = cachedMinimumSize {
                if cachedSize.width == scrollView.frame.width {
                    return cachedSize.height
                }
            }
         
            // Ask Auto Layout what the minimum height of the header should be.
            let minimumSize = systemLayoutSizeFitting(CGSize(width: scrollView.frame.width, height: 100),
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .defaultLow)
            cachedMinimumSize = minimumSize
            return  minimumSize.height
        }
    }

    func updatePosition() {
        guard let scrollView = scrollView else { return }
        
        // Calculate the minimum size the header's constraints will fit
        let minimumSize = minimumHeight
        
        // Calculate the baseline header height and vertical position
        let referenceOffset = scrollView.safeAreaInsets.top
        let referenceHeight = scrollView.contentInset.top - referenceOffset
        
        // Calculate the new frame size and position
        let offset = referenceHeight + scrollView.contentOffset.y
        let targetHeight = referenceHeight - offset - referenceOffset
        var targetOffset = referenceOffset
     //   print("\(targetHeight) and \(minimumSize)")
       // if targetHeight < minimumSize {
         //   targetOffset += targetHeight - minimumSize
            //return
        ///}
        
        // Update the header's height and vertical position.
        var headerFrame = frame;
        headerFrame.size.height = targetHeight//max(minimumSize, targetHeight)
        headerFrame.origin.y = targetOffset
        
        frame = headerFrame;
    }
}
