# Bike-rental-service

The bike rental server has a set of bikes at its disposal. 
 Each bike has a (non-neccesarily unique) colour.
	Clients can rent one bike at a time. Then, they use it for some (may it be random) period of time and then the bike is returned.
	Each request can rent either
		* whichever available bike
		or
		* bike of a certain colour
	If an appropriate bike is not available, the requesting client is blocked waiting.
