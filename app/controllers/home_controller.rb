class HomeController < ApplicationController
  def index
  end

  def perform_encryption
  	@plain_text = params[:plain_text]

  	if @plain_text.present?
  		splitted_text = @plain_text.delete('').upcase.split("")
  		numpad_hash = cipher_key
  		cipher_text = Array.new
  		@matched_list = []

  		numpad_hash.each do |numpad_key, numpad_val|
  			numpad_val.each.each do |numpad_val|
  				@matched_list << numpad_val
  			end
  		end

  		splitted_text.each_with_index do |s_text, index|
				for matched_val in @matched_list

  				if matched_val == s_text
						numpad_hash.each do |numpad_key, numpad_val|
							numpad_val.each_with_index do |value, index|
								if s_text == value
									cipher_val_index = index
									numpad_number = numpad_key.to_s.split("_").last.to_i
									numpad_number += 3
									unless numpad_number > 9
										generate_key = "numpad_#{numpad_number}".to_sym
										numpad_hash[generate_key]
									else
										numpad_number -= 9
										generate_key = "numpad_#{numpad_number}".to_sym
									end
									cipher_text << numpad_hash[generate_key][cipher_val_index]
								end
							end
						end
  				end

  			end
  		end

  		@cipher_text = cipher_text.join

  		logger.debug "#{cipher_text}"

  		respond_to do |format|
  			format.js
	  	end
  	else
  		respond_to do |format|
	  		format.json { render :json => { status: :error, message: "Please insert some text :)" } }
	  	end
  	end
  end

  def perform_decryption
  	@cipher_text = params[:cipher_text]

  	if @cipher_text.present?
  		splitted_text = @cipher_text.delete('').upcase.split("")

  		numpad_hash = cipher_key
  		@plain_text = Array.new
  		@matched_list = []

  		numpad_hash.each do |numpad_key, numpad_val|
  			numpad_val.each.each do |numpad_val|
  				@matched_list << numpad_val
  			end
  		end

  		splitted_text.each_with_index do |s_text, index|
				for matched_val in @matched_list
  				if matched_val == s_text
						numpad_hash.each do |numpad_key, numpad_val|
							numpad_val.each_with_index do |value, index|

								if s_text == value
									plain_val_index = index
									numpad_number = numpad_key.to_s.split("_").last.to_i			
									numpad_number -= 3
									if numpad_number <= 0
										numpad_number += 9
										generate_key = "numpad_#{numpad_number}".to_sym
									else
										generate_key = "numpad_#{numpad_number}".to_sym
										numpad_hash[generate_key]
									end
									@plain_text << numpad_hash[generate_key][plain_val_index]
								end

							end
						end
  				end

  			end
  		end

  		@plain_text = @plain_text.join

  		logger.debug "--#{@plain_text}--"
  		
  		respond_to do |format|
	  		format.json { render :json => { status: :created, plain_text: @plain_text } }
	  	end
  	else
  		respond_to do |format|
	  		format.json { render :json => { status: :error, message: "Cipher not found :(" } }
	  	end
  	end
  end

  private 

  def cipher_key
  	numpad_hash = {
			numpad_1: ["A", "J", "S"],
			numpad_2: ["B", "K", "T"],
			numpad_3: ["C", "L", "U"],
			numpad_4: ["D", "M", "V"],
			numpad_5: ["E", "N", "W"],
			numpad_6: ["F", "O", "X"],
			numpad_7: ["G", "P", "Y"],
			numpad_8: ["H", "Q", "X"],
			numpad_9: ["I", "R"]
		}
  end
end
