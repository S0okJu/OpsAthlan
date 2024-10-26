package org.opsathlan.simple_db_app.controller;

import org.opsathlan.simple_db_app.dto.ArticleCreateRequest;
import org.opsathlan.simple_db_app.entity.Article;
import org.opsathlan.simple_db_app.repository.ArticleRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/articles")
public class ArticleController {
    private ArticleRepository articleRepository;

    @PostMapping
    public ResponseEntity<Article> createArticle(@RequestBody ArticleCreateRequest request) {
        Article article = Article.builder().title(request.getTitle()).content(request.getContent()).build();
        Article savedArticle = articleRepository.save(article);
        return new ResponseEntity<>(savedArticle, HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<List<Article>> getAllArticles() {
        List<Article> articles = articleRepository.findAll();
        return new ResponseEntity<>(articles, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Article> getArticleById(@PathVariable Long id) {
        Optional<Article> article = articleRepository.findById(id);
        return article.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

}
