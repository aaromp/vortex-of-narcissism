'use strict';

console.log('\'Allo \'Allo! Content script')

chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  if (request.image)
    console.log 'image!!!'
    for image in document.images
      image.setAttribute 'src', request.image
      image.className = request.filter
    sendResponse({'done': true})

