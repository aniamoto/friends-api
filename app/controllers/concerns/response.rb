module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def render_success
   render json: { success: true }
  end
end
