'use strict';

console.log '\'Allo \'Allo! Popup'

class Vortex
  constructor: ->
    streaming = false

    # countdown    = document.querySelector '#countdown'
    @video       = document.createElement('video')
    @canvas       = document.createElement('canvas')
    @background   = document.createElement('div');

    @background.classList.add('vortex-background');
    @video.classList.add('vortex-of-narcissism')
    
    @toggled = false
    
    width = window.innerWidth
    height = 0
    @timer = 3
    
    @port = chrome.extension.connect {name: 'vortex'}
    
    @localMediaStream = null
    
    navigator.getMedia = navigator.getUserMedia ||
                         navigator.webkitGetUserMedia
        
    navigator.getMedia
      video: true,
      audio: false,
      ((stream) ->
        @localMediaStream = stream
        vendorURL = window.URL || window.webkitURL
        @video.src = vendorURL.createObjectURL stream
        # @video.play()
      ).bind(@),
      (err) ->
        console.log "An error occured! " + err
    
    @video.addEventListener('canplay', ((ev) ->
      if !streaming
        height = @video.videoHeight / (@video.videoWidth/width)
        @video.setAttribute 'width', width
        @video.setAttribute 'height', height
        @canvas.setAttribute 'width', width
        @canvas.setAttribute 'height', height
        streaming = true
    ).bind(@), false)
    
    @video.addEventListener('click', ((ev) ->
      ev.preventDefault()
      @openVortex()
    ).bind(@), false)

  appendModal: ->
    console.log('append')
    Array.prototype.forEach.call document.body.children, (child) ->
      child.classList.add 'vortex-blur'
    @video.play()
    document.body.appendChild(@video)
    window.getComputedStyle(@video).transition; # make sure transform is loaded
    @video.classList.add('vortex-toggled')
    document.body.appendChild(@background)

  detachModal: ->
    console.log('detach')
    Array.prototype.forEach.call document.body.children, (child) ->
      child.classList.remove 'vortex-blur'
    @video.pause()
    @video.classList.remove('vortex-toggled')
    @video = document.body.removeChild(@video)
    @background = document.body.removeChild(@background)

  toggleModal: ->
    console.log(@toggled)
    if @toggled then @detachModal() else @appendModal()
    @toggled = !@toggled
  
  processPhotos: (data) ->
    chrome.tabs.query {active: true, currentWindow: true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {image: data}, (response) ->
        if response then window.close()
  
  restoreBrowserAction: ->
    @port.postMessage ''
  
  clearPopup: ->
    # document.getElementById('countdown').remove()
    @video = @video.remove()
  
  createSpinner: ->
    spinner = document.createElement 'img'
    spinner.setAttribute 'src', '../images/spinner.gif'
    spinner.id = 'spinner'
    document.body.appendChild spinner
  
  snapPicture: ->
    # countdown.innerText = 'click!'
    @port.postMessage 'click!'
    
    setTimeout(@restoreBrowserAction, 2000)
    @video.pause()
    @localMediaStream.stop()
  
    @clearPopup()
    @createSpinner()
  
    @canvas.width = width
    @canvas.height = height
    @canvas.getContext('2d').drawImage @video, 0, 0, width, height
    data = canvas.toDataURL 'image/png'
    @processPhotos data
  
  openVortex: ->
    console.log(@port)
    recSetTimeout = ((n) ->
      if n < 0 then @snapPicture()
      console.log(@port)
  
      setTimeout (->
        # countdown.innerText = n
        @port.postMessage("" + n)
        recSetTimeout n-1
      ).bind(@), 1000
    ).bind(@)
  
    recSetTimeout @timer

@vortex = new Vortex()
