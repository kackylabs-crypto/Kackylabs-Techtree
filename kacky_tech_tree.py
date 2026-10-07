"""
Kacky Labs Tech Tree - Free Camera Cyber Edition (Python / pygame port)

Install:  pip install pygame
Run:      python kacky_tech_tree.py

Passcode: !Kackylabs
Controls: Left-click nodes to unlock children | Drag empty space to pan
          Scroll to zoom | R to reset view
"""
import pygame

WIDTH, HEIGHT = 1100, 700
PASSCODE = "!Kackylabs"

# Palette
BG_DARK = (6, 10, 16)
PANEL_BG = (10, 18, 30)
NEON = (0, 229, 255)
MUTED = (26, 54, 84)
WHITE = (230, 247, 255)
DIM = (74, 115, 156)
GRID_LOGIN = (15, 29, 46)
GRID_WORLD = (13, 23, 38)
NODE_FILL = (5, 11, 20)
RED = (255, 60, 60)

NODE_W, NODE_H = 150, 46

# id: (x, y, title)
NODES = {
    "root": (-650, 0, "HyperM"),
    # Undyn
    "u1": (-380, -280, "Undyn 1"), "u2": (-100, -310, "Undyn 2"), "u3": (180, -310, "Undyn 3"),
    "u4a": (440, -390, "Undyn 4a"), "u4b": (440, -310, "Undyn 4b"), "u4c": (440, -230, "Undyn 4c"),
    "u4Gen": (720, -350, "Undyn 4 General"), "u4Spec": (720, -230, "Undyn 4 Specialised"),
    # Bdy
    "b1": (-360, -90, "Bdy 1"), "b2": (-80, -80, "Bdy 2"), "b3": (200, -90, "Bdy 3"),
    "b4a": (460, -150, "Bdy 4a"), "b4b": (460, -70, "Bdy 4b"), "b4c": (460, 10, "Bdy 4c"),
    "b4Gen": (740, -110, "Bdy 4 General"), "b4Spec": (740, 10, "Bdy 4 Specialised"),
    # Cyn & Pyn
    "c1": (-400, 110, "Cyn 1"), "c2": (-180, 130, "Cyn 2"), "c3": (50, 90, "Cyn 3"),
    "p1": (50, 200, "Pyn 1"), "p2": (270, 200, "Pyn 2"), "c4v1": (480, 145, "Cyn 4 v1"),
    "c4a": (740, 65, "Cyn 4a"), "c4b": (740, 145, "Cyn 4b"), "c4c": (740, 225, "Cyn 4c"),
    "c4Gen": (1000, 105, "Cyn 4 General"), "c4Spec": (1000, 225, "Cyn 4 Specialised"),
    # Sfyt
    "s1": (-380, 390, "Sfyt 1"), "s2": (-80, 390, "Sfyt 2"), "s3": (220, 390, "Sfyt 3"),
}

EDGES = [
    ("root", "u1"), ("u1", "u2"), ("u2", "u3"),
    ("u3", "u4a"), ("u3", "u4b"), ("u3", "u4c"),
    ("u4a", "u4Gen"), ("u4b", "u4Gen"), ("u4c", "u4Spec"),
    ("root", "b1"), ("b1", "b2"), ("b2", "b3"),
    ("b3", "b4a"), ("b3", "b4b"), ("b3", "b4c"),
    ("b4a", "b4Gen"), ("b4b", "b4Gen"), ("b4c", "b4Spec"),
    ("root", "c1"), ("c1", "c2"), ("c2", "c3"), ("c2", "p1"),
    ("p1", "p2"), ("p2", "c4v1"), ("c3", "c4v1"),
    ("c4v1", "c4a"), ("c4v1", "c4b"), ("c4v1", "c4c"),
    ("c4a", "c4Gen"), ("c4b", "c4Gen"), ("c4c", "c4Spec"),
    ("root", "s1"), ("s1", "s2"), ("s2", "s3"),
]


class Node:
    def __init__(self, x, y, title):
        self.x, self.y, self.title = x, y, title
        self.unlocked = False
        self.children = []

    def contains(self, px, py):
        return (self.x - NODE_W / 2 <= px <= self.x + NODE_W / 2 and
                self.y - NODE_H / 2 <= py <= self.y + NODE_H / 2)


