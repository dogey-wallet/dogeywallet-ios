//
//  AlertView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-22.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//

import UIKit

enum AlertType {
    case pinSet(callback: () -> Void)
    case paperKeySet(callback: () -> Void)
    case sendSuccess
    case resolvedSuccess
    case addressesCopied
    case sweepSuccess(callback: () -> Void)

    var header: String {
        switch self {
        case .pinSet:
            return S.Alerts.pinSet
        case .paperKeySet:
            return S.Alerts.paperKeySet
        case .sendSuccess:
            return S.Alerts.sendSuccess
        case .resolvedSuccess:
            return S.Alerts.resolvedSuccess
        case .addressesCopied:
            return S.Alerts.copiedAddressesHeader
        case .sweepSuccess:
            return S.Import.success
        }
    }

    var subheader: String {
        switch self {
        case .pinSet:
            return ""
        case .paperKeySet:
            return S.Alerts.paperKeySetSubheader
        case .sendSuccess:
            return S.Alerts.sendSuccessSubheader
        case .resolvedSuccess:
            return S.Alerts.resolvedSuccessSubheader
        case .addressesCopied:
            return S.Alerts.copiedAddressesSubheader
        case .sweepSuccess:
            return S.Import.successBody
        }
    }

    var icon: UIView {
        return CheckView()
    }
}

extension AlertType : Equatable {}

func ==(lhs: AlertType, rhs: AlertType) -> Bool {
    switch (lhs, rhs) {
    case (.pinSet(_), .pinSet(_)):
        return true
    case (.paperKeySet(_), .paperKeySet(_)):
        return true
    case (.sendSuccess, .sendSuccess):
        return true
    case (.resolvedSuccess, .resolvedSuccess):
            return true
    case (.addressesCopied, .addressesCopied):
        return true
    case (.sweepSuccess(_), .sweepSuccess(_)):
        return true
    default:
        return false
    }
}

class AlertView : UIView, SolidColorDrawable {

    private let type: AlertType
    private let header = UILabel()
    private let subheader = UILabel()
    private let separator = UIView()
    private let icon: UIView
    private let iconSize: CGFloat = 96.0
    private let separatorYOffset: CGFloat = 48.0

    init(type: AlertType) {
        self.type = type
        self.icon = type.icon 

        super.init(frame: .zero)
        layer.cornerRadius = 6.0
        layer.masksToBounds = true
        setupSubviews()
    }

    func animate() {
        guard let animatableIcon = icon as? AnimatableIcon else { return }
        animatableIcon.animate()
    }

    private func setupSubviews() {
        addSubview(header)
        addSubview(subheader)
        addSubview(icon)
        addSubview(separator)

        setData()
        addConstraints()
    }

    private func setData() {
        header.text = type.header
        header.textAlignment = .center
        header.font = UIFont.barlowBold(size: 16.0)
        header.textColor = .white

        icon.backgroundColor = .clear
        separator.backgroundColor = .transparentWhite

        subheader.text = type.subheader
        subheader.textAlignment = .center
        subheader.font = UIFont.barlowSemiBold(size: 16.0)
        subheader.textColor = .white
    }

    private func addConstraints() {

        //NB - In this alert view, constraints shouldn't be pinned to the bottom
        //of the view because the bottom actually extends off the bottom of the screen a bit.
        //It extends so that it still covers up the underlying view when it bounces on screen.

        header.constrainTopCorners(sidePadding: C.padding[2], topPadding: C.padding[2])
        separator.constrain([
            separator.constraint(.height, constant: 1.0),
            separator.constraint(.width, toView: self, constant: 0.0),
            separator.constraint(.top, toView: self, constant: separatorYOffset),
            separator.constraint(.leading, toView: self, constant: nil) ])
        icon.constrain([
            icon.constraint(.centerX, toView: self, constant: nil),
            icon.constraint(.centerY, toView: self, constant: nil),
            icon.constraint(.width, constant: iconSize),
            icon.constraint(.height, constant: iconSize) ])
        subheader.constrain([
            subheader.constraint(.leading, toView: self, constant: C.padding[2]),
            subheader.constraint(.trailing, toView: self, constant: -C.padding[2]),
            subheader.constraint(toBottom: icon, constant: C.padding[3]) ])
    }

    override func draw(_ rect: CGRect) {
        drawColor(color: .liteWalletBlue, rect)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
