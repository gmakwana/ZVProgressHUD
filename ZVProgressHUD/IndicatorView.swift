//
//  ZVStateView.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/13.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

public class IndicatorView: UIView {

    public enum IndicatorType {

        case error, success, warning
        case indicator(style: AnimationType)
        case progress(value: Float)
        case image(value: UIImage, dismissAtomically: Bool)
        case animation(value: [UIImage], duration: TimeInterval)
    }
    
    public enum AnimationType {
        case flat
        case native
    }
    
    var strokeWidth: CGFloat = 3.0 {
        didSet {
            flatActivityIndicatorView?.strokeWidth = strokeWidth
        }
    }
    
    var indcatorType: IndicatorType? {
        didSet {
            guard let indcator = indcatorType else { return }
            switch indcator {
            case .error, .success, .warning:
                setImageIndicatorView()
                guard let path = Bundle(for: ZVProgressHUD.self).path(forResource: "Resource", ofType: "bundle") else { break }
                let bundle = Bundle(path: path)
                guard let fileName = bundle?.path(forResource: indcator.resource, ofType: "png") else { break }
                let image = UIImage(contentsOfFile: fileName)?.withRenderingMode(.alwaysTemplate)
                imageIndicaotorView?.image = image;
                break
            case .indicator(let style):
                switch (style) {
                case .native:
                    setNativeActivityIndicatorView()
                    nativeActivityIndicatorView?.startAnimating()
                    break
                case .flat:
                    setFlatActivityIndicatorView()
                    flatActivityIndicatorView?.startAnimating()
                    break
                }
                break
            case .progress(let value):
                setProgressIndicatorView()
                progressIndicatorView?.progress = value
                break
            case .image(let value, _):
                setImageIndicatorView()
                imageIndicaotorView?.image = value
                break
            case .animation(let value, let duration):
                setImageIndicatorView()
                if value.isEmpty {
                    imageIndicaotorView?.image = nil
                } else if value.count == 1 {
                    imageIndicaotorView?.image = value[0]
                } else {
                    imageIndicaotorView?.animationImages = value
                    imageIndicaotorView?.animationDuration = duration
                    imageIndicaotorView?.startAnimating()
                }
                break
            }
        }
    }
    
    private var imageIndicaotorView: UIImageView?
    private var nativeActivityIndicatorView: UIActivityIndicatorView?
    private var flatActivityIndicatorView: ZVActivityIndicatorView?
    private var progressIndicatorView: UIProgressView?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Override

extension IndicatorView {
    
    override public var tintColor: UIColor! {
        didSet {
            imageIndicaotorView?.tintColor = tintColor
            nativeActivityIndicatorView?.color = tintColor
            flatActivityIndicatorView?.tintColor = tintColor
            progressIndicatorView?.tintColor = tintColor
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let subViewFrame = CGRect(origin: .zero, size: frame.size)
        
        imageIndicaotorView?.frame = subViewFrame
        flatActivityIndicatorView?.frame = subViewFrame
        nativeActivityIndicatorView?.frame = subViewFrame
        progressIndicatorView?.frame = subViewFrame
    }
}

// MARK: - Private Method

private extension IndicatorView {
    
    func setImageIndicatorView() {
        
        if imageIndicaotorView == nil {
            imageIndicaotorView = UIImageView(frame: .zero)
            imageIndicaotorView?.tintColor = tintColor
            imageIndicaotorView?.isUserInteractionEnabled = false
        }
        
        if imageIndicaotorView?.superview == nil {
            addSubview(imageIndicaotorView!)
        }
        
        flatActivityIndicatorView?.stopAnimating()
        flatActivityIndicatorView?.removeFromSuperview()
        nativeActivityIndicatorView?.stopAnimating()
        nativeActivityIndicatorView?.removeFromSuperview()
        progressIndicatorView?.removeFromSuperview()
    }
    
    func setProgressIndicatorView() {
        
        if progressIndicatorView == nil {
            
        }
    }
    
    private func setNativeActivityIndicatorView() {
        
        if nativeActivityIndicatorView == nil {
            nativeActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            nativeActivityIndicatorView?.color = tintColor
            nativeActivityIndicatorView?.hidesWhenStopped = true
            nativeActivityIndicatorView?.startAnimating()
        }
        
        if nativeActivityIndicatorView?.superview == nil {
            addSubview(nativeActivityIndicatorView!)
        }
        
        flatActivityIndicatorView?.stopAnimating()
        flatActivityIndicatorView?.removeFromSuperview()
        imageIndicaotorView?.stopAnimating()
        imageIndicaotorView?.removeFromSuperview()
        progressIndicatorView?.removeFromSuperview()
    }
    
    private func setFlatActivityIndicatorView() {
        
        if flatActivityIndicatorView == nil {
            flatActivityIndicatorView = ZVActivityIndicatorView()
            flatActivityIndicatorView?.tintColor = tintColor
            flatActivityIndicatorView?.hidesWhenStopped = true
            flatActivityIndicatorView?.strokeWidth = strokeWidth
            flatActivityIndicatorView?.startAnimating()
        }
        
        if flatActivityIndicatorView?.superview == nil {
            addSubview(flatActivityIndicatorView!)
        }
        
        nativeActivityIndicatorView?.stopAnimating()
        nativeActivityIndicatorView?.removeFromSuperview()
        imageIndicaotorView?.stopAnimating()
        imageIndicaotorView?.removeFromSuperview()
        progressIndicatorView?.removeFromSuperview()
    }
}

// MARK: - IndicatorView.IndicatorType

extension IndicatorView.IndicatorType {
    
    var resource: String {
        switch self {
        case .error:
            return "error"
        case .success:
            return "success"
        case .warning:
            return "warning"
        default:
            return ""
        }
    }    
}

