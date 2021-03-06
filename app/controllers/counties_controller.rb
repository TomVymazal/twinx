# encoding: UTF-8
class CountiesController < ApplicationController
  def index
    @counties = County.order('title')
  end

  def show
    @county = County.find(params[:id])
  end

  def new
    @county = County.new
  end

  def edit
    @county = County.find(params[:id])
  end

  def create
    @county = County.new(params[:county])
    if @county.save
      redirect_to @county, notice: "Jednota byla úspěšně vytvořena."
    else
      render action: "new"
    end
  end

  def update
    @county = County.find(params[:id])
    if @county.update_attributes(params[:county])
      redirect_to @county, notice: "Jednota byla úspěšně upravena."
    else
      render action: "edit"
    end
  end

  def destroy
    @county = County.find(params[:id])
    @county.destroy
    redirect_to counties_url
  end
end
