require 'thread'

class BikeRentalService
  attr_accessor :available_bikes, :rented_bikes

  def initialize(bikes)
    @available_bikes = bikes
    @rented_bikes = []
    @requested_bikes = Hash.new { |h, k| h[k] = Queue.new }
    @mutex = Mutex.new
  end

  def rent_bike(color = nil)
    bike = nil
    @mutex.synchronize do
      while true
        if color.nil?
          bike = @available_bikes.pop
        else
          bike = @available_bikes.find { |b| b.color == color }
          index = @available_bikes.find_index(bike)
          bike = @available_bikes.delete_at(index) unless index.nil?
        end

        break unless bike.nil?

        @requested_bikes[color].push(Thread.current)
        @mutex.sleep
      end

      @rented_bikes << bike
    end

    bike
  end

  def return_bike(bike)
    @mutex.synchronize do
      @rented_bikes.delete(bike)
      @available_bikes << bike

      requested_queue = @requested_bikes[bike.color]
      if !requested_queue.empty?
        thread = requested_queue.pop
        thread.wakeup if thread.status == 'sleep'
      end
    end
  end
end

class Bike
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

def print_available_bikes(bikes)
  puts "Available Bikes:"
  bikes.each_with_index do |bike, index|
    puts "#{index + 1}. #{bike.color}"
  end
  puts "\n"
end

bikes = [
  Bike.new('red'),
  Bike.new('red'),
  Bike.new('blue'),
  Bike.new('green')
]

bike_rental_service = BikeRentalService.new(bikes)

print_available_bikes(bike_rental_service.available_bikes)

threads = []

10.times do |i|
    threads << Thread.new do
      color = ['red', 'blue', 'green'].sample
      bike = bike_rental_service.rent_bike(color)
      puts "Client #{i + 1} rented a #{bike.color} bike."
      sleep(rand(5))
      bike_rental_service.return_bike(bike)
      puts "Client #{i + 1} returned the #{bike.color} bike."
    end
  end

threads.each(&:join)