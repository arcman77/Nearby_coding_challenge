class MessagesController < ApplicationController
  require 'json'

  def create
    @new_message = Message.new(message_params)
    begin
      @new_message.save
    rescue ActiveRecord::RecordInvalid => e
      render json: {error: e.record.errors.details}, status: 400
    end
    render nothing: true, status: 204
  end

  def show
    @message = Message.find_by(message_id: params[:id])
    if @message
      render json: @message.serial_string, status: 200
    else
      render nothing: true, status: 404
    end
  end

  private

  def message_params
    ##if we're saving the entire message object:

    #serial_string = params.permit(:id, :threadId,:labelIds,:snippet, :historyId, :internalDate, :payload, :sizeEstimate).to_json  --> this wont work since there are nested attributes
    #####
      #I could continue in the manner shown below with test, progressively premitting more deeply nested attributes, but at this point I don't know which keys are immutable and which objects (that contain keys) are really arbitrary values
    #####
    # test = params.permit(:id, :threadId,:labelIds,:snippet, :historyId, :internalDate, :payload, :sizeEstimate)
    # test[:labelIds] = params[:labelIds]
    # test[:payload]  = params.require(:payload).permit(:mimeType, :filename, :headers, :body, :parts)
    # ect...

    id = params[:id]
    serial_string = params.to_json
    { serial_string: serial_string, message_id: id}
    ##if we're saving the payload object only:
    #params.require(:payload).permit(:mimeType, :filename, :headers, :body, :parts)
  end
end
