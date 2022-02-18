//
//  ViewController.swift
//  MVPExample
//
//  Created by minmin on 2022/02/01.
//

import UIKit

class UsersViewController: UIViewController {

    // MARK: - Properties

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private var users = [User]()

    private let presenter = UserPresenter()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurePresenter()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    // MARK: - Presenter

    private func configurePresenter() {
        presenter.setViewDelegate(delegate: self)
        presenter.getUsers()
    }

    // MARK: - Helper

    private func configureUI() {
        title = "Users"
        configureTableVIew()
    }

    private func configureTableVIew() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource


extension UsersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTap(user: users[indexPath.row])
    }
}

// MARK: - UserPresentDelegate

extension UsersViewController: UserPresentDelegate {

    func presentUsers(users: [User]) {
        self.users = users
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
