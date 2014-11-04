'use strict';

console.log('\'Allo \'Allo! Content script')

styles = ['grayscale', 'hue-rotate-90', 'hue-rotate-180', 'hue-rotate-270']

chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  if (request.image)
    console.log 'image!!!'
    for image in document.images
      image.setAttribute 'src', request.image
      image.className = styles[Math.floor(Math.random() * styles.length)]
    sendResponse({'done': true})

