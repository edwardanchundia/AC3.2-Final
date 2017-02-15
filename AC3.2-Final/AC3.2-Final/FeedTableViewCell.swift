//
//  FeedTableViewCell.swift
//  AC3.2-Final
//
//  Created by Edward Anchundia on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    let feedImage = UIImageView()
    let feedComments = UITextView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(feedImage)
        self.contentView.addSubview(feedComments)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        feedImage.snp.makeConstraints({ (view) in
            view.top.equalTo(contentView.snp.top)
            view.width.equalTo(contentView.snp.width)
            view.height.equalTo(contentView.snp.width)
        })
        
        feedComments.snp.makeConstraints({ (view) in
            view.top.equalTo(feedImage.snp.bottom)
            view.width.equalTo(contentView.snp.width)
            view.height.equalTo(200)
            view.bottom.equalTo(contentView.snp.bottom)
        })
    }

}
