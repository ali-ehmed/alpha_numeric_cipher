encryptCipher = ->
	$('#convert_btn').on 'click', (e) ->
    e.preventDefault()
    $this = $(this)
    $.ajax
      type: 'get'
      url: 'home/encryption'
      data: plain_text: $('#plain_text').val()
      cache: false
      success: (response) ->
        $response = response
        if $response.status == 'error'
          swal
            title: 'OOPs..!'
            type: 'warning'
            text: '<strong>' + $response.message + '</strong>'
            html: true
        return
      error: (response) ->
        swal 'oops', 'Something went wrong'

decryptCipher = ->
	$('#decrypt_btn').on 'click', (e) ->
    e.preventDefault()
    $this = $(this)
    $.ajax
      type: 'get'
      url: 'home/decryption.json'
      data: cipher_text: $('#encrypted_text').html()
      dataType: "JSON"
      success: (response) ->
        $response = response
        if $response.status == 'error'
          swal
            title: 'OOPs..!'
            type: 'warning'
            text: '<strong>' + $response.message + '</strong>'
            html: true
        else

          swal(
            title: 'Yo..! <strong>Boom</strong>'
            type: 'info'
            text: 'Your Dycrypted Cipher is <strong>' + $response.plain_text + '</strong>'
            html: true)
          $('#dycrypted_text').html("#{$response.plain_text}")
          $('#dycrypted_text').css("font-weight", "bold")
          $('#encrypted_text').css("font-weight", "100")
        return
      error: (response) ->
        swal 'oops', 'Something went wrong'


$(document).on 'page:change', ->
	encryptCipher()
	decryptCipher()