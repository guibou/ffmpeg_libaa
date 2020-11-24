This is a lib AA filter for FFMPEG for your camera device.

It provides:

- A patch for ffmpeg, as well as a nixpkgs rule to build it, which allows to use libAA as a filter for ffmpeg. I'm not the author of the patch, I just unburied it from june 2014 FFMPEG mailing list and rebased it so it builds on a selected ffmpeg commit.
- Some instructions (in the default.nix) about how to configure v4l2loopback.
