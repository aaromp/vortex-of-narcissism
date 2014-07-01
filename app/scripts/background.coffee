'use strict';

chrome.runtime.onInstalled.addListener (details) ->
    console.log('previousVersion', details.previousVersion)

# chrome.browserAction.setBadgeText({text: '\'Allo'})
chrome.browserAction.setBadgeBackgroundColor({color: '#669999'})

chrome.extension.onConnect.addListener (port) ->
  # console.log 'connected...'
  port.onMessage.addListener (message) ->
    chrome.browserAction.setBadgeText({text: message})
    # alert "message recieved #{message}"
    # port.postMessage 'hi popup!'

console.log('\'Allo \'Allo! Event Page for Browser Action')
