class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    before_action :authorize


    def index 
        user = User.find_by(id: session[:user_id])
        if user
            recipe =Recipe.all
            render json: recipe 
        else 
            render json: {errors:  "Invalid username or password"}, status: :unauthorized        end
    end

    def create
        user  = User.find(session[:user_id]) 
        recipe = Recipe.create!(user_id:user.id,title:recipe_params[:title], instructions:recipe_params[:instructions], minutes_to_complete:recipe_params[:minutes_to_complete])
        render json: recipe, status: :created
    end

    private 
    def  recipe_params
        params.permit(:title, :instructions,:minutes_to_complete)
    end
     def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def authorize
        return render json: {errors: ["Not authorized"]}, status: :unauthorized unless session.include? :user_id
    end
end
