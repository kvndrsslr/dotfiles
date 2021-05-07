on run argv
	tell application id "tracesof.Uebersicht"
		refresh widget id ("simple-bar-" & (item 1 of argv) & "-jsx")
	end tell
end run
