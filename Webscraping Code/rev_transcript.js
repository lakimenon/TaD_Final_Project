
await dk.set({proxy: 'none', block: ['image', 'vendor']})
await dk.goto(`https://www.rev.com/blog/transcripts/mike-dewine-ohio-coronavirus-briefing-transcript-april-23`)

var data =  await dk.collect([
    {
        name: 'title',
        selection: {
            css: 'div.resources div.fl-row-content.fl-row-fixed-width.fl-node-content > div:nth-child(2) h1 > span'
        }
    },
    {
        name: 'date',
        format: 'DATE',
        selection: {
            css: 'div.resources div.fl-row-content.fl-row-fixed-width.fl-node-content > div:nth-child(2) div.fl-rich-text > p'
        }
    },
    {
        name: 'description',
        selection: {
            css: 'div.resources div.fl-row-content.fl-row-fixed-width.fl-node-content > div:last-child div.fl-rich-text > p:first-child'
        }
    },
    {
        name: 'transcripts',
        schema : [
            {
                name: 'extracts',
                value : {
                    content: 2
                },
                selection: {
                    css: 'div.resources div.fl-row-content.fl-row-fixed-width.fl-node-content > div:last-child div.fl-callout-text > p'
                }
            }
        ]
    },
])

return data
