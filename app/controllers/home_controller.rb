class HomeController < ApplicationController
  def index
  end

  def perform_encryption
  	@plain_text = params[:plain_text].split(".").first

  	if is_number?(@plain_text)
  		@cipher_text = "#{@plain_text}. Please use your name INSTEAD"
  		return
  	end
		number_text = @plain_text.scan(/\d+/).join
		logger.debug "#{number_text}"
  	

  	if @plain_text.present?
  		split_text = @plain_text.delete('').upcase.split("")
  		num_pad_hash = cipher_key
  		cipher_text = Array.new
  		@matched_list = []

  		num_pad_hash.each do |num_pad_key, num_pad_val|
  			num_pad_val.each.each do |num_pad_val|
  				@matched_list << num_pad_val
  			end
  		end

  		split_text.each_with_index do |s_text, index|
				for matched_val in @matched_list

  				if matched_val == s_text

						num_pad_hash.each do |num_pad_key, num_pad_val|
							num_pad_val.each_with_index do |value, index|
								if s_text == value

									cipher_val_index = index
									num_pad_number = num_pad_key.to_s.split("_").last.to_i
									num_pad_number += 3

									unless num_pad_number > 9
										generate_key = "num_pad_#{num_pad_number}".to_sym
										num_pad_hash[generate_key]
									else
										num_pad_number -= 9
										generate_key = "num_pad_#{num_pad_number}".to_sym
									end
									logger.debug "--#{generate_key}--"
									cipher_text << num_pad_hash[generate_key][cipher_val_index]
								end
							end
						end
  				end

  			end
  		end

  		@cipher_text = cipher_text.join << number_text

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
  	@cipher_text = params[:cipher_text].split(".").first

  	if is_number?(@cipher_text)
  		@plain_text = "#{@cipher_text}. Please use your name INSTEAD"
  		render :json => { status: :created, plain_text: @plain_text }
  		return
  	end
		number_text = @cipher_text.scan(/\d+/).join
		logger.debug "#{number_text}"

  	if @cipher_text.present?
  		split_text = @cipher_text.delete('').upcase.split("")

  		num_pad_hash = cipher_key
  		@plain_text = Array.new
  		@matched_list = []

  		num_pad_hash.each do |num_pad_key, num_pad_val|
  			num_pad_val.each.each do |num_pad_val|
  				@matched_list << num_pad_val
  			end
  		end

  		split_text.each_with_index do |s_text, index|
				for matched_val in @matched_list
  				if matched_val == s_text
						num_pad_hash.each do |num_pad_key, num_pad_val|
							num_pad_val.each_with_index do |value, index|

								if s_text == value
									plain_val_index = index
									num_pad_number = num_pad_key.to_s.split("_").last.to_i			
									num_pad_number -= 3
									if num_pad_number <= 0
										num_pad_number += 9
										generate_key = "num_pad_#{num_pad_number}".to_sym
									else
										generate_key = "num_pad_#{num_pad_number}".to_sym
										num_pad_hash[generate_key]
									end

									@plain_text << num_pad_hash[generate_key][plain_val_index]
								end

							end
						end
  				end

  			end
  		end

  		@plain_text = @plain_text.join << number_text
  		
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

  def is_number? string
	  true if Float(string) rescue false
	end
 

  def cipher_key
  	num_pad_hash = {
			num_pad_1: ["A", "J", "S"],
			num_pad_2: ["B", "K", "T"],
			num_pad_3: ["C", "L", "U"],
			num_pad_4: ["D", "M", "V"],
			num_pad_5: ["E", "N", "W"],
			num_pad_6: ["F", "O", "X"],
			num_pad_7: ["G", "P", "Y"],
			num_pad_8: ["H", "Q", "Z"],
			num_pad_9: ["I", "R"]
		}
  end
end
