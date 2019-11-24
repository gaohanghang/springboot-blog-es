package com.sixkery.entity.mysql;

import lombok.Data;

import javax.persistence.*;

/**
 * @author sixkery
 * @date 2019/11/24
 */
@Data
@Table(name = "t_blog")
@Entity
public class MysqlBlog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private String id;
    private String title;
    private String author;
    @Column(columnDefinition = "mediumtext")
    private String content;
    private String createTime;
    private String updateTime;


}
