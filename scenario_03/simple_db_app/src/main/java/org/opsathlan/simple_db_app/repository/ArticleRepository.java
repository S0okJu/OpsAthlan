package org.opsathlan.simple_db_app.repository;

import org.opsathlan.simple_db_app.entity.Article;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ArticleRepository extends JpaRepository<Article, Long> {
}
