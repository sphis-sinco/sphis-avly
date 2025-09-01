function onCreate()
{
	// smaller = faster

	PlayState.player_max_speed = 5;
	PlayState.player_min_speed = 10;

	if (PlayState.player_character == Characters.HARD_DIFF)
	{
		PlayState.player_max_speed = 2;
		PlayState.player_min_speed = 5;
	}
}
