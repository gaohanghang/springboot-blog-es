package com.sixkery;

import com.sixkery.entity.es.EsBlog;
import com.sixkery.repository.EsBlogRepository;
import lombok.extern.slf4j.Slf4j;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.Iterator;

@SpringBootTest
@RunWith(SpringRunner.class)
@Slf4j
public class BlogEsApplicationTests {
    @Autowired
    EsBlogRepository esBlogRepository;


    @Test
    public void testEs() {
        Iterable<EsBlog> all = esBlogRepository.findAll();
        Iterator<EsBlog> esBlogIterator = all.iterator();
        EsBlog esBlog = esBlogIterator.next();

        log.info("【es集成springboot】esBlog={}",esBlog);
    }
}
