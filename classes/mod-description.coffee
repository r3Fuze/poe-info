statPattern = ///
    ^description[\ \t]*\n   # Match 'description' on first line and then space or tab (error by GGG)
    \t([0-9])\ +(.*)\n      # Match tab then catch the number, one or more spaces (error by GGG) and catch content until newline
    (?:\t([0-9])\t*?\n)?    # Match tab then catch the number then match any tabs, everything is optional because -> (error by GGG)
    \t*(.*)\n?              # Match any tabs then catch content until newline (optional for now because of newline)
    \t*(.*)\n?              # Optionally match any tabs then catch content until newline (find a way to avoid duplication using {1,3})
    \t*(.*)\n?              # ^
    \t*(.*)\n?              # ^
///

descPattern = ///
    (.*)(?:\ |\t)\"(.*)\"   # Capture value tester then capture content inside quotes. Space or tab (error by GGG)
    (?:\ (.*))?             # Optionally catch any modifiers
///

valuePattern = /%((?:\d|d))(%|\$\+d)/

class ModDescription
    constructor: (stat) ->
        patternMatch = statPattern.exec stat

        patternMatch.shift() # Should we just not do this?
        descMatch = descPattern.exec patternMatch[3]
        descMatch.shift()

        descs = patternMatch.splice 3, 6 # Select only descriptions
        descs = descs.filter (e) -> e # Removes empty items

        @descList = descs

        @name = patternMatch[1]
        #console.log "hybrid #{@name}" if @name.indexOf(" ") isnt -1
        @numMods = +patternMatch[0]      # convert to number
        @numDesc = +patternMatch[2] || 1 # ^ Default to 1 if the value didn't exist (self_shock_duration, error by GGG)


    parseDesc: (descIndex = 0, args...) ->
        if not @descList[descIndex] then descIndex = @descList.length - 1 # Use the last element if descList if index was too high

        desc = descPattern.exec @descList[descIndex] # Just use first element for now..
        desc = desc[2] # [2] is the description without value testing
        desc = desc.replace valuePattern, (match, num, plus) -> # Matches %1% and %1$+d. Prefix with + if $+d
            if num is "d" then num = 1
            if plus is "$+d" then prefix = "+" else prefix = "" # Prefix with + if it was $+d
            prefix + args[+num - 1] # Replace match with index from array. Convert to int and subtract to make it 0-index

        desc = desc.replace "%%", "%"

        return desc

module.exports = ModDescription
