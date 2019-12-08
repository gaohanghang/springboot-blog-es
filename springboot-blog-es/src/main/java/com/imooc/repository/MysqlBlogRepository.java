package com.imooc.repository;

import com.imooc.entity.mysql.MysqlBlog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * @author sixkery
 * @date 2019/11/24
 */
public interface MysqlBlogRepository extends JpaRepository<MysqlBlog, Integer> {

    /**
     * 创建时间倒序查询博客
     *
     * @return
     */
    @Query("select e from MysqlBlog e order by e.createTime desc ")
    List<MysqlBlog> queryAll();

    /**
     * 模糊查询
     *
     * @param keyword
     * @return
     */
    @Query("select e from MysqlBlog e where e.title like concat('%',:keyword,'%') or e.content like concat('%',:keyword,'%')")
    List<MysqlBlog> queryBlog(@Param("keyword") String keyword);

}
