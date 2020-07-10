fs = require('fs')

# In newer Node.js versions where process is already global this isn't necessary.
process = require('process')
moveFrom = '/home/mike/dev/node/sonar/moveme'
moveTo = '/home/mike/dev/node/sonar/tome'
###
copy subdirectory files if they exist into the public and draft directories
###
preparedDirectories = {}
prepareDirectory= (d)->
  return if preparedDirectories[d]?.isDirectory() 
  paths = d.split '/'
  startPath = paths.shift()
  for path in paths
    continue unless path
    startPath += '/'+ path
    continue if preparedDirectories[startPath]?.isDirectory()
    try
      fail = false
      try
        stat = fs.statSync startPath
      catch
        fail = true
      if !fail && stat.isDirectory()
        preparedDirectories[startPath] = stat
      else
        fs.mkdirSync startPath,0o755
      preparedDirectories[startPath] = fs.statSync startPath
    catch badDog
      console.error "unable to stat/create directory",d,startPath,badDog
  return
  
module.exports.copyStoryAssets= (story)->
  # Loop through all the files in the temp directory
  [siteName,category,slug] = story.id.split '/'
  storySourceAssets = "./sites/#{siteName}/templates/#{category}/#{slug}/"
  try
    fs.statSync storySourceAssets
  catch
    console.error "Noassetdirectory ",storySourceAssets
    return 
  storyPublishedAssets = "./sites/#{siteName}/public/#{category}/#{slug}/"
  storyDraftAssets = "./sites/#{siteName}/public/draft/#{category}/#{slug}/"
  if story.canPublish()
    destDir = storyPublishedAssets
    wipeDir = storyDraftAssets
  else
    destDir = storyDraftAssets
    wipeDir = storyPublishedAssets
  prepareDirectory destDir
  prepareDirectory wipeDir
  try
    copydir= (source,dest)->
      #console.log "Asset copy",source," to",dest
      prepareDirectory dest

      files=fs.readdirSync source
      for file in files
        #console.log "asset file",file
        fromPath = source + "/" + file
        toPath = dest + "/"  + file
        killPath = wipeDir + "/"  + file
        stat = fs.statSync fromPath
        if stat.isFile()
          data = fs.readFileSync fromPath, encoding: null
          fs.writeFileSync toPath,data ,encoding: null,mode: 0o644
          #console.log "asset copy",fromPath,toPath
          #fs.copyFileSync fromPath, toPath,fs.constants.COPYFILE_FICLONE
          try
            fs.unlinkSync killPath
          catch
        else
          #console.log "fromPath",fromPath,"file",file,"toPath",toPath
          copydir fs.realpathSync(fromPath),toPath
    copydir fs.realpathSync(storySourceAssets),fs.realpathSync destDir
  catch badDog
    console.error "failure in asset copy",badDog
  return
