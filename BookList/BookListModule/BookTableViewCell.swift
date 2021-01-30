//
//  BookTableViewCell.swift
//  BookList
//
//  Created by Gregory Oberemkov on 30.01.2021.
//

import UIKit

final class BookTableViewCell: UITableViewCell {
    private let bookCoverImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let bookTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let bookAuthorsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private let narratorAuthorsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private let titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private var id: UUID?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.bookCoverImageView.image = nil
    }
    func updateWithModel(model: BookSetupModel) {
        self.id = model.id
        self.bookTitle.text = model.title
        self.bookAuthorsLabel.text = "by: \(model.authors)"
        self.narratorAuthorsLabel.text = "with: \(model.narrators)"
    }

    func setImage(image: UIImage, id: UUID) {
        print("debug: no image")
      //  if self.id == id {
            print("debug: \(id)")
            self.bookCoverImageView.image = image
       // }
    }

    private func setupView() {
        self.contentView.backgroundColor = .systemBackground
        //self.separatorStyle = .none
    }

    private func setupLayout() {
        self.contentView.addSubview(bookCoverImageView)
        self.bookCoverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(self.bookCoverImageView.snp.height)
        }
        self.contentView.addSubview(titleStack)
        self.titleStack.snp.makeConstraints { make in
            make.left.equalTo(self.bookCoverImageView.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        self.titleStack.addArrangedSubview(bookTitle)
        self.bookTitle.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        self.titleStack.addArrangedSubview(bookAuthorsLabel)
        self.bookAuthorsLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        self.titleStack.addArrangedSubview(narratorAuthorsLabel)
        self.narratorAuthorsLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
}
