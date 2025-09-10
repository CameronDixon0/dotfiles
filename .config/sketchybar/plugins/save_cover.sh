#!/bin/bash

osascript <<EOF
tell application "Music"
    if player state is playing or player state is paused then
        set trackArtwork to data of artwork 1 of current track
        set outFile to POSIX file "/tmp/music_cover_full.jpg"
        try
            set fileRef to open for access outFile with write permission
            write trackArtwork to fileRef
            close access fileRef
        on error
            try
                close access outFile
            end try
        end try
    end if
end tell
EOF

sips -Z 600 /tmp/music_cover_full.jpg --out /tmp/music_cover.jpg
