class Category
    constructor: (@name) ->
        @mods = []

    add: (mod) ->
        if mod.name is "Name" then return
        @mods.push mod

        #console.log "Added #{mod.name} to #{@name} length is #{@mods.length}"

module.exports = Category
