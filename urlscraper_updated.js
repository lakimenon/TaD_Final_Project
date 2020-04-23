

const array2 = Array.from({length: 44}, (x,i) => i)

// initialize array
var all_urls = [ ]

for (const element of array2) {

    await dk.set({block: ['style', 'vendor']})
    await dk.goto("https://www.rev.com/blog/transcript-tag/coronavirus-update-transcripts/page/" + (element+1))
    var data = await dk.collect([
        {
            name: 'title',
            selection: {
                css: 'div.fl-post-column > div > a div.card > div > strong'
            }
        },
        {
            name: 'url',
            format: 'URL',
            selection: {
                css: 'div.fl-post-column > div > a'
            }
        }
    ])
    // append new value to the array
    // all_urls.push(data)
    all_urls.concat(data)

}

return all_urls
