

class Game
  def init
    @player = Player.new
    
    # Create locations.
    tatooine = Location.new("Tatooine", "You see miles and miles of sand.")
    dagobah = Location.new("Dagobah", "This place bubbles all the time like a giant carbonated soda.  S-O-D-A-sooo-ooh-da.")
    kingspointe = Location.new("King's Pointe", "Your eyes burn because of the excessive chloromines in the air, but you stay for the fun slides.")
    zombieHotel = Location.new("Zombie Hotel", "This is a zombie hotel.")

    # Connect locations.
    tatooine.addBidirectionalExit dagobah
    tatooine.addBidirectionalExit kingspointe
    zombieHotel.addBidirectionalExit kingspointe
		     
		#creating items
		lightSaber = Item.new("Light Saber")
		phaserGun = Item.new("Phaser Gun")
		spear = Item.new("Spear")
		shive = Item.new("Shive")

		#adding items to location
		tatooine.addWeap lightSaber
		kingspointe.addWeap phaserGun
		dagobah.addWeap shive
		zombieHotel.addWeap spear
		
    @currentLocation = tatooine
    @stillPlaying = true
  end

  def look
    puts "You are in #{@currentLocation.name}."
    puts @currentLocation.desc
    puts "From here you can go to #{@currentLocation.getExitNames}"

		#showing what weapon is in each location
		puts "Items: #{@currentLocation.getItemsName}." 

  end

	def inventory
		puts "Items: #{@player.getItemsName}." 	
	end

  def play
    print "Enter your name: "
    @player.name = gets.chomp
    puts "Welcome, #{@player.name}!"

    look
    while @stillPlaying
      print "Command? "
      cmd = gets.chomp
      if cmd.start_with? "move to "
        locationName = cmd[8..cmd.length]
        nextLocation = @currentLocation.getExitNamed locationName
        if nextLocation
          @currentLocation = nextLocation
          look
        else
          puts "Sorry, I don't see #{locationName} from here."
        end

			#add in pick up conditionals 

			elsif cmd.start_with? "pick up " 
				weaponName = cmd[8..cmd.length]
				newWeapon = @currentLocation.getItemsNamed weaponName
				if newWeapon
					@player.addWeap(newWeapon)
					inventory 
					@currentLocation.removeWeap(newWeapon) 	   
				else 
					puts "I do not see #{weaponName} around here" 
				end 

			#add in the drop conidtionals 
			elsif cmd.start_with? "drop " 
				weaponDrop = cmd[5..cmd.length] 
				weaponToDrop = @player.getItemsNamed weaponDrop
				if weaponToDrop
					@player.removeWeap(weaponToDrop)
					puts "You dropped #{weaponDrop}." 
					@currentLocation.addWeap(weaponToDrop) 
				end			
	
      elsif cmd == "look"
        look
			elsif cmd == "inventory"
				inventory
      else
        puts "Sorry, you can't do that."
      end

    end
    
  end
end

class Person
  attr_accessor :health, :items, :location, :name

  def initialize(name="Luke")
    @health = 100
    @items = []
    @name = name
    @location = nil
  end

	def addWeap(aWeapon)
		@items << aWeapon
	end

	def removeWeap(aWeapon)
		@items.delete(aWeapon)
	end 

  def attack()
  end
	
	def getItemsName
		return @items.map { |item| item.name }.join(", ")  
	end

	def getItemsNamed(weaponNamed)
		return @items.find { |loc| loc.name == weaponNamed} 
	end 
end

class Player < Person
end

class NPC < Person
end

class Location
  attr_reader :name, :desc

  def initialize(name, desc)
    @name = name
    @desc = desc
    @items = []
    @people = []
    @exits = []
  end

  def getExitNames
    return @exits.map { |loc| loc.name }.join(", ")
  end

  def getItemsName
  	
		if @items.empty?
      return "No weapons for you"
    else
      return @items.map { |item| item.name }.join(", ") 
    end
	end 

	def getItemsNamed(locationNamed) 
		return @items.find { |loc| loc.name == locationNamed}	
	end 

	def addWeap(aWeapon)
		@items << aWeapon 
	end 

	def removeWeap(aWeapon)
		@items.delete(aWeapon)
	end 

  def addExit(aLocation)
    @exits << aLocation
  end

  def addBidirectionalExit(aLocation)
    addExit(aLocation)
    aLocation.addExit(self)
  end

  def addPerson(person)
    @people << person
    person.location = self
  end

  def getExitNamed(locationName)
    return @exits.find { |loc| loc.name == locationName }
  end

end

class Item
	attr_accessor :name
	
	def initialize(name)
		@name = name
		@items = []
		@weapons = []
	end 

	def getItemsNamed(itemName)
		return @items.find { |loc| loc.name == itemName} 
	end 

end

class Weapon
end

class Food
end