def bezier(p0, p1, p2, p3, steps=32):
    pts = []
    for i in range(steps + 1):
        t = i / steps
        u = 1 - t
        x = u**3 * p0[0] + 3 * u**2 * t * p1[0] + 3 * u * t**2 * p2[0] + t**3 * p3[0]
        y = u**3 * p0[1] + 3 * u**2 * t * p1[1] + 3 * u * t**2 * p2[1] + t**3 * p3[1]
        pts.append((x, y))
    return pts


class App:
    def __init__(self):
        pygame.init()
        pygame.display.set_caption("Kacky Labs Tech Tree")
        self.screen = pygame.display.set_mode((WIDTH, HEIGHT))
        self.clock = pygame.time.Clock()
        self.font = lambda size: pygame.font.SysFont("couriernew,dejavusansmono,monospace", size, bold=False)
        self.fonts = {s: self.font(s) for s in (11, 12, 13, 16, 20)}

        self.nodes = {k: Node(*v) for k, v in NODES.items()}
        for a, b in EDGES:
            self.nodes[a].children.append(self.nodes[b])
        self.nodes["root"].unlocked = True

        self.password = ""
        self.authenticated = False
        self.error = False

        self.reset_view()
        self.dragging = False
        self.drag_start = (0, 0)
        self.cam_start = (0, 0)
        self.frame = 0

    def reset_view(self):
        self.cam_x, self.cam_y, self.scale = WIDTH / 2, HEIGHT / 2, 1.0

    # --- helpers ---
    def to_screen(self, x, y):
        return x * self.scale + self.cam_x, y * self.scale + self.cam_y

    def to_world(self, sx, sy):
        return (sx - self.cam_x) / self.scale, (sy - self.cam_y) / self.scale

    def text(self, s, size, color, center, align="center"):
        img = self.fonts[size].render(s, True, color)
        r = img.get_rect()
        if align == "center":
            r.center = center
        elif align == "left":
            r.midleft = center
        else:
            r.midright = center
        self.screen.blit(img, r)

    def alpha_rect(self, rect, color, alpha, radius, border=0, border_color=None):
        surf = pygame.Surface(rect.size, pygame.SRCALPHA)
        pygame.draw.rect(surf, (*color, alpha), surf.get_rect(), border_radius=radius)
        if border and border_color:
            pygame.draw.rect(surf, border_color, surf.get_rect(), width=border, border_radius=radius)
        self.screen.blit(surf, rect.topleft)

    # --- login ---
    def draw_login(self):
        for i in range(0, WIDTH, 40):
            pygame.draw.line(self.screen, GRID_LOGIN, (i, 0), (i, HEIGHT))
        for j in range(0, HEIGHT, 40):
            pygame.draw.line(self.screen, GRID_LOGIN, (0, j), (WIDTH, j))

        cx, cy = WIDTH // 2, HEIGHT // 2
        panel = pygame.Rect(0, 0, 480, 260)
        panel.center = (cx, cy)
        self.alpha_rect(panel, PANEL_BG, 240, 24, 2, NEON)

        self.text("[ KACKY LABS TERMINAL ]", 20, NEON, (cx, cy - 80))
        self.text("ENTER ACCESS KEY:", 12, DIM, (cx, cy - 35))

        field = pygame.Rect(0, 0, 360, 42)
        field.center = (cx, cy + 15)
        pygame.draw.rect(self.screen, (4, 7, 13), field, border_radius=21)
        pygame.draw.rect(self.screen, RED if self.error else NEON, field, width=2, border_radius=21)

        masked = "*" * len(self.password)
        if (self.frame // 30) % 2 == 0:
            masked += "_"
        self.text(masked, 16, WHITE, (cx, cy + 13))

        if self.error:
            self.text(">> ACCESS DENIED: INVALID KEY <<", 11, (255, 75, 75), (cx, cy + 75))
        else:
            self.text("AWAITING PASSCODE... PRESS ENTER", 11, (0, 160, 180), (cx, cy + 75))

    # --- tech tree ---
    def draw_tree(self):
        mx, my = pygame.mouse.get_pos()
        wmx, wmy = self.to_world(mx, my)

        # Grid (world space -3000..3000, every 50)
        s = self.scale
        for i in range(-3000, 3001, 50):
            x0, y0 = self.to_screen(i, -3000)
            x1, y1 = self.to_screen(i, 3000)
            if 0 <= x0 <= WIDTH:
                pygame.draw.line(self.screen, GRID_WORLD, (x0, y0), (x1, y1))
            x0, y0 = self.to_screen(-3000, i)
            x1, y1 = self.to_screen(3000, i)
            if 0 <= y0 <= HEIGHT:
                pygame.draw.line(self.screen, GRID_WORLD, (x0, y0), (x1, y1))

        # Connections
        for n in self.nodes.values():
            if not n.unlocked:
                continue
            for c in n.children:
                if not c.unlocked:
                    continue
                off = ((n.x - c.x) ** 2 + (n.y - c.y) ** 2) ** 0.5 * 0.4
                pts = bezier(
                    (n.x + NODE_W / 2, n.y),
                    (n.x + NODE_W / 2 + off, n.y),
                    (c.x - NODE_W / 2 - off, c.y),
                    (c.x - NODE_W / 2, c.y),
                )
                pygame.draw.lines(self.screen, (0, 160, 180), False,
                                  [self.to_screen(*p) for p in pts], max(1, round(2.5 * s)))

        # Nodes
        for n in self.nodes.values():
            if not n.unlocked:
                continue
            hover = n.contains(wmx, wmy)
            sx, sy = self.to_screen(n.x, n.y)
            rect = pygame.Rect(0, 0, NODE_W * s, NODE_H * s)
            rect.center = (sx, sy)
            radius = int(NODE_H * s / 2)
            border = WHITE if hover else NEON
            width = max(1, round((2.5 if hover else 1.5) * s))
            self.alpha_rect(rect, NODE_FILL, 240, radius)
            if hover:
                inner = rect.inflate(-4 * s, -4 * s)
                self.alpha_rect(inner, NEON, 30, int(inner.height / 2))
            pygame.draw.rect(self.screen, border, rect, width=width, border_radius=radius)

            font = pygame.font.SysFont("couriernew,dejavusansmono,monospace", max(6, round(11 * s)))
            img = font.render(n.title, True, NEON if hover else WHITE)
            self.screen.blit(img, img.get_rect(center=(sx, sy - s)))

    def draw_overlay(self):
        bar = pygame.Rect(0, 0, WIDTH, 45)
        pygame.draw.rect(self.screen, PANEL_BG, bar)
        pygame.draw.rect(self.screen, MUTED, bar, width=1)
        self.text("SYS.ONLINE // FREE_CAM_ACTIVE", 13, NEON, (25, 22), "left")
        self.text("DRAG: PAN | SCROLL: ZOOM | [R]: RESET", 13, NEON, (WIDTH - 25, 22), "right")

    # --- input ---
    def on_click(self, pos):
        wx, wy = self.to_world(*pos)
        clicked = False
        for n in self.nodes.values():
            if n.unlocked and n.contains(wx, wy):
                for c in n.children:
                    c.unlocked = True
                clicked = True
        if not clicked:
            self.dragging = True
            self.drag_start = pos
            self.cam_start = (self.cam_x, self.cam_y)

    def on_wheel(self, direction):
        old = self.scale
        new = max(0.25, min(2.5, old * (1.08 if direction > 0 else 0.92)))
        factor = new / old
        mx, my = pygame.mouse.get_pos()
        self.cam_x = mx - (mx - self.cam_x) * factor
        self.cam_y = my - (my - self.cam_y) * factor
        self.scale = new

    def on_key(self, event):
        if not self.authenticated:
            if event.key in (pygame.K_RETURN, pygame.K_KP_ENTER):
                if self.password == PASSCODE:
                    self.authenticated, self.error = True, False
                else:
                    self.error, self.password = True, ""
            elif event.key == pygame.K_BACKSPACE:
                self.password = self.password[:-1]
            elif event.unicode and 32 <= ord(event.unicode) <= 126:
                self.password += event.unicode
                self.error = False
        elif event.key == pygame.K_r:
            self.reset_view()

    def run(self):
        running = True
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.KEYDOWN:
                    self.on_key(event)
                elif self.authenticated:
                    if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                        self.on_click(event.pos)
                    elif event.type == pygame.MOUSEBUTTONUP and event.button == 1:
                        self.dragging = False
                    elif event.type == pygame.MOUSEMOTION and self.dragging:
                        self.cam_x = self.cam_start[0] + event.pos[0] - self.drag_start[0]
                        self.cam_y = self.cam_start[1] + event.pos[1] - self.drag_start[1]
                    elif event.type == pygame.MOUSEWHEEL:
                        self.on_wheel(event.y)

            self.screen.fill(BG_DARK)
            if self.authenticated:
                self.draw_tree()
                self.draw_overlay()
            else:
                self.draw_login()
            pygame.display.flip()
            self.frame += 1
            self.clock.tick(60)
        pygame.quit()


if __name__ == "__main__":
    App().run()
