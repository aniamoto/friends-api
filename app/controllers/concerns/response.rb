module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def render_success
   render json: { success: true }
  end

  def render_list_with_count(key, list)
   render json: {
     success: true,
     key.to_sym => list,
     count: list.length
   }
  end
end
