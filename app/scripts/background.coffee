'use strict';

console.log('\'Allo \'Allo! Event Page for Browser Action')

chrome.runtime.onInstalled.addListener (details) ->
    console.log('previousVersion', details.previousVersion)

chrome.browserAction.setBadgeBackgroundColor({color: '#669999'})

chrome.extension.onConnect.addListener (port) ->
  port.onMessage.addListener (message) ->
    chrome.browserAction.setBadgeText({text: message})
