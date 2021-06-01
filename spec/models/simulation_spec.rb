require 'rails_helper'

RSpec.describe Simulation, type: :model do
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

  #-----------------------------------------------------------------------#
  # Validations
  describe 'Validations' do
    describe '#house_city' do
      it { should validate_presence_of(:house_city) }
    end

    describe '#house_price_bought_amount' do
      it { should validate_presence_of(:house_price_bought_amount) }
      it { should validate_numericality_of(:house_price_bought_amount).only_integer }
      it { should validate_numericality_of(:house_price_bought_amount).is_greater_than_or_equal_to(0) }
    end

    describe '#house_first_works_amount' do
      it 'is expected to validate that :house_first_works_amount allows blank input' do
        record = Simulation.new
        record.house_first_works_amount = '' # invalid state
        record.validate
        expect(record.errors[:house_first_works_amount]).to_not include('doit être rempli(e)') # check for presence of error

        record.house_first_works_amount = 10_000 # valid state
        record.validate
        expect(record.errors[:house_first_works_amount]).to_not include('doit être rempli(e)') # check for absence of error
      end
      it { should validate_numericality_of(:house_first_works_amount).only_integer }
      it { should validate_numericality_of(:house_first_works_amount).is_greater_than_or_equal_to(0) }
    end

    describe '#house_total_charges_amount_per_year' do
      it { should validate_presence_of(:house_total_charges_amount_per_year) }
      it { should validate_numericality_of(:house_total_charges_amount_per_year).only_integer }
      it { should validate_numericality_of(:house_total_charges_amount_per_year).is_greater_than_or_equal_to(0) }
    end

    describe '#house_property_tax_amount_per_year' do
      it { should validate_presence_of(:house_property_tax_amount_per_year) }
      it { should validate_numericality_of(:house_property_tax_amount_per_year).only_integer }
      it { should validate_numericality_of(:house_property_tax_amount_per_year).is_greater_than_or_equal_to(0) }
    end

    describe '#house_rent_amount_per_month' do
      it { should validate_presence_of(:house_rent_amount_per_month) }
      it { should validate_numericality_of(:house_rent_amount_per_month).only_integer }
      it { should validate_numericality_of(:house_rent_amount_per_month).is_greater_than_or_equal_to(0) }
    end

    describe '#house_property_management_cost_percentage' do
      it { should validate_presence_of(:house_property_management_cost_percentage) }
      it { should validate_numericality_of(:house_property_management_cost_percentage) }

      it 'validates only between [0,1]' do
        record = Simulation.new
        record.house_property_management_cost_percentage = -5 # invalid state
        record.validate
        expect(record.errors[:house_property_management_cost_percentage]).to include('doit être supérieur ou égal à 0') # check for presence of error

        record = Simulation.new
        record.house_property_management_cost_percentage = 2 # invalid state
        record.validate
        expect(record.errors[:house_property_management_cost_percentage]).to include('doit être inférieur ou égal à 1') # check for presence of error

        record.house_property_management_cost_percentage = 0.05 # valid state
        record.validate
        expect(record.errors[:house_property_management_cost_percentage]).to_not include('doit être supérieur ou égal à 0') # check for absence of error

        record.house_property_management_cost_percentage = 0 # valid state
        record.validate
        expect(record.errors[:house_property_management_cost_percentage]).to_not include('doit être supérieur ou égal à 0') # check for absence of error

        record.house_property_management_cost_percentage = 1 # valid state
        record.validate
        expect(record.errors[:house_property_management_cost_percentage]).to_not include('doit être inférieur ou égal à 1') # check for absence of error
      end
    end

    describe '#credit_loan_amount' do
      it { should validate_presence_of(:credit_loan_amount) }
      it { should validate_numericality_of(:credit_loan_amount).only_integer }
      it { should validate_numericality_of(:credit_loan_amount).is_greater_than_or_equal_to(0) }
    end

    describe '#credit_loan_duration' do
      it { should validate_presence_of(:credit_loan_duration) }
      it { should validate_numericality_of(:credit_loan_duration).only_integer }
      it { should validate_numericality_of(:credit_loan_duration).is_greater_than_or_equal_to(0) }
    end

    describe '#fiscal_status' do
      it { should validate_presence_of(:fiscal_status) }

      it 'validates inclusion in fiscal status available ' do
        record = Simulation.new
        record.fiscal_status = 'Fiscal status not implemented' # invalid state
        record.validate
        expect(record.errors[:fiscal_status]).to include("n'est pas inclus(e) dans la liste") # check for presence of error

        record.fiscal_status = 'Pinel' # valid state
        record.validate
        expect(record.errors[:fiscal_status]).to_not include("n'est pas inclus(e) dans la liste") # check for absence of error
      end
    end

    describe '#fiscal_regimen' do
      it { should validate_presence_of(:fiscal_regimen) }

      it 'validates inclusion in fiscal regimen available ' do
        record = Simulation.new
        record.fiscal_regimen = 'Fiscal status not implemented' # invalid state
        record.validate
        expect(record.errors[:fiscal_regimen]).to include("n'est pas inclus(e) dans la liste") # check for presence of error

        record.fiscal_regimen = 'Forfait' # valid state
        record.validate
        expect(record.errors[:fiscal_regimen]).to_not include("n'est pas inclus(e) dans la liste") # check for absence of error
      end
    end

    describe '#fiscal_revenues_p1' do
      it { should validate_presence_of(:fiscal_revenues_p1) }
      it { should validate_numericality_of(:fiscal_revenues_p1).only_integer }
      it { should validate_numericality_of(:fiscal_revenues_p1).is_greater_than_or_equal_to(0) }
    end

    describe '#fiscal_revenues_p2' do
      it 'allows to be blank' do
        record = Simulation.new
        record.fiscal_revenues_p2 = '' # invalid state
        record.validate
        expect(record.errors[:fiscal_revenues_p2]).to_not include('doit être rempli(e)') # check for presence of error

        record.fiscal_revenues_p2 = 55_000 # valid state
        record.validate
        expect(record.errors[:fiscal_revenues_p2]).to_not include('doit être rempli(e)') # check for absence of error
      end

      it { should validate_numericality_of(:fiscal_revenues_p2).only_integer }
      it { should validate_numericality_of(:fiscal_revenues_p2).is_greater_than_or_equal_to(0) }
    end

    describe '#fiscal_nb_parts' do
      it { should validate_presence_of(:fiscal_nb_parts) }
      it { should validate_numericality_of(:fiscal_nb_parts) }
      it { should validate_numericality_of(:fiscal_nb_parts).is_greater_than_or_equal_to(0) }
    end
  end

  #-----------------------------------------------------------------------#
  # House related formulas
  describe 'House related formulas' do
    ## Notarial fees
    describe '#house_notarial_fees_percentage' do
      it 'returns a default value of 8%' do
        result_lyon = simulation_lyon.house_notarial_fees_percentage
        expect(result_lyon).to eq(0.08)
      end
    end

    describe '#house_notarial_fees_amount' do
      it 'returns an amount equal to 8% of price bought' do
        result_lyon = simulation_lyon.house_notarial_fees_amount
        result_bordeaux = simulation_bordeaux.house_notarial_fees_amount
        expect(result_lyon).to eq(40_000)
        expect(result_bordeaux).to eq(8000)
      end
    end

    ## Charges
    describe '#house_tenant_charges_percentage' do
      it 'returns a default value of 80%' do
        result_lyon = simulation_lyon.house_tenant_charges_percentage
        expect(result_lyon).to eq(0.8)
      end
    end

    describe '#house_tenant_charges_amount_per_year' do
      it 'returns an amount equal to 80% of house_total_charges_amount_per_year' do
        result_lyon = simulation_lyon.house_tenant_charges_amount_per_year
        result_bordeaux = simulation_bordeaux.house_tenant_charges_amount_per_year
        expect(result_lyon).to eq(2200)
        expect(result_bordeaux).to eq(400)
      end
    end

    describe '#house_landlord_charges_amount_per_year' do
      it 'returns an amount equal to 20% of house_total_charges_amount_per_year' do
        result_lyon = simulation_lyon.house_landlord_charges_amount_per_year
        result_bordeaux = simulation_bordeaux.house_landlord_charges_amount_per_year
        expect(result_lyon).to eq(550)
        expect(result_bordeaux).to eq(100)
      end
    end

    ## Rent
    describe '#house_rent_amount_per_year' do
      it 'returns the rent revenue generated' do
        result_lyon = simulation_lyon.house_rent_amount_per_year
        result_bordeaux = simulation_bordeaux.house_rent_amount_per_year
        expect(result_lyon).to eq(30_000)
        expect(result_bordeaux).to eq(5400)
      end
    end

    ## Property management
    describe '#house_property_management_amount_per_year' do
      it 'when property management is set to false, returns an amount equal to 0' do
        result_lyon = simulation_lyon.house_property_management_amount_per_year
        expect(result_lyon).to eq(0)
      end

      it 'when property management is set to true, returns an amount equal to 8% of rent amount per year' do
        result_bordeaux = simulation_bordeaux.house_property_management_amount_per_year
        expect(result_bordeaux).to eq(432)
      end
    end

    ## GLI
    describe '#house_insurance_gli_percentage' do
      it 'returns a default value of 3.5%' do
        result_lyon = simulation_lyon.house_insurance_gli_percentage
        expect(result_lyon).to eq(0.035)
      end
    end

    describe '#house_insurance_gli_amount_per_year' do
      it 'returns the gli cost per year' do
        result_lyon = simulation_lyon.house_insurance_gli_amount_per_year
        result_bordeaux = simulation_bordeaux.house_insurance_gli_amount_per_year
        expect(result_lyon).to be_within(0.1).of(1050)
        expect(result_bordeaux).to be_within(0.1).of(189)
      end
    end

    describe '#house_insurance_pno_amount_per_year' do
      it 'returns a default value of 100€ per year' do
        result_lyon = simulation_lyon.house_insurance_pno_amount_per_year
        expect(result_lyon).to eq(100)
      end
    end
  end

  #-----------------------------------------------------------------------#
  # Credit related formulas
  describe 'Credit related formulas' do
    ## Interests
    describe '#credit_loan_interest_percentage_per_year' do
      it 'returns a default value of 1% per year' do
        result_lyon = simulation_lyon.credit_loan_interest_percentage_per_year
        expect(result_lyon).to eq(0.01)
      end
    end

    describe '#credit_loan_interest_total_amount' do
      it 'returns the loan interest total cost' do
        result_lyon = simulation_lyon.credit_loan_interest_total_amount
        result_bordeaux = simulation_bordeaux.credit_loan_interest_total_amount
        expect(result_lyon).to be_within(0.01).of(57_060.48)
        expect(result_bordeaux).to be_within(0.01).of(10_374.63)
      end
    end

    ## Insurance
    describe '#credit_loan_insurance_percentage_per_year' do
      it 'returns a default value of 0.30% per year' do
        result_lyon = simulation_lyon.credit_loan_insurance_percentage_per_year
        expect(result_lyon).to eq(0.003)
      end
    end

    describe '#credit_loan_insurance_total_amount' do
      it 'returns the loan insurance total cost' do
        result_lyon = simulation_lyon.credit_loan_insurance_total_amount
        result_bordeaux = simulation_bordeaux.credit_loan_insurance_total_amount
        expect(result_lyon).to be_within(0.01).of(33_000)
        expect(result_bordeaux).to be_within(0.01).of(6_000)
      end
    end
  end

  #-----------------------------------------------------------------------#
  # Profitability formulas
  describe 'Profitability formulas' do
    describe '#global_buying_operation_cost' do
      it 'returns the global buying operation cost' do
        result_lyon = simulation_lyon.global_buying_operation_cost
        result_bordeaux = simulation_bordeaux.global_buying_operation_cost
        expect(result_lyon).to eq(565_000)
        expect(result_bordeaux).to eq(108_000)
      end
    end

    describe '#gross_profitability' do
      it 'returns the gross profitability' do
        result_lyon = simulation_lyon.gross_profitability
        result_bordeaux = simulation_bordeaux.gross_profitability
        expect(result_lyon).to be_within(0.01).of(5.31)
        expect(result_bordeaux).to be_within(0.01).of(5.00)
      end
    end

    describe '#net_profitability' do
      it 'returns the net profitability' do
        result_lyon = simulation_lyon.net_profitability
        result_bordeaux = simulation_bordeaux.net_profitability
        expect(result_lyon).to be_within(0.01).of(3.68)
        expect(result_bordeaux).to be_within(0.01).of(3.19)
      end
    end
  end
end