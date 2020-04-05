example.ffmpeg = function() {
  bin.dir = "D:/programs/ffmpeg/bin/"
  options(ffmpeg.bin.dir=bin.dir)

  arg.str = "--help"

  arg.str = "-i video.mp4 -i audio.wav \
-c:v copy -c:a aac -strict experimental output.mp4"

  convert.screencast.video("D:/videos/umwelt/energietraeger weltweit.mkv",fps=5, overwrite=FALSE)


  convert.free.cam("ma_1a_2_4_bob",fps=2, parent.dir = "D:/libraries/simplestMOOC/videos", overwrite=TRUE)

  convert.free.cam("ma_1a_2_4_bob",fps=5,out.type = "wmv", parent.dir = "D:/libraries/simplestMOOC/videos", overwrite=TRUE)


  convert.free.cam("ma_1a_2-4_bob",fps=5, parent.dir = "D:/libraries/simplestMOOC/videos", overwrite=TRUE)

  convert.free.cam("ma_1a_4-5_model1",fps=2, parent.dir = "D:/videos", overwrite=TRUE)

  convert.screencast.avi("avi_test",fps=20, parent.dir = "D:/libraries/simplestMOOC/videos", overwrite=TRUE)

  cut.video("D:/videos/ma_1a_4-5_model1.wmv", duration="00:01:56")


  ffmpeg.help()
}

get.bin.dir = function() {
  getOption("ffmpeg.bin.dir")
}

cut.video = function(file, start="00:00:00", duration="00:01:00", output.file = paste0(tools::file_path_sans_ext(file),"_cut.", tools::file_ext(file)),bin.dir=get.bin.dir(),...) {

  arg.str = glue("-y -i {file} -ss {start} -t {duration} -c copy {output.file}")

  ffmpeg(arg.str, bin.dir=bin.dir)
}

convert.screencast.video = function(file, out.type="mp4", fps=5,  output.file = paste0(tools::file_path_sans_ext(file),".", out.type), overwrite=TRUE, bin.dir=get.bin.dir(), adapt.audio = FALSE) {

  if (adapt.audio) {
    arg.str = glue('{if(overwrite) "-y" else ""} -i "{file}" -c:a aac -filter:v fps=fps={fps} -strict experimental "{output.file}"')
  } else {
    arg.str = glue('{if(overwrite) "-y" else ""} -i "{file}" -filter:v fps=fps={fps} -strict experimental "{output.file}"')
  }
  ffmpeg(arg.str, bin.dir=bin.dir)

}

convert.screencast.avi = function(id,fps=5, parent.dir = getwd(), out.type="mp4", out.file = paste0(id, ".", out.type), out.dir=parent.dir, bin.dir = get.bin.dir(), overwrite=FALSE) {

  avi = file.path(parent.dir, paste0(id, ".avi"))
  output = paste0(out.dir,"/", out.file)

  arg.str = glue('{if(overwrite) "-y" else ""} -i "{avi}" -c:a aac -filter:v fps=fps={fps} -strict experimental "{output}"')
  ffmpeg(arg.str, bin.dir=bin.dir)

}

convert.free.cam = function(id,fps=5, parent.dir = getwd(), out.type="mp4", out.file = paste0(id, ".", out.type), out.dir=parent.dir, bin.dir = getOption("ffmpeg.bin.dir"), overwrite=FALSE) {
  restore.point("convert.free.cam")
  wav = file.path(parent.dir, id ,"Data", "audio.wav")
  avi = file.path(parent.dir, id ,"Data", "output.1.avi")
  output = paste0(out.dir,"/", out.file )

  #arg.str = "-i video.mp4 -i audio.wav -c:v copy -c:a aac -strict experimental output.mp4"

  arg.str = glue('{if(overwrite) "-y" else ""} -i "{avi}" -i "{wav}" -c:a aac -filter:v fps=fps={fps} -strict experimental "{output}"')

  arg.str = glue('{if(overwrite) "-y" else ""} -i "{avi}" -i "{wav}" -c:a aac -filter:v fps=fps={fps}  "{output}"')


  arg.str

  ffmpeg(arg.str, bin.dir=bin.dir)
}

ffmpeg.help = function(topic=c("","long","full")[1],bin.dir = getOption("ffmpeg.bin.dir")) {
  ffmpeg(paste0("-h ", topic), bin.dir=bin.dir)
}

ffmpeg = function(arg.str = NULL, bin.dir = getOption("ffmpeg.bin.dir"), verbose=TRUE) {

  cmd = paste0('"', bin.dir,'ffmpeg" ', arg.str)
  if (verbose)
    cat(paste0("\n",cmd,"\n\n"))
  system(cmd)
}
