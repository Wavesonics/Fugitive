extends Node

const GAME_VERSION := '0.01'

var file_name := 'user://user_data.json'

var data = get_default_data()

static func get_default_data():
	var default = {
		user_name = '',
		last_ip = Network.DEFAULT_IP,
		lifetime_stats = PlayerStats.new().toDTO()
	}
	
	return default
	
func add_to_stats(newStats: PlayerStats):
	var stats := PlayerStats.new()
	stats.fromDTO(self.data.lifetime_stats)
	stats.addStats(newStats)
	self.data.lifetime_stats = stats.toDTO()

func load_data():
	print('Loading user data...')
	# Open a file
	var file = File.new()

	# If we don't have a file, create the basic one	
	if not file.file_exists(file_name):
		print("No user data, create default")
	
		var defaultData = get_default_data()
		save_data(defaultData)
	
	# Read in the data file
	if file.open(file_name, File.READ) != 0:
		print("Error opening file")
		return
	
	var serialized = file.get_line()
	data = parse_json(serialized)
	file.close()

func save_data(save_data = self.data):
	print('Saving user data...')
	var file = File.new()
	if file.open(file_name, File.WRITE) != 0:
		print("Error opening file")
		return
	
	var serialized =to_json(save_data)
	file.store_line(serialized)
	file.close()
