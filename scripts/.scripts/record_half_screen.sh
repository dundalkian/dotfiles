ffmpeg -y -video_size 930x1015 -framerate 30 -f x11grab -i :0.0+25,25 /tmp/screen1_recording_`date '+%Y-%m-%d_%H-%M-%S'`.mp4
