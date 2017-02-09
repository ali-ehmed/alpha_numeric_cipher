class HomeController < ApplicationController
	respond_to :json, :html

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

  def index
		if request.xhr?
			begin
				security = Security.new(params[:text])
				security.subscribe PersistenceResponse.new(self)
				security.send("perform_#{params[:perform]}")
			rescue => e
				response = PersistenceResponse.new self
				response.message = e.message
				response.failure and return
			end
		end
	end
end
