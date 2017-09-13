//
//  MusicSongTableViewCell.swift
//  LeJia
//
//  Created by SXB on 2017/5/17.
//  Copyright © 2017年 王嘉宁. All rights reserved.
//

import UIKit

class MusicSongTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    /** song*/
    var song: UIImage = UIImage() {
        didSet {
            self.songImageView.image = song
        }
    }
    /** title*/
    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    /** artist*/
    var artist: String = "" {
        didSet {
            self.artistLabel.text = artist
        }
    }
    
    /** song宽度*/
    var songWidth: Int = 60
    /** song左右边距*/
    var songMargin: Int = 15
    var titleFontSize: CGFloat = 17
    var artistFontSize: CGFloat = 16
    var isShowSeparatorLine: Bool = false
    
    lazy var songImageView: UIImageView = {
        let i = UIImageView()
        i.contentMode = .center
        i.image = self.song
        return i
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: CGFloat(self.titleFontSize))
        l.text = self.title
//        l.textColor = .white
        return l
    }()
    
    lazy var artistLabel: UILabel = {
        let l2 = UILabel()
        l2.font = UIFont.systemFont(ofSize: CGFloat(self.artistFontSize))
        l2.text = self.artist
//        l2.textColor = .white
        return l2
    }()
    
    lazy var separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = LJ.redDefault
        return v
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [songImageView, titleLabel, artistLabel].forEach {
            self.contentView.addSubview($0)
        }
        if isShowSeparatorLine {
            self.contentView.addSubview(separatorLine)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        songImageView.snp.makeConstraints { (make) in
            make.width.equalTo(songWidth)
            make.height.equalTo(songWidth)
            make.leading.equalToSuperview().offset(songMargin)
              //make.trailing.equalTo(titleLabel).offset(17)
            //make.trailing.equalTo(artistLabel).offset(17)
            //make.left.equalToSuperview().offset(songMargin)
            make.centerY.equalToSuperview()
            
        }
        
        titleLabel.snp.makeConstraints { (make) in
           
            make.height.equalTo(21)
//            make.width.equalTo(227)
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(songImageView).offset(77)
//            make.bottom.equalTo(artistLabel).offset(6)
            make.right.equalToSuperview().offset(-10)
        }
        
        artistLabel.snp.makeConstraints { (make) in
            make.height.equalTo(21)
//            make.width.equalTo(227)
            make.leading.equalTo(songImageView).offset(77)
            make.top.equalTo(titleLabel).offset(8 + 21)
            make.right.equalToSuperview().offset(-10)
        }
        
        
        if isShowSeparatorLine {
            separatorLine.snp.makeConstraints({ (make) in
                make.height.equalTo(0.5)
                make.bottom.equalToSuperview().offset(-0.5)
                make.left.equalToSuperview().offset(2 * songMargin + songWidth)
                make.right.equalToSuperview()
            })
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
}
