fs = require "fs"

req = require "./index"
ModDescription = require "./classes/mod-description"

splitPattern = /\n\s*\n/ # last element always has extra newline. ModDescription doesn't care about this so do we need to fix?

file = __dirname + "/data/stat_descriptions_clean.txt"


allDescs = []

fs.readFile file, "utf-8", (err, data) ->
    throw err if err

    split = data.split splitPattern # Split descriptions into an array

    allDescs.push new ModDescription desc for desc in split # Create an array of mod descriptions

getDescs = (cb) ->
    return cb allDescs if allDescs.length isnt 0

    fs.readFile file, "utf-8", (err, data) ->
        throw err if err

        split = data.split splitPattern # Split descriptions into an array

        allDescs.push new ModDescription desc for desc in split # Create an array of mod descriptions

        return cb allDescs

module.exports.getDescs = getDescs
###
    toFind = "Local Flask Amount To Recover +%"

    for desc in allDescs
        toFind = toFind.toLowerCase().replace /\s/g, "_"

        if desc.name is toFind
            console.log desc

req.getRequest "prefix", (categories) ->
    # allDescs, categories
    cat = categories[7] # FIXME: Fails on hybrid mods
    mod = cat.mods[0]
    toFind = mod.stat
    toFind = toFind.toLowerCase().replace /\s/g, "_"

    for desc in allDescs
        if desc.name is toFind
            val = mod.value[0].split(" to ")
            realDescMin = desc.parseDesc 0, "(#{val[0]}-#{val[1]})"
            #realDescMax = desc.parseDesc 0, val[1]

            console.log realDescMin
###
