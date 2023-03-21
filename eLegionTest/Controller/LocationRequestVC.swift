//
//  LocationRequestVC.swift
//  eLegionTest
//
//  Created by Albert Garipov on 21.03.2023.
//

import UIKit

final class LocationRequestVC: UIViewController {

    // MARK: - Properties

    private let allowLocationLabel: UILabel = {
        let label = UILabel()

        let attributedText = NSMutableAttributedString(string: "Allow Location\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])

        attributedText.append(NSAttributedString(string: "Please enable location services so that we can track your movements", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]))

        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedText

        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
    }

    // MARK: - Helper Functions

    func configureViewComponents() {
        view.backgroundColor = .white
        view.addSubview(allowLocationLabel)
        allowLocationLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
        allowLocationLabel.centerX(inView: view)
    }
}
