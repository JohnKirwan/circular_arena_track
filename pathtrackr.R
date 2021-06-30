

pathtrackr::splitVideo(
  'C:/Users/seano/Github/circular_arena_track/vids/WIN_20210120_12_46_19_Pro.1.avi',
  fps=1)


path.list = trackPath(
  'C:/Users/seano/Github/circular_arena_track/vids/WIN_20210120_12_46_19_Pro',
  xarena=930, yarena=930, fps = 1, box = 1, jitter.damp = 0.9
  )


path.list = diagnosticPDF(
  'C:/Users/seano/Github/circular_arena_track/vids/WIN_20210120_12_46_19_Pro',
  xarena=930, yarena=930, fps = 1, box = 1, jitter.damp = 0.9
  )


