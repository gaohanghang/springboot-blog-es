package com.imooc.entity.mysql;

import lombok.Data;

import javax.persistence.*;
import java.util.Date;

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
    private Integer id;
    private String title;
    private String author;
    @Column(columnDefinition = "mediumtext")
    private String content;
    private Date createTime;
    private Date updateTime;


}
