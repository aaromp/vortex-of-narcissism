'use strict';

console.log('\'Allo \'Allo! Content script')

styles = ['grayscale', 'hue-rotate-90', 'hue-rotate-180', 'hue-rotate-270']

chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  if (request.image)
    for image in document.images
      image.setAttribute 'src', request.image
      image.className = styles[Math.floor(Math.random() * styles.length)]
    sendResponse({'done': true})

toggled = false

# # add listener for escape key
# document.addEventListener 'keyup', (e) ->
#   if e.keyCode == 27
#     if toggled then chrome.runtime.sendMessage({modal: on}, @vortex.toggleModal)

# # add modal click listener
# background.addEventListener 'click', ->
#   chrome.runtime.sendMessage({modal: on}, @vortex.toggleModal)

# add background script listener
chrome.extension.onMessage.addListener ((message, sender, sendResponse) ->
  @vortex.toggleModal message
  sendResponse({modal: on})
).bind(@)
