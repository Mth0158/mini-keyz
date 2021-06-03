require 'rails_helper'

RSpec.describe IncomeTaxesBaseFormulas do
  let(:simulation_lyon) do
    Simulation.new({
                     house_city: 'Lyon 01',
                     house_price_bought_amount: 500_000,
                     house_first_works_amount: 25_000,
                     house_total_charges_amount_per_year: 2750,
                     house_property_tax_amount_per_year: 2500,
                     house_rent_amount_per_month: 2500,
                     house_property_management_cost_percentage: 0,
                     credit_loan_amount: 550_000,
                     credit_loan_duration: 20,
                     fiscal_status: 'Vide',
                     fiscal_regimen: 'Réel',
                     fiscal_revenues_p1: 75_000,
                     fiscal_revenues_p2: 25_000,
                     fiscal_nb_parts: 3
                   })
  end

  let(:simulation_bordeaux) do
    Simulation.new({
                     house_city: 'Bordeaux',
                     house_price_bought_amount: 100_000,
                     house_first_works_amount: 0,
                     house_total_charges_amount_per_year: 500,
                     house_property_tax_amount_per_year: 300,
                     house_rent_amount_per_month: 450,
                     house_property_management_cost_percentage: 0.08,
                     credit_loan_amount: 100_000,
                     credit_loan_duration: 20,
                     fiscal_status: 'LMNP',
                     fiscal_regimen: 'Réel',
                     fiscal_revenues_p1: 25_000,
                     fiscal_revenues_p2: 35_000,
                     fiscal_nb_parts: 4
                   })
  end

  # describe "#calc_income_tax_amount_per_year" do
  #   it "returns the income tax amont per year" do
  #     result_lyon = IncomeTaxesBaseFormulas.calc_income_tax_amount_per_year()
  #   end
  # end

  describe '#calc_global_net_taxable_amount' do
    context 'when it has no property income' do
      it 'returns the net taxable amount' do
        result_lyon = IncomeTaxesBaseFormulas.calc_global_net_taxable_amount(simulation_lyon)
        result_bordeaux = IncomeTaxesBaseFormulas.calc_global_net_taxable_amount(simulation_bordeaux)
        expect(result_lyon).to be_within(0.01).of(90_000)
        expect(result_bordeaux).to be_within(0.01).of(54_000)
      end
    end

    context 'when it has some property income' do
      it 'returns the net taxable amount' do
        result_lyon = IncomeTaxesBaseFormulas.calc_global_net_taxable_amount(simulation_lyon, 20_000)
        result_bordeaux = IncomeTaxesBaseFormulas.calc_global_net_taxable_amount(simulation_bordeaux, 2_000)
        expect(result_lyon).to be_within(0.01).of(110_000)
        expect(result_bordeaux).to be_within(0.01).of(56_000)
      end
    end
  end

  describe '#calc_family_quotient_amount' do
    context 'when it has no property income' do
      it 'returns the family quotient amount' do
        result_lyon = IncomeTaxesBaseFormulas.calc_family_quotient_amount(90_000, simulation_lyon[:fiscal_nb_parts])
        result_bordeaux = IncomeTaxesBaseFormulas.calc_family_quotient_amount(54_000,
                                                                              simulation_bordeaux[:fiscal_nb_parts])
        expect(result_lyon).to be_within(0.01).of(30_000)
        expect(result_bordeaux).to be_within(0.01).of(13_500)
      end
    end

    context 'when it has some property income' do
      it 'returns the family quotient amount' do
        result_lyon = IncomeTaxesBaseFormulas.calc_family_quotient_amount(110_000, simulation_lyon[:fiscal_nb_parts])
        result_bordeaux = IncomeTaxesBaseFormulas.calc_family_quotient_amount(56_000,
                                                                              simulation_bordeaux[:fiscal_nb_parts])
        expect(result_lyon).to be_within(0.01).of(36_666.67)
        expect(result_bordeaux).to be_within(0.01).of(14_000)
      end
    end
  end

  describe '#calc_aggregated_tax_amount' do
    it 'returns the aggregated tax amount' do
      current_year = Date.today.year
      result_lyon = IncomeTaxesBaseFormulas.calc_aggregated_tax_amount(30_000, current_year)
      result_bordeaux = IncomeTaxesBaseFormulas.calc_aggregated_tax_amount(14_000, current_year)
      expect(result_lyon).to be_within(0.01).of(3005.45)
      expect(result_bordeaux).to be_within(0.01).of(430.65)
    end
  end

  describe '#calc_income_taxes_scale' do
    context 'when it has no property income' do
      it 'returns the family quotient amount' do
        result_lyon = IncomeTaxesBaseFormulas.calc_income_taxes_scale(simulation_lyon)
        result_bordeaux = IncomeTaxesBaseFormulas.calc_income_taxes_scale(simulation_bordeaux)
        expect(result_lyon).to eq({ family_quotient_amount: { start_scale: 25_711, end_scale: 73_516 }, tax: 0.3 })
        expect(result_bordeaux).to eq({ family_quotient_amount: { start_scale: 10_085, end_scale: 25_710 }, tax: 0.11 })
      end
    end

    context 'when it has some property income' do
      it 'returns the family quotient amount' do
        result_lyon = IncomeTaxesBaseFormulas.calc_income_taxes_scale(simulation_lyon, 20_000)
        result_bordeaux = IncomeTaxesBaseFormulas.calc_income_taxes_scale(simulation_bordeaux, 2_000)
        expect(result_lyon).to eq({ family_quotient_amount: { start_scale: 25_711, end_scale: 73_516 }, tax: 0.3 })
        expect(result_bordeaux).to eq({ family_quotient_amount: { start_scale: 10_085, end_scale: 25_710 }, tax: 0.11 })
      end
    end
  end
end
