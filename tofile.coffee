fs = require "fs"
ind = require "./index"

ind.getRequest "prefix", (categories) ->
    fs.writeFile "parsed-data/prefixes.json", JSON.stringify(categories, null, "  "), (err) ->
        throw err if err
        console.log "saved file"
