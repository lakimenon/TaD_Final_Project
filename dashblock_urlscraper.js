// await dk.set({block: ['style', 'vendor']})
//
// // Create empty array with length 44 for num pages
// // var pages = new Array(44).keys();
// // return pages
// var pages = Array.from({length: 44}, (x,i) => i);
// // return pages
// for (i = 1; i < 45; i++) {
//   await dk.goto(`https://www.rev.com/blog/transcript-tag/coronavirus-update-transcripts/page/{i}`)
// // await dk.goto(`https://www.rev.com/blog/transcript-tag/coronavirus-update-transcripts`)
// var data = await dk.collect([
//     {
//         name: 'title',
//         selection: {
//             css: 'div.fl-post-column > div > a div.card > div > strong'
//         }
//     },
//     {
//         name: 'url',
//         format: 'URL',
//         selection: {
//             css: 'div.fl-post-column > div > a'
//         }
//     }
// ])
//
// return data
//
// }

// await dk.set({block: ['style', 'vendor']})
// var i;
// await dk.goto(`https://www.rev.com/blog/transcript-tag/coronavirus-update-transcripts`)


// var data = await dk.collect([
//     {
//         name: 'title',
//         selection: {
//             css: 'div.fl-post-column > div > a div.card > div > strong'
//         }
//     },
//     {
//         name: 'url',
//         format: 'URL',
//         selection: {
//             css: 'div.fl-post-column > div > a'
//         }
//     }
// ])



// var pages = Array.from({length: 44}, (x,i) => i);
// return pages

await dk.set({block: ['style', 'vendor']})

// Create empty array with length 44 for num pages
// var pages = new Array(44).keys();
// return pages
var pages = Array.from({length: 44}, (x,i) => i);
// return pages
for (p in pages) {
// for (i = 1; i < 45; i++) {
  await dk.goto(`https://www.rev.com/blog/transcript-tag/coronavirus-update-transcripts/page/` + pages[p])
// await dk.goto(`https://www.rev.com/blog/transcript-tag/coronavirus-update-transcripts`)
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

}


// await dk.set({block: ['style', 'vendor']})
// var pages = Array.from({length: 44}, (x,i) => i)
// for (p in pages) {
//     pages[p]
// }
// await dk.goto(`https://www.rev.com/blog/transcript-tag/coronavirus-update-transcripts/page/1`)


// var data = await dk.collect([
//     {
//         name: 'title',
//         selection: {
//             css: 'div.fl-post-column > div > a div.card > div > strong'
//         }
//     },
//     {
//         name: 'url',
//         format: 'URL',
//         selection: {
//             css: 'div.fl-post-column > div > a'
//         }
//     }
// ])

// return data


// await dk.set({block: ['style', 'vendor']})

// // Create empty array with length 44 for num pages
// // var pages = new Array(44).keys();
// // return pages
// var pages = Array.from({length: 44}, (x,i) => i);
// // return pages
// for (p in pages) {
// // for (i = 1; i < 45; i++) {
//   await dk.goto(`https://www.rev.com/blog/transcript-tag/coronavirus-update-transcripts/page/` + pages[p])
// // await dk.goto(`https://www.rev.com/blog/transcript-tag/coronavirus-update-transcripts`)
// var data = await dk.collect([
//     {
//         name: 'title',
//         selection: {
//             css: 'div.fl-post-column > div > a div.card > div > strong'
//         }
//     },
//     {
//         name: 'url',
//         format: 'URL',
//         selection: {
//             css: 'div.fl-post-column > div > a'
//         }
//     }
// ])

// return data

// }
