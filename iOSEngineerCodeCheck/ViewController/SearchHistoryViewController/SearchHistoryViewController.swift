//
//  SearchHistoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/03.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import CoreData

final class SearchHistoryViewController: UIViewController {

    weak var delegate: SearchHistoryViewControllerDelegate?

    private let tableView = UITableView(frame: .zero, style: .plain)

    private let viewModel = SearchHistoryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureConstraints()
        configureViewModel()
        registTableViewCell()

        viewModel.populateData()
    }

    func insertSearchHistoryEntry(searchTerm: String) {
        viewModel.insertSearchHistoryEntry(searchTerm: searchTerm)
    }

    var hasHistoryEntry: Bool {
        viewModel.hasHistoryEntry
    }

    func show(animated: Bool = true) {
        view.alpha = 0
        view.isHidden = false

        if animated {
            UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseIn, animations: {
                self.view.alpha = 1
            }, completion: nil)
        } else {
            view.alpha = 1
            view.isHidden = false
        }
    }

    func hide(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseIn, animations: {
                self.view.alpha = 0
            }, completion: { _ in
                self.view.isHidden = true
                self.view.alpha = 1
            })
        } else {
            view.isHidden = true
        }
    }

    private func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 30
        tableView.layer.cornerCurve = .continuous
        tableView.rowHeight = 56
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: .zero)

        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous

        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.1
    }

    private func configureConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureViewModel() {
        viewModel.fetchedResultsControllerDelegate = self
    }

    private func configureCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryEntryCell.reuseIdentifier, for: indexPath) as? SearchHistoryEntryCell else {
            fatalError("Need SearchHistoryEntryCell registration")
        }

        let entry = viewModel.searchHistoryEntry(for: indexPath)

        cell.textLabel?.text = entry.searchTerm

        return cell
    }

    private func registTableViewCell() {
        tableView.register(SearchHistoryEntryCell.self, forCellReuseIdentifier: SearchHistoryEntryCell.reuseIdentifier)
    }

    private func handleDidSelectRow(at indexPath: IndexPath) {
        let entry = viewModel.searchHistoryEntry(for: indexPath)
        delegate?.searchHistoryViewController(self, didSelect: entry)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchHistoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchHistoryCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configureCell(for: tableView, indexPath: indexPath)
    }
}

extension SearchHistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectRow(at: indexPath)
    }
}

extension SearchHistoryViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)

        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)

        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)

        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)

        @unknown default:
            fatalError("Unknown default in \(#function)")
        }
    }
}
