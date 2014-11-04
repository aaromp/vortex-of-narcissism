'use strict';

console.log('\'Allo \'Allo! Event Page for Browser Action')

chrome.runtime.onInstalled.addListener (details) ->
    console.log('previousVersion', details.previousVersion)

chrome.browserAction.setBadgeBackgroundColor({color: '#EB2293'})

chrome.extension.onConnect.addListener (port) ->
  port.onMessage.addListener (message) ->
    chrome.browserAction.setBadgeText({text: message})

toggled = false

chrome.browserAction.onClicked.addListener (tab) ->
  console.log('sending click from bs')
  chrome.tabs.sendMessage tab.id, {modal: true}, (response) ->
    toggled = response.modal

chrome.runtime.onMessage.addListener (message, sender, sendResponse) ->
  toggled = !message.modal
  sendResponse({modal: !toggled})
