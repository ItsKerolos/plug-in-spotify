COMMAND_BASE='playerctl --player=spotify'

SONG_ARTIST=$($COMMAND_BASE metadata xesam:artist)
SONG_TITLE=$($COMMAND_BASE metadata xesam:title)

SONG_URL=$($COMMAND_BASE metadata xesam:url)

PLAY_PAUSE="$COMMAND_BASE play-pause"
NEXT="$COMMAND_BASE next"
PREVIOUS="$COMMAND_BASE previous"

# ART IMAGE

ART_URL=$($COMMAND_BASE metadata mpris:artUrl)

# workaround spotify mpris support being outdated
ART_URL="${ART_URL/'https://open.spotify.com/'/'https://i.scdn.co/'}"

# GREET FORMAT

# get current hour (24 clock format i.e. 0-23)
HOUR=$(date +"%H")

# if it is midnight to midafternoon will say G'morning
if [ $HOUR -ge 0 -a $HOUR -lt 12 ]; then
  GREET="Good Morning, $USER."
# if it is midafternoon to evening ( before 6 pm) will say G'noon
elif [ $HOUR -ge 12 -a $HOUR -lt 18 ]; then
  GREET="Good Afternoon, $USER."
else # it is good evening till midnight
  GREET="Good evening, $USER."
fi

# PLAY/PAUSE FORMAT

STATE=$($COMMAND_BASE status)

if [ "$STATE" == "Playing" ]; then
    STATE="Pause"
else
    STATE="Play"
fi

# TITLE FORMAT

if [[ -z "$SONG_TITLE" && -z "$SONG_ARTIST" ]]; then
  if [[ "$PL_CONFIG_GREETINGS" == true ]]; then
    TITLE="$GREET"
  else
    TITLE=""
  fi
# Ads
elif [[ -z "$SONG_ARTIST" ]]; then
  TITLE="$SONG_TITLE"
else
  TITLE="$SONG_ARTIST - $SONG_TITLE"
fi

# PLUG OUTPUT

echo "$TITLE"

# if spotify is running
if [ "$TITLE" != "$GREET" ]; then
  echo "<b>$SONG_ARTIST</b>\n$SONG_TITLE | image({ url($ART_URL), width(56), height(56) }) | clipboard($SONG_URL) | notify({ title(Spotify), message(Copied track url to clipboard.) })"
  echo " | "
  echo "$STATE | press($PLAY_PAUSE)"
  echo " | "
  echo "Next | press($NEXT)"
  echo "Previous | press($PREVIOUS)"
else
  echo "Launch | press(spotify)"
fi
