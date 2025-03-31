class ImportsController < ApplicationController
    # POST /import
    def create
        service = ImportService.new(request.body.read)

        if service.process
            render json: { logs: service.logs }
        else
            error_message = service.logs.first[:error] || "Import failed"
            render json: { error: error_message, logs: service.logs }, status: :unprocessable_entity
        end
    end
end
