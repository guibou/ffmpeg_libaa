let
  pkgs = import <nixpkgs> {};
in
rec {
  ffmpeg = pkgs.ffmpeg_2_8.overrideAttrs(old: {
    src = pkgs.fetchurl {
      url = "https://github.com/FFmpeg/FFmpeg/archive/d5b9ecc2d1ed345282064e41a2d6fbe4fa03bb4e.tar.gz";
      sha256 = "0bzdwpgf0cayyl1blsiyjn8d4xry0a7aazl0aw1hpm9v96yx06pz";
    };

    configureFlags = old.configureFlags ++ ["--enable-libaa"];
    buildInputs = old.buildInputs ++ [ pkgs.aalib ];

    patches = old.patches ++ [
      # This patch is from:
      # https://ffmpeg.org/pipermail/ffmpeg-devel/2014-June/159169.html
      # I git checkout d5b9ecc2d1ed345282064e41a2d6fbe4fa03bb4e and git apply the patch from the mail
      # Solve trivial merge conflicts and dumped the result in aa.diff
      ./aa.diff
    ];
  });

  shell = pkgs.mkShell {
    buildInputs = [ ffmpeg ];

    shellHook = ''
       #ffmpeg -re -i /dev/video0 -vcodec libx264 -preset slow -crf 18 \
       #    -pix_fmt yuv420p -vf 'scale=iw/3:ih/4,aa=fontname=terminus:fontsize=12:linespacing=1.0:contrast=50,pad=width=1920:x=(ow-iw)/2' \
       #    -aspect 16:9 -acodec aac -strict -2 -f v4l2 \
       #    /dev/video4
           # -pix_fmt yuv420p -vf 'scale=iw/3:ih/4,aa=fontname=terminus:fontsize=12:linespacing=1.0:contrast=50,pad=width=1920:x=(ow-iw)/2' \
       ffmpeg -re -i /dev/video0 \
           -pix_fmt yuv420p -vf 'scale=iw/3:ih/4,aa=fontname=terminus:fontsize=12:linespacing=1.0:contrast=50' \
           -f v4l2 /dev/video4
    '';
  };
}

  # Module must be loaded as such:
  # modprobe v4l2loopback devices=1 max_buffers=2 exclusive_caps=1 card_label="VirtualCam"
