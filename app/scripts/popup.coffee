'use strict';

console.log '\'Allo \'Allo! Popup'

readyStateCheckInterval = setInterval( ->
  if document.readyState is 'complete'
    clearInterval(readyStateCheckInterval);
    streaming = false
    countdown    = document.querySelector '#countdown'
    video        = document.querySelector '#video'
    previous     = document.querySelector '#previous'
    next         = document.querySelector '#next'
    
    width = window.innerWidth
    height = 0
    timer = 3

    styles = ['grayscale', 'sepia', 'saturate', 'hue-rotate', 'invert', 'opacity', 'brightness', 'contrast', 'blur', 'drop-shadow', 'normal']
    counter = 0

    port = chrome.extension.connect {name: 'test'}

    localMediaStream = null
    
    navigator.getMedia = navigator.getUserMedia ||
                         navigator.webkitGetUserMedia ||
                         navigator.mozGetUserMedia ||
                         navigator.msGetUserMedia
        
    navigator.getMedia
      video: true,
      audio: false
      ,
      (stream) ->
        localMediaStream = stream
        if navigator.mozGetUserMedia
          video.mozSrcObject = stream
        else
          vendorURL = window.URL || window.webkitURL
          video.src = vendorURL.createObjectURL stream
        video.play()
      ,
      (err) ->
        console.log "An error occured! " + err
    
    video.addEventListener('canplay', (ev) ->
      if !streaming
        height = video.videoHeight / (video.videoWidth/width)
        video.setAttribute 'width', width
        video.setAttribute 'height', height
        canvas.setAttribute 'width', width
        canvas.setAttribute 'height', height
        streaming = true
    , false)
    
    processPhotos = (data, filter) ->
      chrome.tabs.query {active: true, currentWindow: true}, (tabs) ->
        chrome.tabs.sendMessage(tabs[0].id, {image: data, filter: filter})

    restoreBrowserAction = ->
      port.postMessage ''

    getIndex = (counter) ->
      index = counter % styles.length
      if counter < 0 then index = styles.length - (Math.abs counter % styles.length)
      index
    
    takepicture = ->
        doSetTimeout = (n) ->
          if n < 0
            countdown.innerText = 'click!'
            port.postMessage 'click!'
            
            setTimeout(restoreBrowserAction, 2000)
            video.pause()
            localMediaStream.stop()
    
            document.getElementById('video').remove()
            canvas = document.createElement('canvas')
    
            canvas.width = width
            canvas.height = height
            canvas.getContext('2d').drawImage video, 0, 0, width, height
            data = canvas.toDataURL 'image/png'
            processPhotos data, styles[getIndex counter]
    
            return
    
          setTimeout( ->
            countdown.innerText = n
            port.postMessage("" + n)
            doSetTimeout n-1
          , 1000)
    
        doSetTimeout timer
      
      video.addEventListener('click', (ev) ->
        takepicture()
        ev.preventDefault()
      , false)

      previous.addEventListener('click', (ev) ->
        counter--
        
        video.className = styles[getIndex counter]
        ev.preventDefault()
      , false)

      next.addEventListener('click', (ev) ->
        counter++

        video.className = styles[getIndex counter]
        ev.preventDefault()
      , false)
    
, 10)
  