await dk.set({block: ['style', 'vendor']})
await dk.goto(`https://www.rev.com/blog/transcript-tag/coronavirus-update-transcripts`)
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

return data
