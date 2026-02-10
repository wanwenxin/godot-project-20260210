# Super Godot Mario

基于 Godot 4 的横版平台跳跃游戏（超级马里奥风格），支持在 PC 上运行。

## 功能概览

- **主菜单**：开始游戏、退出
- **玩家**：左右移动、跳跃；小形态 / 大形态（吃蘑菇）；无敌星短暂无敌；被敌人侧面撞到受伤或死亡
- **敌人**：蘑菇怪（Goomba）巡逻，从上方踩死、侧面撞到会伤到玩家
- **道具**：变大蘑菇、无敌星；碰到墙体会反弹或反向
- **关卡**：第一关含地面、起点、终点（绿色区域）、敌人与道具；到达终点可过关
- **HUD**：显示生命、金币、分数；Esc 暂停，暂停菜单可继续或返回主菜单
- **游戏流程**：死亡扣命并重开本关；生命用尽则 Game Over，重置后回到第一关

## 运行方式

### 环境要求

- [Godot 4.x](https://godotengine.org/download)（推荐 4.2 或 4.3）

### 在编辑器中运行

1. 用 Godot 4 打开项目根目录下的 **`project.godot`**
2. 按 **F5** 或点击编辑器右上角 **「运行」**
3. 主菜单点击 **「Start Game」** 进入第一关

### 导出为 Windows 可执行文件

1. 菜单 **项目 → 导出**
2. 选择 **Windows Desktop** 预设（若未配置，需先安装对应导出模板）
3. 设置导出路径后点击 **导出项目**，得到 `.exe` 后可在 PC 上直接运行

## 操作说明

| 操作     | 按键（默认）     |
|----------|------------------|
| 向左移动 | ← 或 A           |
| 向右移动 | → 或 D           |
| 跳跃     | 空格 或 ↑ 或 W   |
| 暂停     | Esc              |

（具体按键以项目 **项目 → 项目设置 → 输入** 中的 `ui_left`、`ui_right`、`ui_accept`、`ui_cancel` 为准。）

## 项目结构

```
├── project.godot          # 项目配置；主场景、Autoload 在此设置
├── export_presets.cfg     # 导出预设（如 Windows Desktop）
├── README.md              # 本说明
├── assets/                # 资源
│   ├── tiles/             # 地形图块（可扩展）
│   ├── characters/        # 角色贴图（可扩展）
│   └── audio/             # 音效与音乐（可扩展）
├── scenes/
│   ├── ui/
│   │   ├── MainMenu.tscn  # 主菜单
│   │   └── HUD.tscn       # 游戏内 HUD + 暂停菜单
│   ├── levels/
│   │   └── Level1.tscn    # 第一关（地面、起点、终点、敌人、道具、摄像机）
│   ├── player/
│   │   └── Player.tscn    # 玩家角色
│   ├── enemies/
│   │   └── Goomba.tscn   # 蘑菇怪
│   └── items/
│       ├── Mushroom.tscn  # 变大蘑菇
│       └── Star.tscn      # 无敌星
└── scripts/
    ├── core/
    │   └── game_manager.gd   # 游戏管理器（Autoload）：关卡、生命、分数、HUD
    ├── player/
    │   └── player.gd         # 玩家移动、跳跃、形态、受伤、死亡
    ├── levels/
    │   ├── level1.gd        # 第一关：背景、生成玩家、摄像机跟随
    │   └── goal.gd          # 终点区域：过关切关
    ├── enemies/
    │   ├── base_enemy.gd    # 敌人基类：巡逻、与玩家碰撞判定
    │   └── goomba.gd        # 蘑菇怪：被踩死逻辑
    ├── items/
    │   ├── mushroom.gd      # 蘑菇：碰到玩家触发 grow，碰墙反向
    │   └── star.gd          # 无敌星：触发 set_invincible，地面弹跳、碰墙反向
    └── ui/
        ├── main_menu.gd     # 主菜单：开始游戏、退出
        └── hud.gd           # HUD：生命/金币/分数、暂停、继续/主菜单
```

## 主要脚本说明

| 脚本 | 作用 |
|------|------|
| **game_manager.gd** | 单例（Autoload）。管理当前关卡路径、生命/金币/分数；加载 HUD（call_deferred）；提供 `change_level`、`add_coin`、`add_score`、`lose_life`；死亡重开本关、Game Over 重置并回第一关。 |
| **player.gd** | 玩家 CharacterBody2D。处理重力、左右移动、跳跃；`grow()` 变大、`shrink_or_die()` 受伤/死亡、`die()` 通知 GameManager、`set_invincible(duration)` 无敌星。无贴图时生成红色占位图。 |
| **level1.gd** | 第一关 Node2D。生成天空背景（CanvasLayer + ColorRect）、在 PlayerStart 生成玩家、每帧摄像机 X 跟随玩家。 |
| **goal.gd** | 终点 Area2D。玩家进入时通过 GameManager 切换关卡；可配置 `next_level_path`。 |
| **base_enemy.gd** | 敌人基类。重力 + 水平匀速；与玩家碰撞时区分「从上踩」与「侧撞」，踩则 `die_from_stomp`，侧撞则 `player.shrink_or_die()`。 |
| **goomba.gd** | 蘑菇怪。继承 base_enemy，重写 `die_from_stomp`：给玩家反弹速度并 `queue_free()`。 |
| **mushroom.gd** | 蘑菇道具。水平移动 + 重力；碰到玩家则 `grow()` 并消失，碰到墙则反向。 |
| **star.gd** | 无敌星。水平移动 + 重力；着地弹跳、碰墙反向；碰到玩家则 `set_invincible(duration)` 并消失。 |
| **main_menu.gd** | 主菜单。设置根 Control 的 `mouse_filter` 避免拦截点击；开始游戏调用 GameManager 或直接切关，退出调用 `get_tree().quit()`。 |
| **hud.gd** | HUD。用路径取节点避免 null；订阅 GameManager 的 lives/coins/score 并更新 Label；Esc 切换暂停，暂停菜单继续/返回主菜单。 |

## 扩展建议

- **多关卡**：复制 `Level1.tscn` 为 `Level2.tscn` 等，在 Goal 的 `next_level_path` 中指定下一关；主菜单或 GameManager 中可配置关卡列表。
- **金币**：在场景中放金币节点（如 Area2D），碰撞时调用 `GameManager.add_coin(1)`。
- **音效**：在 `assets/audio/` 中放入音效，在玩家跳跃、踩怪、吃道具、死亡、过关等处播放。
- **美术**：在 `assets/characters/`、`assets/tiles/` 中替换或添加贴图，在对应场景中为 Sprite2D / TileMap 指定纹理。

## 许可证

本项目仅供学习与参考使用。游戏玩法灵感来自经典横版平台游戏。
