cheerio = require "cheerio"
$ = null
request = require "request"
#stats = require("./stat-description-regex").stats

Category = require "./classes/category"
Mod      = require "./classes/mod"
ModDescription = require "./classes/mod-description"

poeUrl = "http://www.pathofexile.com"

saved =
    prefix: null
    suffix: null

getRequest = (url, cb) ->
    return cb saved[url] if saved[url] isnt null

    # TODO: Pair up with file-loader and mod-description
    request "#{poeUrl}/item-data/#{url}mod", (err, res, body) ->
        throw err if err
        console.log "requesting"
        $ = cheerio.load body # load body html into $

        categories = [] # list of all categories

        $(".layoutBoxFull").each (i, el) -> # div h1 + div.layoutBoxContent
            $el = $ el

            $h1 = $el.find "h1.layoutBoxTitle"
            $table = $el.find "table.itemDataTable"

            cat = new Category $h1.text() # Category containing mods

            $table.find("tr").each (i1, tr) ->
                $tr = $ tr

                $tr.html $tr.html().replace /<br>/g, "|" # Replace <br> tags.
                text = $tr.text() # Use text value
                text = text.replace(/\t/g, "").trim() # Replace tabs and trim newlines

                arr = text.split "\n" # Split into array
                mod = new Mod arr

                cat.add mod # Add mod to current category

            categories.push cat # Add to all categories

            #return false if i is 1# FIXME:
        saved[url] = categories
        return cb categories

module.exports.getRequest = getRequest
