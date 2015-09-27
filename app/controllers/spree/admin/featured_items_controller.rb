module Spree
  module Admin
    class FeaturedItemsController < ResourceController
      
      protected

      def collection
        return @collection if defined?(@collection)
        params[:q] ||= HashWithIndifferentAccess.new
        params[:q][:s] ||= 'id desc'

        @collection = super
        @search = @collection.ransack(params[:q])
        @collection = @search.result(distinct: true).
          page(params[:page]).
          per(params[:per_page] || 15)

        @collection
      end

    end
  end
end
