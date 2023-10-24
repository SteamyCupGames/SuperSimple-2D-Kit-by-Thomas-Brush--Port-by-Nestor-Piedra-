extends CanvasLayer

@onready var coin_text = $CoinText
@onready var inventory_blank = $InventoryBlank
@onready var inventory_key = $InventoryKey
@onready var coin_icon = $CoinIcon
@onready var health_bar = $HealthBar
@onready var hud = $"."

func _ready():
	GameManager.receivedCoins.connect(update_coin_display)
	health_bar.max_value = GameManager.MAX_HEALTH
	set_health_bar()
	
func update_coin_display(_coinsCollected):
	coin_text.text = str(GameManager.coins)

func set_health_bar() -> void:
	health_bar.value = GameManager.health

func _process(_delta):
	set_health_bar()
	coin_text.text = str(GameManager.coins)
	
	if GameManager.is_hud_available:
		hud.visible = true
	else: 
		hud.visible = false
		
	if GameManager.has_key:
		inventory_key.visible = true
		inventory_blank.visible = false
	else:
		inventory_key.visible = false
		inventory_blank.visible = true
