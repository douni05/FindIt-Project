package com.findit.project.service;

import com.findit.project.domain.Comment;
import com.findit.project.domain.Post;
import com.findit.project.domain.User;
import com.findit.project.repository.CommentRepository;
import com.findit.project.repository.PostRepository;
import com.findit.project.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class CommentService {

    private final CommentRepository commentRepository;
    private final UserRepository userRepository;
    private final PostRepository postRepository;

    public void insert(Long userId, Long postId, String content) {
        User user = userRepository.findById(userId).orElseThrow();
        Post post = postRepository.findById(postId).orElseThrow();

        Comment comment = new Comment();
        comment.setUser(user);
        comment.setPost(post);
        comment.setContent(content);
        comment.setIsSecret("Y"); // 무조건 비밀 댓글로 설정 (기획 의도)

        commentRepository.save(comment);
    }
}