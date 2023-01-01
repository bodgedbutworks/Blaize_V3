# Blaize 3
Software to turn your projector into a safe disco laser \
[Blaize 3 Demo](https://www.youtube.com/watch?v=ziG_0-8F9Vg) \
[Blaize 3 HowTo](https://www.youtube.com/watch?v=TjnYWlusAS8)

# Releases
You can find prebuilt binaries for each release on the [release page](https://github.com/bodgedbutworks/Blaize_V3/releases).
> **Note for mac users**: \
> If you download the prebuilt releases, they are considered suspicious and receive a quarantine flag. This results in errors such as `The application is corrupted and should be removed` and the application not starting.
> This can be prevented either by installing [Processing 3](https://processing.org/download/) yourself and running the program from source OR (quicker) by removing the quarantine flag from the app.
> To remove the flag open a terminal window (Spotlight search [CMD+Space], type "Term...") and execute the following commands: \
> __Navigate to where Blaize was downloaded. You can partially type the directory names (e.g. "Blai...") and press TAB multiple times to autocomplete:__ \
> ```cd ~/Downloads/Blaize_v3.0.1_macos-x86_64``` \
> __Remove quarantine flag:__ \
> ```sudo xattr -d -r com.apple.quarantine Blaize_V3.app```

# Users
You'll need a standard projector and a fog machine. Head over to [Blaize 3 Demo](https://www.youtube.com/watch?v=ziG_0-8F9Vg) to see what Blaize can do and to [Blaize 3 HowTo](https://www.youtube.com/watch?v=TjnYWlusAS8) to learn how to download and use it. Have fun and feel free to share some pictures/videos when it's working!

Pro tip: Set the **contrast** and **saturation** of your projector to maximum for even more vivid colors.

# Developers
Blaize 3 is currently not under active development, although I plan to integrate some feature requests from users in the YouTube comments in 2022 and unclutter the code in general. Feel free to integrate your own ideas or even re-structure the code. It's not the cleanest, as it started as one of my first Java/Processing projects.
If you have any questions or requests, you can contact me via email (bodgedbutworks<(at)>aerotrax<(dot)>de) or on Instagram (@bodgedbutworks).

You will need Processing 3 to run the code: https://processing.org/download
If you're missing libraries, you can simply install them using Processing's built-in library manager.
<br>
<br>

<h2>Why isn't the Android remote control app open source?</h2>
...because it's a pile of ravioli code from my early beginnings and I don't want to hurt your eyes.
If you like the app AND you REALLY want to spend time cleaning up smelly code, then feel free to message me an I can commit <del>a crime</del> the app's source code.
