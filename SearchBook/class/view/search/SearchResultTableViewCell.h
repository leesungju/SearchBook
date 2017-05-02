//
//  SearchResultTableViewCell.h
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kCellType_myBook,
    kCellType_fav,
    kCellType_none
} kCellType;

@protocol SearchResultTableViewCellDelegate <NSObject>
@optional
- (void)favBtnClick:(NSDictionary*)dict;
@end


@interface SearchResultTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bookImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *etcLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyBtn;
@property (strong, nonatomic) IBOutlet UIButton *favBtn;

@property (strong, nonatomic) NSString * buyLink;
@property (strong, nonatomic) NSDictionary * object;
@property (assign, nonatomic) BOOL isGoogle;
@property (assign, nonatomic) BOOL isFavSelected;
@property (assign, nonatomic) kCellType cellType;

@property (nonatomic, retain) id<SearchResultTableViewCellDelegate> delegate;

@end
