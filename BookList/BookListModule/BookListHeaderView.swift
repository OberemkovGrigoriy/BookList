//
//  BookListHeaderView.swift
//  BookList
//
//  Created by Gregory Oberemkov on 31.01.2021.
//

import UIKit

final class BookListHeaderView: UIView {
    private let title: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        title.numberOfLines = 0
        title.text = "Query: Harry"
        return title
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(title)
        self.title.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
}
