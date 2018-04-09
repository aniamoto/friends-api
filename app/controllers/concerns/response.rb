module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def render_success
   render json: { success: true }
  end

  def render_list(key, list, count = false)
   response = { success: true, key.to_sym => list }
   response.merge!(count: list.length) if count

   render json: response
  end
end
