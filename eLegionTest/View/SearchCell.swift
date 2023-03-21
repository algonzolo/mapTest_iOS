//
//  SearchCell.swift
//  eLegionTest
//
//  Created by Albert Garipov on 16.03.2023.
//

import UIKit
import MapKit

final class SearchCell: UITableViewCell {

    // MARK: - Properties
    
    let pinImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let pinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    let pinDistanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        addSubview(pinImageView)
        let dimension: CGFloat = 50
        pinImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: dimension, height: dimension)
        pinImageView.layer.cornerRadius = dimension / 2
        pinImageView.clipsToBounds = true
        pinImageView.centerY(inView: self)

        addSubview(pinTitleLabel)
        pinTitleLabel.anchor(top: pinImageView.topAnchor, left: pinImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        addSubview(pinDistanceLabel)
        pinDistanceLabel.anchor(top: nil, left: pinImageView.rightAnchor, bottom: pinImageView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
