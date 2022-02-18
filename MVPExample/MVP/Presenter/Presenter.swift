//
//  Presenter.swift
//  MVPExample
//
//  Created by minmin on 2022/02/01.
//

import UIKit

protocol UserPresentDelegate: AnyObject {
    func presentUsers(users: [User])
    func presentAlert(title: String, message: String)
}

typealias PresenterDelegate = UserPresentDelegate & UIViewController

class UserPresenter {

    weak var delegate: PresenterDelegate?

    public func getUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error   in
            guard let data = data, error == nil else {
                return
            }
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                self?.delegate?.presentUsers(users: users)
            } catch {
                print(error)
            }
        }
        task.resume()
    }

    public func setViewDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }

    public func didTap(user: User) {
        let title = user.name
        let message = "\(user.name) のメールアドレスは\(user.email)、名前は\(user.username)"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
            delegate?.present(alert, animated: true)
    }

 
}
