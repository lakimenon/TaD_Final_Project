await dk.set({proxy: 'none', block: ['image', 'vendor']})

var results = []
for (var k of ['1', '2', '3', '4', '5']) {
    await dk.goto(`https://www.rev.com/blog/transcript-tag/coronavirus-update-transcripts/page/${k}`)
    var data =  await dk.collect([
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
results = results.concat(data)
}

return results
