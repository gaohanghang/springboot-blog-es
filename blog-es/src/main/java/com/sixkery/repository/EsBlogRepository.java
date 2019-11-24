package com.sixkery.repository;

import com.sixkery.entity.es.EsBlog;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

/**
 * @author sixkery
 * @date 2019/11/24
 */
public interface EsBlogRepository extends ElasticsearchRepository<EsBlog, String> {
}
