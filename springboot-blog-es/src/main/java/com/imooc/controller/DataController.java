package com.imooc.controller;

import com.imooc.entity.es.EsBlog;
import com.imooc.entity.mysql.MysqlBlog;
import com.imooc.repository.EsBlogRepository;
import com.imooc.repository.MysqlBlogRepository;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.util.StopWatch;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * @author sixkery
 * @date 2019/11/24
 */
@RestController
@Slf4j
public class DataController {

    private static final String MYSQL = "mysql";
    private static final String ES = "es";

    @Autowired
    MysqlBlogRepository mysqlBlogRepository;

    @Autowired
    EsBlogRepository esBlogRepository;

    @GetMapping("/blogs")
    public Object blogList() {
        List<MysqlBlog> mysqlBlogs = mysqlBlogRepository.queryAll();
        return mysqlBlogs;
    }

    @PostMapping("/search")
    public Object search(@RequestBody Param param) {
        Map<String, Object> map = new HashMap<>();
        // 统计耗时
        StopWatch watch = new StopWatch();
        watch.start();
        String type = param.getType();
        // mysql 的搜索
        if (MYSQL.equals(type)) {
            List<MysqlBlog> mysqlBlogs = mysqlBlogRepository.queryBlog(param.getKeyword());
            map.put("list", mysqlBlogs);
            // es 的搜索
        } else if (ES.equals(type)) {
            BoolQueryBuilder builder = QueryBuilders.boolQuery();
            builder.should(QueryBuilders.matchPhraseQuery("title", param.getKeyword()));
            builder.should(QueryBuilders.matchPhraseQuery("content", param.getKeyword()));
            String s = builder.toString();
            log.info("s={}", s);
            Page<EsBlog> search = (Page<EsBlog>) esBlogRepository.search(builder);
            List<EsBlog> content = search.getContent();
            map.put("list", content);
        } else {
            return "你要啥呢小老弟";
        }
        watch.stop();
        // 计算耗时
        long millis = watch.getTotalTimeMillis();
        map.put("duration", millis);
        return map;
    }

    @GetMapping("/blog/{id}")
    public Object blog(@PathVariable Integer id) {
        Optional<MysqlBlog> byId = mysqlBlogRepository.findById(id);
        return byId.get();
    }

    @Data
    private static class Param {
        private String type;
        private String keyword;
    }

}
