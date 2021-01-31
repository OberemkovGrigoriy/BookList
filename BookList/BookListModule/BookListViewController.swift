//
//  BookListViewController.swift
//  BookList
//
//  Created by Gregory Oberemkov on 26.01.2021.
//

import UIKit
import SnapKit

final class BookListViewController: UIViewController {
    typealias BookCoverLoadCompletion = (UIImage, UUID) -> Void
    static let cellReuseIdentifier = "BookTableViewCell"

    private let activityIndicator = UIActivityIndicatorView()
    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let errorTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Something went wrong, \n please try again!"
        label.numberOfLines = 2
        return label
    }()

    private let errorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try again", for: .normal)
        button.addTarget(self, action:#selector(reloadFirstPage), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    private let errorStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()

    private let footerSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: UIScreen.main.bounds.width, height: CGFloat(50))
        spinner.isHidden = true
        return spinner
    }()

    private let header = BookListHeaderView()
    private let viewModel = BookListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.setupView()
        self.viewModel.delegate = self
        self.viewModel.downloadBooks()
    }

    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.errorStack.isHidden = true
        self.activityIndicator.startAnimating()
        self.tableView.isHidden = true
        self.footerSpinner.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(BookTableViewCell.self, forCellReuseIdentifier: Self.cellReuseIdentifier)
    }

    @objc private func reloadFirstPage() {
        self.tableView.isHidden = true
        self.errorStack.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.viewModel.downloadBooks()
    }
    
    private func setupLayout() {
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.view.addSubview(self.errorStack)
        self.errorStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.errorStack.addArrangedSubview(errorTitle)
        self.errorStack.addArrangedSubview(errorButton)
    }
}

// MARK: - BookListViewModelDelegate

extension BookListViewController: BookListViewModelDelegate {
    func reloadTableView() {
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.tableView.isHidden = false
        self.errorStack.isHidden = true
        self.tableView.tableFooterView = nil
        self.footerSpinner.isHidden = true
    }

    func showErrorState() {
        self.errorStack.isHidden = false
        self.activityIndicator.isHidden = true
        self.tableView.isHidden = true
    }
}

// MARK: - UITableViewDataSource

extension BookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier) as! BookTableViewCell
        let model = self.viewModel.getElement(atIndex: indexPath.row)
        
        let bookCoverCompletion: BookCoverLoadCompletion = { image, id in
            cell.setImage(image: image, id: id)
        }
        cell.updateWithModel(model: model)
        self.viewModel.loadBookCover(url: model.url, id: model.id, completion: bookCoverCompletion)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BookListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 100) {
            self.tableView.tableFooterView = footerSpinner
            self.footerSpinner.isHidden = false
            self.footerSpinner.startAnimating()
            self.viewModel.downloadBooks()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
