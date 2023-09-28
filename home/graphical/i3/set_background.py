import subprocess
import random
# Get a list of all monitors
monitors = len(subprocess.check_output(["xrandr", "-q"]).decode("utf-8").split(" connected ")) -1

# Wallpaper folder
wallpaper_folder = "/home/qdl/Wallpapers"

# Choose a random wallpaper image in the wallpaper_folder
wallpaper_images = subprocess.check_output(["find", wallpaper_folder]).decode("utf-8").split("\n")[:-1]
wallpaper_image = random.choice(wallpaper_images)

# Set the wallpaper on each monitor
for monitor in range(0, monitors):
    print(str(monitor))
    subprocess.run(["nitrogen", "--head={}".format(str(monitor)) , "--set-scaled", wallpaper_image])