descs = require "./file-loader"
req = require "./index"

all =
    prefix: []
    suffix: []

descs.getDescs (allDescs) ->
    descObj = {}

    for desc in allDescs
        descObj[desc.name] = desc

    req.getRequest "prefix", (prefixes) ->
        console.log "prefixes #{prefixes.length}"

        prefixes[1].description = ["Something, cool", "Something else"]
        console.log JSON.stringify prefixes[0], null, "    "
