fs = require "fs"

file = __dirname + "/data/named_colours.txt"

# Public: Reads the color file and parses it into an object
#
# Returns: `Object`
parseColors = ->
    console.log "colors parsed"

    data = fs.readFileSync file, "utf-8"

    colorsArr = data.split "\n"
    colorsArr = colorsArr.filter (e) -> e # remove empty items

    colors = {}
    for c in colorsArr
        c = c.split " "
        colors[c[0]] = c[1]

    return colors


module.exports = parseColors()
