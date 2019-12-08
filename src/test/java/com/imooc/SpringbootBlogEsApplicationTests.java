package com.imooc;

import com.imooc.entity.es.EsBlog;
import com.imooc.repository.EsBlogRepository;
import lombok.extern.slf4j.Slf4j;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.Iterator;

@SpringBootTest
@RunWith(SpringRunner.class)
@Slf4j
public class SpringbootBlogEsApplicationTests {

    @Autowired
    EsBlogRepository esBlogRepository;


    @Test
    public void testEs() {
        Iterable<EsBlog> all = esBlogRepository.findAll();
        Iterator<EsBlog> esBlogIterator = all.iterator();
        for (EsBlog esBlog : all) {
            System.out.println(esBlog.toString());
        }
        EsBlog esBlog = esBlogIterator.next();

        log.info("【es集成springboot】esBlog={}",esBlog);
    }

}
