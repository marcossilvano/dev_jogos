class_name CoinsUI
extends Control

var coins: int = 0: set = set_coins
var max_coins: int = 0: set = set_max_coins

@onready var label = $Label

func set_coins(value: int):
	# cannot be greater than the wallet size
	#coins = clamp(coins + value, 0, max_coins)
	coins = value
	if label != null:
		label.text = "COINS: " + str(coins) + "/" + str(max_coins)

func set_max_coins(value: int):
	# cannot be negative
	max_coins = max(value, 1) as int

func _ready():
	self.max_coins = PlayerStats.max_coins
	self.coins = PlayerStats.coins
	#PlayerStats.connect("wallet_changed", self, "set_coins")
