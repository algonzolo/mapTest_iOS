//
//  SearchInputView.swift
//  eLegionTest
//
//  Created by Albert Garipov on 16.03.2023.
//

import UIKit
import MapKit

enum ExpansionState {
    case notExpanded
    case partiallyExpanded
    case fullyExpanded
}

protocol SearchInputViewDelegate {
    func hideCenterMapButton(hideButton: Bool)
    func selectedPerson(person: Person)
}

final class SearchInputView: UIView {

    // MARK: - Properties

    var data = [Person]() {
        didSet {
            tableView.reloadData()
        }
    }

    var userLocation: CLLocation? {
        didSet {
            tableView.reloadData()
        }
    }

    private let reuseIdentifier = "SearchCell"
    private var tableView: UITableView!
    private var expansionState: ExpansionState!
    var selectedRows = Set<IndexPath>()
    var delegate: SearchInputViewDelegate?

    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5
        view.alpha = 0.8
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        expansionState = .notExpanded
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleSwipeGesture(sender: UISwipeGestureRecognizer) {

        if sender.direction == .up {
            if expansionState == .notExpanded {
                delegate?.hideCenterMapButton(hideButton: false)
                animateInputView(targetPosition: self.frame.origin.y - 300) { (_) in
                    self.expansionState = .partiallyExpanded
                }
            }

            if expansionState == .partiallyExpanded {
                delegate?.hideCenterMapButton(hideButton: true)
                animateInputView(targetPosition: self.frame.origin.y - 400) { (_) in
                    self.expansionState = .fullyExpanded
                }
            }
        } else {

            if expansionState == .fullyExpanded {
                animateInputView(targetPosition: self.frame.origin.y + 400) { (_) in
                    self.delegate?.hideCenterMapButton(hideButton: false)
                    self.expansionState = .partiallyExpanded

                }
            }

            if expansionState == .partiallyExpanded {
                delegate?.hideCenterMapButton(hideButton: false)
                animateInputView(targetPosition: self.frame.origin.y + 300) { (_) in
                    self.expansionState = .notExpanded
                }
            }
        }
    }

    // MARK: - Helper Functions

    func animateInputView(targetPosition: CGFloat, completion: @escaping(Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { self.frame.origin.y = targetPosition}, completion: completion)
    }

    func configureViewComponents() {
        backgroundColor = .white

        addSubview(indicatorView)
        indicatorView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 8)
        indicatorView.centerX(inView: self)

        configureTableView()
        configureGestureRecognizers()
    }

    func configureTableView() {
        tableView = UITableView()
        tableView.rowHeight = 72
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        addSubview(tableView)
        tableView.anchor(top: indicatorView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 0)
    }

    func configureGestureRecognizers() {

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeUp.direction = .up
        addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
}

// MARK: - UITableViewDataSource/Delegate

extension SearchInputView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchCell

        let pin = data[indexPath.row]

        if let userLocation = userLocation {
            cell.pinDistanceLabel.text = DistanceHelper.distanceFrom(location: CLLocation(latitude: pin.latitude, longitude: pin.longitude), userLocation: userLocation)
        }

        cell.pinTitleLabel.text = pin.name
        cell.pinImageView.image = UIImage(named: pin.avatar!)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let itemToMove = data[indexPath.row]
        data.remove(at: indexPath.row)
        data.insert(itemToMove, at: 0)
        let destinationindexPath = NSIndexPath(row: 0, section: indexPath.section)
        tableView.moveRow(at: indexPath, to: destinationindexPath as IndexPath)

        delegate?.selectedPerson(person: itemToMove)

        //tableView.reloadData()
    }
}
