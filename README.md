# Bike-rental-service

The bike rental server has a set of bikes at its disposal. 
 Each bike has a (non-neccesarily unique) colour.
	Clients can rent one bike at a time. Then, they use it for some (may it be random) period of time and then the bike is returned.
	Each request can rent either
		* whichever available bike
		or
		* bike of a certain colour
	If an appropriate bike is not available, the requesting client is blocked waiting.

The BikeRentalService class manages available and rented bikes. 
It uses a mutex lock to ensure safe access for multiple threads. 
The sleep method allows a thread to temporarily pause its execution, releasing the lock and letting other threads continue. The wakeup method is used to awaken a sleeping thread when certain conditions are met. 
The code utilizes threads to simulate clients renting and returning bikes, demonstrating the synchronization mechanisms of mutex, sleep, wake up, and multi-threading.
