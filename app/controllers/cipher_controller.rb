# Encryption Controller
class CipherController < ApplicationController
	respond_to :json, :html

	# Response that needs be handle in Cipher class
	# Using Simple Delegator to delegate all the functions inside this class for CipherController Class
	class PersistenceResponse < SimpleDelegator
		attr_accessor :converted_text, :message

		def success
			respond_with(status: :created, message: @message, converted_text: converted_text) do |format|
				format.json
			end
		end

		def failure
			respond_with(status: :error, message: @message) do |format|
				format.json
			end
		end
	end

	# Action
	def index
		if request.xhr?
			begin
				cipher = Cipher.new(params[:text])
				cipher.subscribe PersistenceResponse.new(self)
				cipher.send("perform_#{params[:perform]}")
			rescue => e
				response = PersistenceResponse.new self
				response.message = e.message
				response.failure and return
			end
		end
	end
end