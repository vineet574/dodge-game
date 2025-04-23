import pygame
import random

pygame.init()

WIDTH, HEIGHT = 800, 600
WHITE = (255, 255, 255)
RED = (255, 0, 0)
BLUE = (0, 0, 255)
GREEN = (0, 255, 0)
ORANGE = (255, 165, 0)

PLAYER_SIZE = 50
ENEMY_SIZE = 50
POWER_UP_SIZE = 30
SHIELD_SIZE = 60

SPEED = 5
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Dodge the Falling Blocks - Enhanced")

player = pygame.Rect(WIDTH // 2, HEIGHT - 2 * PLAYER_SIZE, PLAYER_SIZE, PLAYER_SIZE)
enemies = [pygame.Rect(random.randint(0, WIDTH - ENEMY_SIZE), 0, ENEMY_SIZE, ENEMY_SIZE) for _ in range(5)]
power_up = pygame.Rect(random.randint(0, WIDTH - POWER_UP_SIZE), random.randint(50, HEIGHT // 2), POWER_UP_SIZE, POWER_UP_SIZE)
shield = None

score = 0
speed_increase = 0
power_up_active = False
power_up_timer = 0
lives = 3
running = True
clock = pygame.time.Clock()
font = pygame.font.Font(None, 36)

shield_active = False
shield_timer = 0

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
            if score % 10 == 0:
                speed_increase += 1

        if shield_active and shield.colliderect(enemy):
            enemy.y = 0
            enemy.x = random.randint(0, WIDTH - ENEMY_SIZE)
        elif player.colliderect(enemy):
            if shield_active:
                shield_active = False
                shield = None
            else:
                lives -= 1
            enemy.y = 0
            enemy.x = random.randint(0, WIDTH - ENEMY_SIZE)
            if lives == 0:
                running = False

    if player.colliderect(power_up):
        power_up_active = True
        power_up_timer = pygame.time.get_ticks()
        power_up.x, power_up.y = random.randint(0, WIDTH - POWER_UP_SIZE), random.randint(50, HEIGHT // 2)

    if score % 15 == 0 and score > 0 and not shield_active:
        shield = pygame.Rect(random.randint(0, WIDTH - SHIELD_SIZE), random.randint(50, HEIGHT // 2), SHIELD_SIZE)

    if shield and player.colliderect(shield):
        shield_active = True
        shield_timer = pygame.time.get_ticks()
        shield = None

    if power_up_active and pygame.time.get_ticks() - power_up_timer < 5000:
        SPEED = 8
    else:
        SPEED = 5
        power_up_active = False

    pygame.draw.rect(screen, BLUE, player)
    for enemy in enemies:
        pygame.draw.rect(screen, RED, enemy)
    pygame.draw.rect(screen, GREEN, power_up)
    if shield:
        pygame.draw.rect(screen, ORANGE, shield)

    score_text = font.render(f"Score: {score}", True, (0, 0, 0))
    lives_text = font.render(f"Lives: {lives}", True, RED)
    screen.blit(score_text, (10, 10))
    screen.blit(lives_text, (10, 40))

    pygame.display.flip()
    clock.tick(30)

screen.fill(WHITE)
game_over_text = font.render(f"Game Over! Final Score: {score}", True, RED)
screen.blit(game_over_text, (WIDTH // 4, HEIGHT // 2))
pygame.display.flip()
pygame.time.delay(3000)
pygame.quit()
