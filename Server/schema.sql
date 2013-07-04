create TABLE user (
    id INT AUTO_INCREMENT,
    uuid VARCHAR(64),
    name VARCHAR(64),
    sex CHAR(1),
    birthday DATE,
    lat DOUBLE,
    lng DOUBLE,
    weibo VARCHAR(64),
    weixin VARCHAR(64),
    addon TEXT,
    primary key (id)
);

create TABLE wish (
    id INT AUTO_INCREMENT,
    origin INT,
    uid INT,
    title VARCHAR(64),
    cost INT,
    created DATE,
    uptodate DATE,
    public CHAR(1),
    support INT,
    own INT,
    primary key(id)
);
