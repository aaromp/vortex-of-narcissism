'use strict';

console.log('\'Allo \'Allo! Option')

navigator.getMedia = navigator.getUserMedia ||
                     navigator.webkitGetUserMedia ||
                     navigator.mozGetUserMedia ||
                     navigator.msGetUserMedia

navigator.getMedia
  video: true,
  audio: false
  ,
  (stream) ->
    console.log 'success!'
  ,
  (err) ->
    console.log 'An error occured! ' + err
