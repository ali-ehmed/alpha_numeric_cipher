isNumeric = (myString) ->
  return /\d/.test(myString);

validateText = (text) ->
  valid = true
  if text == ''
    valid = false
    swal
      title: 'Oops..!'
      type: 'warning'
      text: '<strong>Please Enter Text</strong>'
      html: true

  if isNumeric(text)
    valid = false
    swal
      title: 'Oops..!'
      type: 'warning'
      text: '<strong>Plain text must be string</strong>'
      html: true
  valid

encryptCipher = ->
	$('#convert_btn').on 'click', (e) ->
    e.preventDefault()
    $this = $(this)
#    if validateText($('#plain_text').val())
    $.ajax
      type: 'get'
      url: 'home/index.json'
      data: text: $('#plain_text').val(), perform: "encryption"
      cache: false
      dataType: "JSON"
      success: (response) ->
        $response = response
        if $response.status == 'error'
          swal
            title: 'Oops..!'
            type: 'warning'
            text: $response.message
            html: true
        else
          swal({
            title: 'Yo..! <strong>Boom</strong>',
            type: 'info',
            text: $response.message,
            html: true
          });

          $('#encrypted_text').html("#{$response.converted_text}");
          $('#encrypted_text').css("font-weight", "bold")
          $('#dycrypted_text').css("font-weight", "100")
        return
      error: (response) ->
        swal 'oops', 'Something went wrong'

decryptCipher = ->
	$('#decrypt_btn').on 'click', (e) ->
    e.preventDefault()
    $this = $(this)
    if validateText($('#encrypted_text').html())
      $.ajax
        type: 'get'
        url: 'home/index.json'
        data: text: $('#encrypted_text').html(), perform: "decryption"
        dataType: "JSON"
        success: (response) ->
          $response = response
          if $response.status == 'error'
            swal
              title: 'Oops..!'
              type: 'warning'
              text: $response.message
              html: true
          else
            swal(
              title: 'Yo..! <strong>Boom</strong>'
              type: 'info'
              text: $response.message
              html: true)
            $('#dycrypted_text').html("#{$response.converted_text}")
            $('#dycrypted_text').css("font-weight", "bold")
            $('#encrypted_text').css("font-weight", "100")
          return
        error: (response) ->
          swal 'oops', 'Something went wrong'


$(document).on 'page:change', ->
	encryptCipher()
	decryptCipher()