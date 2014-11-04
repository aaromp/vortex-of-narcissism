'use strict';

console.log '\'Allo \'Allo! Popup'

styles = ['grayscale', 'hue-rotate-90', 'hue-rotate-180', 'hue-rotate-270']

class Vortex
  constructor: ->
    # countdown    = document.querySelector '#countdown'
    @video        = document.createElement 'video'
    @canvas       = document.createElement 'canvas'
    @spinner      = document.createElement 'img'
    @background   = document.createElement 'div'

    @video.classList.add 'vortex-of-narcissism'
    @spinner.classList.add 'vortex-spinner'
    @background.classList.add 'vortex-background'
    
    @timer = 3
    @width = window.innerWidth
    @height = 0
    @toggled = false
    streaming = false
    @localMediaStream = null
    
    @port = chrome.extension.connect {name: 'vortex'}
    
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
        @height = @video.videoHeight / (@video.videoWidth/@width)
        @video.setAttribute 'width', @width
        @video.setAttribute 'height', @height
        @canvas.setAttribute 'width', @width
        @canvas.setAttribute 'height', @height
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
    @clearVideo()
    @clearBackground()

  toggleModal: ->
    console.log(@toggled)
    if @toggled then @detachModal() else @appendModal()
    @toggled = !@toggled
  
  processPhotos: ->
    @canvas.getContext('2d').drawImage @video, 0, 0, @width, @height
    data = @canvas.toDataURL 'image/png'
    Array.prototype.forEach.call document.images, (image) ->
      image.src = data
      image.classList.add styles[Math.floor(Math.random() * styles.length)]
    @spinner = document.body.removeChild(@spinner)
    @clearBackground()
    @toggled = !@toggled
  
  restoreBrowserAction: ->
    @port.postMessage ''
  
  clearVideo: ->
    console.log('this video', @video)
    @video.pause()
    @video.classList.remove('vortex-toggled')
    @video = document.body.removeChild(@video)

  clearBackground: ->
    Array.prototype.forEach.call document.body.children, (child) ->
      child.classList.remove 'vortex-blur'
    @background = document.body.removeChild(@background)
  
  snapPicture: ->
    # countdown.innerText = 'click!'
    @port.postMessage 'click!'
    setTimeout(@restoreBrowserAction.bind(@), 2000)
    
    @clearVideo()
    @localMediaStream.stop()
    document.getElementsByTagName('video');
    @spinner.src = chrome.extension.getURL '/images/spinner.gif'
    document.body.appendChild @spinner
    
    setTimeout(@processPhotos.bind(@), 1000)
  
  openVortex: ->
    recSetTimeout = ((n) ->
      if n < 0
        @snapPicture()
      else
        console.log(n)
    
        setTimeout (->
          # countdown.innerText = n
          @port.postMessage("" + n)
          recSetTimeout n-1
        ).bind(@), 1000
    ).bind(@)
  
    recSetTimeout @timer

@vortex = new Vortex()
