extends Node

#design settings
const animation_walking_speed_ps = 8*4 #pixelspeed inanimation * scale
const navigation_precision = 5
const service_busy_time_s = 5.0
const min_spawn_delay_s = 5.0
const max_spawn_delay_s = 15.0
const min_non_story_spawn = 2
const max_non_story_spawn = 5
const need_unfulfulled_penalty = -1
const need_fulfilled_reward = 1

#player settings
enum Lang{english,deutsch}
var language:Lang = Lang.english #TODO currently not in use; always english
var volume = 1.0
