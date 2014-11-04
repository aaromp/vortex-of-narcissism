'use strict';

console.log '\'Allo \'Allo! Popup'

class Vortex
  constructor: ->
    streaming = false

    countdown    = document.querySelector '#countdown'
    @video       = document.createElement('video')
    canvas       = document.createElement('canvas')
    background   = document.createElement('div');

    background.classList.add('vortex-background');
    @video.classList.add('vortex-of-narcissism')
    
    toggled = false
    
    width = window.innerWidth
    height = 0
    timer = 3
    
    port = chrome.extension.connect {name: 'test'}
    
    localMediaStream = null
    
    navigator.getMedia = navigator.getUserMedia ||
                         navigator.webkitGetUserMedia
        
    navigator.getMedia
      video: true,
      audio: false,
      ((stream) ->
        localMediaStream = stream
        vendorURL = window.URL || window.webkitURL
        @video.src = vendorURL.createObjectURL stream
        console.log(@video);
        @video.play()
      ).bind(@),
      (err) ->
        console.log "An error occured! " + err
    
    @video.addEventListener('canplay', ((ev) ->
      if !streaming
        height = @video.videoHeight / (@video.videoWidth/width)
        canvas.setAttribute 'width', width
        canvas.setAttribute 'height', height
        streaming = true
    ).bind(@), false)
    
    @video.addEventListener('click', (ev) ->
      ev.preventDefault()
      openVortex()
    , false)

  toggleModal: (message) ->
    document.body.appendChild(@video)
    # if !message.modal then appendModal() else detachModal()
    toggled = !message.modal
  
  processPhotos: (data) ->
    chrome.tabs.query {active: true, currentWindow: true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {image: data}, (response) ->
        if response then window.close()
  
  restoreBrowserAction: ->
    port.postMessage ''
  
  clearPopup: ->
    document.getElementById('countdown').remove()
    document.getElementById('video').remove()
  
  createSpinner: ->
    spinner = document.createElement 'img'
    spinner.setAttribute 'src', '../images/spinner.gif'
    spinner.id = 'spinner'
    document.body.appendChild spinner
  
  snapPicture: ->
    countdown.innerText = 'click!'
    port.postMessage 'click!'
    
    setTimeout(restoreBrowserAction, 2000)
    @video.pause()
    localMediaStream.stop()
  
    clearPopup()
    createSpinner()
  
    canvas.width = width
    canvas.height = height
    canvas.getContext('2d').drawImage @video, 0, 0, width, height
    data = canvas.toDataURL 'image/png'
    processPhotos data
  
  openVortex: ->
    recSetTimeout = (n) ->
      if n < 0 then snapPicture()
  
      setTimeout( ->
        countdown.innerText = n
        port.postMessage("" + n)
        recSetTimeout n-1
      , 1000)
  
    recSetTimeout timer

@vortex = new Vortex()
