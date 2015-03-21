class HomeController < ApplicationController
  def index
  end

  def new
  end

  def search
    if params.has_key?(:postal_code)
      arcgis_service = ArcgisService.new
      @coords = arcgis_service.getCoords(params[:postal_code])
    end
  end

  def graph_init
    if params.has_key?(:roof_area)
      @roof_area = params[:roof_area]
    end
  end

  def graph
    roof_area = 2000
    consumption_monthly = 1500
    if params.has_key?(:roof_area)
      roof_area = params[:roof_area].to_f
    end
    if params.has_key?(:monthly_consumption)
      consumption_monthly = params[:monthly_consumption].to_i
    end

    consumption_yearly = consumption_monthly * 12

    lcoe = 0.1802
    # arearatio = 0.8
    labour = 2
    irradiance = 1630
    lifetime = 20

    si_wattsqm = 215
    si_costpw = 1.794
    si_eff = 0.2

    cdte_wattsqm = 130
    cdte_costpw = 1.7112
    cdte_eff = 0.13

    si_output = si_wattsqm * roof_area
    cdte_output = cdte_wattsqm * roof_area

    si_totalcost = si_output * si_costpw * labour
    cdte_totalcost = cdte_output * cdte_costpw * labour

    si_powergen = irradiance * si_eff * roof_area
    cdte_powergen = irradiance * cdte_eff * roof_area

    # annual_cost = consumption_monthly * lcoe

    si_new_consumption = consumption_yearly - si_powergen
    cdte_new_consumption = consumption_yearly - cdte_powergen

    si_savings = (consumption_yearly - si_new_consumption) * lcoe
    cdte_savings = (consumption_yearly - cdte_new_consumption) * lcoe

    accu_savings = Array.new(20) { Array.new(3, 0) }
    accu_savings[0][1] = -si_totalcost + si_savings
    accu_savings[0][2] = -cdte_totalcost + cdte_savings

    accu_savings.each_with_index do |accu_saving, index|
      accu_saving[0] = index + 1
    end

    accu_savings.each_with_index do |accu_saving, index|
      unless (index == 0)
        accu_saving[1] = accu_savings[index-1][1] + si_savings
        accu_saving[2] = accu_savings[index-1][2] + cdte_savings
      end
    end

    si_new_cost = (si_new_consumption * lcoe) + (si_totalcost / lifetime)
    cdte_new_cost = (cdte_new_consumption * lcoe) + (cdte_totalcost / lifetime)

    si_grad = (accu_savings[19][1] - accu_savings[0][1]) / accu_savings.count
    si_breakeven = si_totalcost / si_grad

    cdte_grad = (accu_savings[19][2] - accu_savings[0][2]) / accu_savings.count
    cdte_breakeven = cdte_totalcost / cdte_grad

    ror_si = si_savings / si_totalcost
    roi_si = (si_savings * lifetime - si_totalcost) / si_totalcost
    ror_cdte = cdte_savings / cdte_totalcost
    roi_cdte = (cdte_savings * lifetime - cdte_totalcost) / cdte_totalcost

    @accu_savings = accu_savings
    @si_new_cost = si_new_cost
    @cdte_new_cost = cdte_new_cost
    @si_breakeven = si_breakeven
    @cdte_breakeven = cdte_breakeven
    if @si_breakeven < @cdte_breakeven
      @smaller_breakeven = @si_breakeven
    else
      @smaller_breakeven = @cdte_breakeven
    end

    @ror_si = ror_si
    @roi_si = roi_si
    @ror_cdte = ror_cdte
    @roi_cdte = roi_cdte

    @si_savings_array = @accu_savings.map{ |as| as[1] }
    @cdte_savings_array = @accu_savings.map{ |as| as[2] }
  end
end

