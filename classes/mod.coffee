require("string").extendPrototype() # for String.contains

class Mod
    constructor: (arr) ->
        @name      = arr[0]
        @itemlevel = +arr[1] # convert to int
        @stat      = arr[2]
        @value     = arr[3]

        @stat = @stat.split "|" if @stat.contains "|"

        if @value.contains "|"
            @value = @value.split "|"
            split1 = @value[0].split " to "
            split2 = @value[1].split " to "

            @value = [
                {min: split1[0], max: split1[1]}
                {min: split2[0], max: split2[1]}
            ]
        else
            split = @value.split " to "
            @value = [
                {min: split[0], max: split[1]}
            ]
        # TODO: Figure out how to get description from loaded mod-descriptions
        #@description = "" # pseudo fileloader.find @name + stuff with value

module.exports = Mod
