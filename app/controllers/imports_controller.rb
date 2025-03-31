class ImportsController < ApplicationController
    # POST /import
    def create
        service = ImportService.new(request.body.read)

        if service.process
            render json: { logs: logs }
        else
            render json: { logs: logs }, status: :unprocessable_entity
        end
    end
end
