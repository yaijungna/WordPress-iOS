//
//  NotificationsTableViewCell.m
//  WordPress
//
//

#import "NotificationsTableViewCell.h"

@interface NotificationsTableViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *commentLabel;
@end

@implementation NotificationsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.numberOfLines = 2;
        self.textLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 19.f, 19.f)];
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.commentLabel.numberOfLines = 2;
        self.commentLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.commentLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.commentLabel];
        [self addSubview:self.iconImageView];
    }
    return self;
}

- (void)setNote:(Note *)note {
    if ( _note != note ) {
        [_note removeObserver:self forKeyPath:@"noteIconImage"];
        _note = note;
        [note addObserver:self forKeyPath:@"noteIconImage" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    self.imageView.image = note.noteIconImage;
    // make room for the icon
    self.textLabel.text = [NSString stringWithFormat:@"     %@",  note.subject];
    
    self.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"note_icon_%@", note.type]];
    
    NSLog(@"Detail: %@  %@", self.commentLabel, note.commentText);
    self.commentLabel.text = note.commentText;
    
}

- (void)prepareForReuse {
    if ([self.note isComment]) {
        self.commentLabel.hidden = NO;
    } else {
        self.commentLabel.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(7.f, 7.f, 47.f, 47.f);
    CGFloat labelWidth = self.textLabel.frame.size.width;
    [self.textLabel sizeToFit];
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 8.f;
    labelFrame.origin.y = 8.f;
    labelFrame.size.width = labelWidth;
    self.textLabel.frame = labelFrame;
    CGRect iconFrame = self.iconImageView.frame;
    iconFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 8.f;
    iconFrame.origin.y = 10.f;
    self.iconImageView.frame = iconFrame;
    
    if ([self.note isComment]) {
        CGRect commentFrame = self.textLabel.frame;
        commentFrame.origin.y = CGRectGetMaxY(commentFrame) + 5.f;
        self.commentLabel.frame = commentFrame;
        
    }

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ( [keyPath isEqualToString:@"noteIconImage"] ) {
        self.imageView.image = self.note.noteIconImage;
        [self layoutSubviews];
    }
}

@end
