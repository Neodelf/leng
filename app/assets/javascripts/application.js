// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage

//= require_tree .
//= require jquery
//= require jquery_ujs

$(document).ready(function(){
  var timeout = 1000;

  $('.button').on('click', function(e){
    e.preventDefault();
    $this = $(this);
    $.ajax({
      url: '/words/check',
      method: 'GET',
      data: { translation: $this.text(), word_id: $this.data('word-id') } ,
      success: function(data, textStatus) {
        if (data.error) {
          $this.css('background-color', '#f1b5b1');
          setTimeout(function () {
            $this.css('background-color', '#9abaf3');
          }, timeout);
        } else {
          $this.css('background-color', '#aaeaad');
          setTimeout(function(){
            location.reload();
          }, timeout);
        }
      }
    })
  });

  $('#translation').on('keyup', function(e){
    e.preventDefault;
    $this = $(this);

    if ($this.val().length > $this.data()['wordTranslationSize']) {
      $this.val($this.val().substring(0, $this.data()['wordTranslationSize']));
      return;
    };

    if ($this.val().length != $this.data()['wordTranslationSize']) {
      return;
    };

    $this.prop('readonly', true);

    $.ajax({
      url: '/words/translation',
      method: 'GET',
      data: { translation: $this.val(), word_id: $this.data('wordId') } ,
      success: function(data, textStatus) {
        if (data.error) {
          $this.css('color', '#f1b5b1');
          setTimeout(function () {
            $this.css('color', 'black');
            $this.prop('readonly', false);
          }, timeout);
        } else {
          $this.css('color', '#aaeaad');
          setTimeout(function(){
            location.reload();
          }, timeout);
        };
      }
    })
  });

  $('#source').on('keyup', function(e){
    e.preventDefault;
    $this = $(this);

    if ($this.val().length > $this.data()['wordSourceSize']) {
      $this.val($this.val().substring(0, $this.data()['wordSourceSize']));
      return;
    };

    if ($this.val().length != $this.data()['wordSourceSize']) {
      return;
    };

    $this.prop('readonly', true);

    $.ajax({
      url: '/words/source',
      method: 'GET',
      data: { translation: $this.val(), word_id: $this.data('wordId') } ,
      success: function(data, textStatus) {
        if (data.error) {
          $this.css('color', '#f1b5b1');
          setTimeout(function () {
            $this.css('color', 'black');
            $this.prop('readonly', false);
          }, timeout);
        } else {
          $this.css('color', '#aaeaad');
          setTimeout(function(){
            location.reload();
          }, timeout);
        };
      }
    })
  });

  $('body > div > div.top > button').on('click', function(){
    location.reload();
  });
})
