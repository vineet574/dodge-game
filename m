lives = 3

while running:
    screen.fill(WHITE)

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    keys = pygame.key.get_pressed()
    if keys[pygame.K_LEFT] and player.x > 0:
        player.x -= SPEED
    if keys[pygame.K_RIGHT] and player.x < WIDTH - PLAYER_SIZE:
        player.x += SPEED

    for enemy in enemies:
        enemy.y += SPEED + speed_increase
        if enemy.y > HEIGHT:
            enemy.y = 0
            enemy.x = random.randint(0, WIDTH - ENEMY_SIZE)
            score += 1
            if score % 5 == 0:
                speed_increase += 1

        if player.colliderect(enemy):
            lives -= 1
            enemy.y = 0
            enemy.x = random.randint(0, WIDTH - ENEMY_SIZE)
            if lives == 0:
                running = False

    pygame.draw.rect(screen, BLUE, player)
    for enemy in enemies:
        pygame.draw.rect(screen, RED, enemy)
    pygame.draw.rect(screen, GREEN, power_up)

    score_text = font.render(f"Score: {score}", True, (0, 0, 0))
    lives_text = font.render(f"Lives: {lives}", True, (255, 0, 0))
    screen.blit(score_text, (10, 10))
    screen.blit(lives_text, (10, 40))

    pygame.display.flip()
    clock.tick(30)

game_over_text = font.render(f"Game Over! Final Score: {score}", True, (255, 0, 0))
screen.blit(game_over_text, (WIDTH // 4, HEIGHT // 2))
pygame.display.flip()
pygame.time.delay(3000)

pygame.quit()
