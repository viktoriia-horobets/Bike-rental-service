require 'rspec'
require_relative '../bike_rental_service'

RSpec.describe BikeRentalService do
  let(:bikes) do
    [
      instance_double(Bike, color: 'red'),
      instance_double(Bike, color: 'red'),
      instance_double(Bike, color: 'blue'),
      instance_double(Bike, color: 'green')
    ]
  end

  subject(:bike_rental_service) { described_class.new(bikes) }

  describe '#rent_bike' do
    context 'when a bike is available' do
      it 'rents a bike' do
        bike = bike_rental_service.rent_bike('red')
        expect(bike).to be_a(Bike)
      end
    end

    context 'when no bike is available' do
      it 'waits for a bike to be returned' do
        bike_rental_service.rent_bike('red')
        bike_rental_service.rent_bike('red')

        returning_thread = Thread.new do
          sleep(2)
          bike_rental_service.return_bike(bikes[0])
        end

        expect {
          bike_rental_service.rent_bike('red')
        }.to change { bike_rental_service.rented_bikes.count }.by(1)

        returning_thread.join
      end
    end
  end

  describe '#return_bike' do
    it 'adds the returned bike to available bikes' do
      bike = instance_double(Bike, color: 'blue')
      bike_rental_service.return_bike(bike)
      expect(bike_rental_service.available_bikes).to include(bike)
    end

    it 'removes the returned bike from rented bikes' do
      bike = instance_double(Bike, color: 'red')
      bike_rental_service.return_bike(bike)
      expect(bike_rental_service.rented_bikes).not_to include(bike)
    end
  end
end
