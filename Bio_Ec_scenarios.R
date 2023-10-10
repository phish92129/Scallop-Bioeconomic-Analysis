# Initial Inputs

# Required Inputs

#######  Input Longline and Lease Specifications ######

# Leasing Setup and fees
Lease.Type <- 'Standard Lease'

# Longline System Specs
Longline.Quantity = 1     # Number of longlines on the farm                 
Longline.Depth = 60     # Lease Depth (Feet) at low tide
Longline.Suspended.Depth = 15     #Projected Longline Depth at low tide

############## Business Model ##############

Product <- 500000     # Number of individual scallop spat
Year.Start <- 2023     #Year of projected farm operations start: Model begins August 1st
Consumables <- 500     # Includes general expenditures like Gear,coffee,misc  
Owner.salary <- 50000     # Predicted annual owner salary
Insurance <- 5000     #Annual Insurance Costs for vehicles, personnel, etc

####### Employment Information
Full.Time.Employee <- 1     # Number of full time employees
Employee.Salary <- 50000     # Annual full time employee salary
Part.Time.Wage <- 15     # Hourly rate for part time wages

######## Production Planning
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y2'
Gear.Specification <- 'Lantern Net'

############## Costs and secondary Inputs ###########

# Secondary Inputs

# Y0 Product Metrics - Spat Procurement and Nursery Culture

Wild.Spat.Collector <- 4000     # Number of Wild Spat estimated/collector
Spat.Site.Depth <- 150  # Assumes a Depth of 150 feet
Seed.Net.Density <- 150     # Assumes 250/tier initial stocking density

# Y1 Product Metrics - Intermediate Culture

Y1.Stocking.Density <- 25     # Intermediary Culture stocking density (recommended 45-25)

# Year 2/3 August 01 Y2 to August 01 Y4

# Y2/Y3 Product Metrics - Lantern Net

Y2.LN.Stocking.Density <- 10
Y3.LN.Stocking.Density <- 10

# Mortalities

Y0.Mortality <- .12   # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
Y1.Mortality <- .12     # Mortality from August Y1 till August Y2
Y2.Mortality <- .12
Y3.Mortality <- .12


# General Longline

# Mooring line length related to bottom depth, 
# recommended is 4 times bottom depth
Mooring.Length <- 4   

# Spacing of large surface floats along longline
Surface.Float.Spacing <- 100

# Buffer zone around longline, essentially the distance footprint area between longlines or to the 
# lease edge

Longline.Spacing <- 40     

# Production Specs
#Annual Shellfish license fees
SH.License <- 1200

# Number of spat collectors per line
Collectors.Line <- 10    

# Length of gangion lines in feet for Lantern Nets and mid-water buoys
Gangion.Length <- 4

# of lantern net tiers (generally 7 or 10)
LN.Tiers <- 10

# Spacing of hard balls for lantern nets also interpreted as hard balls per lantern net/dropper line
Hard.Ball.Spacing.LN <- 10

# lantern nets per anchor
Cement.Anchor.Net <- 25

# Lantern net spacing
LN.Spacing <- 3    # In feet

# Spacing of hard balls for dropper line also interpreted as hard balls per dropper line
Hard.Ball.Spacing.EH <- 40

# Dropper Lines per anchor
Cement.Anchor.EH <- 100

# Ear hanging Spacing
EH.Spacing <- 1    # In feet


Y2.EH.Dropper.Scallops.per <- 140     # Total scallops per dropper (would relate to 70 paired)
Y2.EH.Scallop.Spacing <- .5    # In feet
Y2.EH.Dropper.Margins <- 10   # In feet

# Costs and secondary inputs are values that can change over time
# But are not critical in the overall business plan
# Inputs for change to grower may can be the unit cost (cost per unit) and Lifespan

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 0      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 0     # Must enter quantity for different scenarios
)

# Accounts for initial equipment purchases not considered in this model (ex: work computer)
# Should be accounted for in a single lump sum and Lifespan should be averaged
# Current model sets $800 for a work computer
Misc <- data.frame(     
  Equipment = 'Miscellaneous Equipment',
  Unit.Cost = c(800),
  Lifespan = c(5),
  Quantity =1
)

# Accounts for Head rope and mooring line
Rope.2inch <- data.frame(     #Secondary inputs not part of functionality but could require updating
  Equipment = 'Rope (1 inch)',     # Name of gear (specific) 
  Unit.Cost = c(.61),    # Cost per foot
  Lifespan = c(10)     # Predicted lifespan of gear
)

# Rope for all gangions
Gangion.Line <- data.frame(
  Equipment = 'Gangion Line',     
  Unit.Cost = c(.07),
  Lifespan = c(8)
)

# Assumes a large cement block
Mooring.Anchor <- data.frame(
  Equipment = 'Mooring Anchor',     
  Unit.Cost = c(1000),
  Lifespan = c(25)
)

# Cement Bucket anchor for small controlled anchoring
Cement.Anchor <- data.frame(
  Equipment = 'Anchor (Cement Bucket)',    
  Unit.Cost = c(5),
  Lifespan = c(10)
)

# Float between mooring lines and head rope
Corner.Tension.Float <- data.frame(
  Equipment = 'Corner Tension Float',     
  Unit.Cost = c(120),
  Lifespan = c(15)
)


# Indicator surface floats designed to mark longline 
# and for flotation
Surface.Float <- data.frame(
  Equipment = 'Surface Float (Large)',     
  Unit.Cost = c(100),
  Lifespan = c(10)
)

#Marks aquaculture lease site corers as per DMR regulations (4 for each corner)
Lease.Marker <- data.frame(
  Equipment = 'Lease Marker',      
  Unit.Cost = c(70),
  Lifespan = c(10)
)

# Large suspension buoy designed for the surface
Go.Deep.Buoy <- data.frame(
  Equipment = 'Go-Deep Buoy',      
  Unit.Cost = c(20),
  Lifespan = c(10)
)

# Hard ball buoys are suspension buoys designed to sit below the surface
Hard.Ball <- data.frame(
  Equipment = 'Hard Ball Buoy',      
  Unit.Cost = c(50),
  Lifespan = c(10)
)

# Spat collector consists of outer fine mesh bag and inner settlement substrate
Spat.Collector <- data.frame(
  Equipment = 'Spat Collector',     
  Unit.Cost = 4,
  Lifespan = 1     # Life span is assumed to be a consumable item if set to 1
)

# Lantern Nets, no distinction between mesh sizes
Lantern.Net <- data.frame(
  Equipment = 'Lantern Net',   
  Unit.Cost = 21.67,
  Lifespan = 5
)

# Collection Permits required for wild spat collection
Spat.Coll.Permit <- data.frame(
  Equipment = 'Wild Spat Collection Permit',     
  Unit.Cost = 20,     # Double Check Price
  Lifespan = 1,     # Annual fee?
  Quantity = 1
)

# Cost/foot of dropper line
Dropper.Line <- data.frame(
  Equipment = 'Dropper Line',
  Unit.Cost = .1,
  Lifespan = 5
)

# Age-Pins for hanging are one-time use and hang 2 scallops
Age.Pins <- data.frame(
  Equipment = 'Age Pins',
  Unit.Cost = .001,
  Lifespan = 1  
)

# Brick anchor for each dropper line to reduce movement in high current environments
Brick.Anchor <- data.frame(
  Equipment = 'Anchor (Brick)',
  Unit.Cost = 1.5,
  Lifespan = 10
)

# Washer for scallops can be used for lantern nets or ear hanging but price may vary
# Generally used for whole shell scallop markets
Scallop.Washer <- data.frame(
  Equipment = 'Scallop Washer',
  Unit.Cost = 35000,
  Quantity = 1,
  Lifespan = 10
)

# Grades scallops into different size classes
Scallop.Grader <- data.frame(
  Equipment = 'Scallop Grader',
  Unit.Cost = 14000,
  Quantity = 0,
  Lifespan = 10
)

# Power Pack is a fuel powered pack to provide additional power to specialized
# aquaculture infrastructure.  Only certain specialized gear requires a power pack
Power.Pack <- data.frame(
  Equipment = 'Power Pack',
  Unit.Cost = 10000,
  Quantity = 0,
  Lifespan = 10
)

# Dremmel drill for drilling scallops and then pinning by hand - Adjust labor outputs
Drill.Dremmel <- data.frame(
  Equipment = 'Drill (Dremmel)',
  Unit.Cost = 2000,
  Quantity = 0,
  Lifespan = 30
)

# Automated drill for drilling scallops and then pinning by hand
Drill.Automated <- data.frame(
  Equipment = 'Drill (Automated)',
  Unit.Cost = 25000,
  Quantity = 1,
  Lifespan = 10
)

# Drill and Pin machine for drilling and pinning scallops automatically
Drill.Pin <- data.frame(
  Equipment = 'Drill and Pin',
  Unit.Cost = 45000,
  Quantity = 0,
  Lifespan = 10
)

# Machine for pinning dropper lines to have scallops affixed
Pinning<- data.frame(
  Equipment = 'Pining Machine',
  Unit.Cost = 3000,
  Quantity = 1,
  Lifespan = 10
)

# Removes pins from dropper lines increasing the lifespan of dropper line rope (adjust depreciation levels)
depinning <- data.frame(
  Equipment = 'De-Pining Machine',
  Unit.Cost = 2000,
  Quantity = 1,
  Lifespan = 10
)

####### Labor Tasks #######

# Estimated Daily hourly work day (for boat day calculations)
#Set to 8 hours by default and includes steam

Daily.Work <- 8

# Growers set settlement devices in Fall and collect in Spring for restock to Lantern Net
Settlement.Device <- data.frame(
  Task = 'Set Settlement Devices',   # Growers set settlement devices in Fall and collect in Spring for restock to Lantern Net
  Unit = 'Devices/Day',
  Task.Rate = 50,
  Part.Time = 0,     # Asssumes that task rate accounts for the amount of part time help
  Timing = 'Summer'
)



# Collection of settlement devices in Spring
Collect.Settlement.Device <- data.frame(
  Task = 'Collect Settlement Device',     
  Unit = 'Devices/Day',
  Task.Rate = 100,
  Part.Time = 0,
  Timing ='Spring'
)

#     Processing of settlement devices to procure seed
Process.Settlement.Device <- data.frame(
  Task = 'Process Settlement Device',     
  Unit = 'Devices/Day',
  Task.Rate = 50,
  Part.Time = 0,
  Timing = 'Spring'
)

# Restock scallops into lantern nets from settlement collectors
Spat.Stocking <- data.frame(
  Task = 'Spat Stocking',     
  Unit = 'Scallops/Day',
  Task.Rate = 200000,
  Part.Time = 1,
  Timing = 'Spring'
)

# Restock Lantern nets 
Restock <- data.frame(
  Task = 'Restock',     
  Unit = 'Devices/Day',
  Task.Rate = 75,
  Part.Time = 2,
  Timing = 'Summer'
)

# Spring (May) cleaning for restocked lantern nets the following year involves transfer to clean nets
Cleaning.Spring.LN <- data.frame(
  Task = 'Cleaning (Spring)',     
  Unit = 'Devices/Day',
  Task.Rate = 100,
  Part.Time = 2,
  Timing = 'Spring'
)

Cleaning.Spring.EH <- data.frame(
  Task = 'Cleaning (Spring)',     # Assumes the farm has a cleaning machine or else task rate needs to be adjusted
  Unit = 'Devices/Day',
  Task.Rate = 275,
  Part.Time = 1,
  Timing = 'Spring'
)

# Fall cleaning runs a similar process to Spring cleaning
Cleaning.Fall.LN <- data.frame(
  Task = 'Cleaning (Fall)',     
  Unit = 'Devices/Day',
  Task.Rate = 100,
  Part.Time = 2,
  Timing = 'Fall'
)

Cleaning.Fall.EH <- data.frame(
  Task = 'Cleaning (Fall)',
  Unit = 'Devices/Day',
  Task.Rate = 275,
  Part.Time = 1,
  Timing = 'Fall'
)

# Cleaning of lantern nets
Cleaning.Prev.Year <- data.frame(
  Task = 'Previous Year Net Cleaning (On Land)',     
  Unit = 'Devices/Day',
  Task.Rate = 200,
  Part.Time = 0,
  Timing = 'Summer')

# Drilling and Pinning with Dremmel machine method, part time labor will be higher for this 
# to account for pinning.
# Task rate and required part time help scale to the quantity of dremmel machines used 
# and should be accounted for
Labor.Dremmel <- data.frame(
  Task = 'Drilling + Pinning: Dremmel',
  Unit = 'Scallops/Day',
  Task.Rate = 8000,        # Assumes 8000 scallops pinned a day per dremmel
  Part.Time = 2,
  Timing = 'Fall'
)

# # Drilling and Pinning with automated drilling machine method, part time labor will be higher for this 
# to account for pinning.
# Task rate and required part time help scale to the quantity of dremmel machines used 
# and should be accounted for
Labor.Auto.Drill <- data.frame(
  Task = 'Drilling + Pinning: Automated Driller',
  Unit = 'Scallops/Day',
  Task.Rate = 12000,        # Assumes 12000 scallops pinned a day per Machine
  Part.Time = 2,
  Timing = 'Fall'
)

# Automated drilling and pinning machine where scallops are drilled and pinned automatically
# Part time labor would only scale if there were more than two machines purchased running
# Otherwise task rate is based on quantity of machines
Labor.Auto.Full <- data.frame(
  Task = 'Drilling + Pinning: Automated',
  Unit = 'Scallops/Day',
  Task.Rate = 10000,                        # Assumes 10000 scallops pinned a day per machine
  Part.Time = 0,                             # Assumes No extra help needed unless >2 machines
  Timing = 'Fall'
)

Dropper.Line.Construction <- data.frame(
  Task = 'Dropper Line Construction',
  Unit = 'Devices/Day',
  Task.Rate = 240,
  Part.Time = 0,
  Timing = 'Fall'
)

######## Fuel usage #######

#  Vessel Fuel Metrics
Fuel.Vessel <- data.frame(
  Vehicle = 'Vessel',
  Price.Gallon = 6,     # Estimated price of fuel/gallon set high to account for fluctuations over time
  Usage.Trip = 21)     #  Fuel usage/trip and used to account for mileage

# Additional Trips for each year not accounted for by labor metrics
Wild.Spat.Collected.Add.V.Trips <- 0     # Additional Trips for Y0 wild spat collection
Y1.LN.Add.V.Trip <- 0                    # Additional Trips for Y1 Lantern Net collection
Y2.LN.Add.V.Trip <- 0                    # Additional Trips for Y2 Lantern Net collection
Y3.LN.Add.V.Trip <- 0                    # Additional Trips for Y3 Lantern Net collection
Y2.EH.Add.V.Trip <- 0                    # Additional Trips for Y2 Ear Hanging collection
Y3.EH.Add.V.Trip <- 0                    # Additional Trips for Y3 Ear Hanging collection

# Truck Fuel Metrics
Fuel.Truck <- data.frame(
  Vehicle = 'Truck',
  Price.Gallon = 4,   # Gas price/gallon
  Usage.Trip = 5)     # Gallons of gas used per trip which only assumes commute to and from vessel

# Additional Trips for each year not accounted for by labor metrics
Wild.Spat.Collected.Add.T.Trips <- 0     # Additional Trips for Y0 wild spat collection
Y1.LN.Add.T.Trip <- 0                    # Additional Trips for Y1 Lantern Net collection
Y2.LN.Add.T.Trip <- 0                    # Additional Trips for Y2 Lantern Net collection
Y3.LN.Add.T.Trip <- 0                    # Additional Trips for Y3 Lantern Net collection
Y2.EH.Add.T.Trip <- 0                    # Additional Trips for Y2 Ear Hanging collection
Y3.EH.Add.T.Trip <- 0                    # Additional Trips for Y3 Ear Hanging collection

####### Maintenance Costs #######

# Vessel Maintenance Metrics
Maint.Vessel <- data.frame(
  Item = 'Vessel',
  Unit.Type = 'Trips',
  Cost = 150     # Estimated maintenance cost/trip
)

# Truck Maintenance

Maint.Truck <- data.frame(
  Item = 'Truck',
  Unit.Type = 'Trips',
  Cost = 20
)

# All specialized equipment set to .001/scallop maintenance annual maintenance level
Specialized.Equipment <- data.frame(
  Item = 'Specialized Equipment',
  Unit.Type = 'Scallop',
  Cost = .001
)


###### Write a function to create a matrix for iterative functioning

# Sub scenario breakdown

# a) whole scallop - vessel and truck already obtained
# b) adductor only - vessel and truck already obtained
# c) whole scallop - vessel and truck as cap-ex
# d) adductor only - vessel and truck as cap-ex

# Scenario 1abcd: Ear Hanging sold after 1 year of grow out at 10,000 : 250000 by 10,000 
# Ear Hanging assumes an automated drilling maching is selected for these scenarios

Product <- seq(10000,1000000,by=10000)
output = data.frame()
######## Production Planning
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y2'
Gear.Specification <- 'Ear Hanging'
# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 0      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 0     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                                   Longline.Quantity,        # Number of longlines on the farm                  
                                   Longline.Depth,           # Lease Depth (Feet) at low tide
                                   Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                                   Product[i],                  # Number of individual scallop spat
                                   Year.Start,               # Year of projected farm operations start: Model begins August 1st
                                   Consumables,              # Includes general expenditures like Gear,coffee,misc
                                   Owner.salary,             # Predicted annual owner salary
                                   Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                                   Full.Time.Employee,       # Number of full time employees
                                   Employee.Salary,          # Annual full time employee salary
                                   Part.Time.Wage,           # Hourly rate for part time wages
                                   Harvest.Season,
                                   Harvest.Year,
                                   Gear.Specification
  )

  test$Product <- Product[i]
  # 
 output =  rbind(output,test)
  
  
}

S1.AB.PL <- output
S1.AB.PL$Scenario <- 'Scenario 1'
S1.AB.PL$Sub <- 'A/B'


# Scenario D/C 


output = data.frame()
######## Production Planning
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y2'
Gear.Specification <- 'Ear Hanging'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 1      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 1     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <-  P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                       Longline.Quantity,        # Number of longlines on the farm                  
                       Longline.Depth,           # Lease Depth (Feet) at low tide
                       Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                       Product[i],                  # Number of individual scallop spat
                       Year.Start,               # Year of projected farm operations start: Model begins August 1st
                       Consumables,              # Includes general expenditures like Gear,coffee,misc
                       Owner.salary,             # Predicted annual owner salary
                       Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                       Full.Time.Employee,       # Number of full time employees
                       Employee.Salary,          # Annual full time employee salary
                       Part.Time.Wage,           # Hourly rate for part time wages
                       Harvest.Season,
                       Harvest.Year,
                       Gear.Specification
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S1.DC.PL <- output
S1.DC.PL$Scenario <- 'Scenario 1'
S1.DC.PL$Sub <- 'C/D'

# Costs for 100000 scallop farm



# Scenario 2abcd: Ear Hanging sold after 2 years of grow out at 10,000 : 250000 by 10,000 
# Ear Hanging assumes an automated drilling machine is selected for these scenarios


output = data.frame()
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y3'
Gear.Specification <- 'Ear Hanging'
# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 0      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 0     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <-  P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                       Longline.Quantity,        # Number of longlines on the farm                  
                       Longline.Depth,           # Lease Depth (Feet) at low tide
                       Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                       Product[i],                  # Number of individual scallop spat
                       Year.Start,               # Year of projected farm operations start: Model begins August 1st
                       Consumables,              # Includes general expenditures like Gear,coffee,misc
                       Owner.salary,             # Predicted annual owner salary
                       Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                       Full.Time.Employee,       # Number of full time employees
                       Employee.Salary,          # Annual full time employee salary
                       Part.Time.Wage,           # Hourly rate for part time wages
                       Harvest.Season,
                       Harvest.Year,
                       Gear.Specification
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S2.AB.PL <- output
S2.AB.PL$Scenario <- 'Scenario 2'
S2.AB.PL$Sub <- 'A/B'

# Costs for 100000 scallop farm


# Scenario D/C 

output = data.frame()
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y3'
Gear.Specification <- 'Ear Hanging'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 1      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 1     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <-  P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                       Longline.Quantity,        # Number of longlines on the farm                  
                       Longline.Depth,           # Lease Depth (Feet) at low tide
                       Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                       Product[i],                  # Number of individual scallop spat
                       Year.Start,               # Year of projected farm operations start: Model begins August 1st
                       Consumables,              # Includes general expenditures like Gear,coffee,misc
                       Owner.salary,             # Predicted annual owner salary
                       Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                       Full.Time.Employee,       # Number of full time employees
                       Employee.Salary,          # Annual full time employee salary
                       Part.Time.Wage,           # Hourly rate for part time wages
                       Harvest.Season,
                       Harvest.Year,
                       Gear.Specification
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S2.DC.PL <- output
S2.DC.PL$Scenario <- 'Scenario 2'
S2.DC.PL$Sub <- 'C/D'

# Costs for 100000 scallop farm



# Scenario 3abcd: Lantern Net sold after 1 year of grow out at 10,000 : 250000 by 10,000 
# Ear Hanging assumes an automated drilling maching is selected for these scenarios

output = data.frame()
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y2'
Gear.Specification <- 'Lantern Net'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 0      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 0     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <-  P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                       Longline.Quantity,        # Number of longlines on the farm                  
                       Longline.Depth,           # Lease Depth (Feet) at low tide
                       Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                       Product[i],                  # Number of individual scallop spat
                       Year.Start,               # Year of projected farm operations start: Model begins August 1st
                       Consumables,              # Includes general expenditures like Gear,coffee,misc
                       Owner.salary,             # Predicted annual owner salary
                       Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                       Full.Time.Employee,       # Number of full time employees
                       Employee.Salary,          # Annual full time employee salary
                       Part.Time.Wage,           # Hourly rate for part time wages
                       Harvest.Season,
                       Harvest.Year,
                       Gear.Specification
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S3.AB.PL <- output
S3.AB.PL$Scenario <- 'Scenario 3'
S3.AB.PL$Sub <- 'A/B'

# Costs for 100000 scallop farm



# Scenario D/C 


output = data.frame()
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y2'
Gear.Specification <- 'Lantern Net'
# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 1      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 1     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <-  P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                       Longline.Quantity,        # Number of longlines on the farm                  
                       Longline.Depth,           # Lease Depth (Feet) at low tide
                       Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                       Product[i],                  # Number of individual scallop spat
                       Year.Start,               # Year of projected farm operations start: Model begins August 1st
                       Consumables,              # Includes general expenditures like Gear,coffee,misc
                       Owner.salary,             # Predicted annual owner salary
                       Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                       Full.Time.Employee,       # Number of full time employees
                       Employee.Salary,          # Annual full time employee salary
                       Part.Time.Wage,           # Hourly rate for part time wages
                       Harvest.Season,
                       Harvest.Year,
                       Gear.Specification
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S3.DC.PL <- output
S3.DC.PL$Scenario <- 'Scenario 3'
S3.DC.PL$Sub <- 'C/D'

# Costs for 100000 scallop farm



# Scenario 4abcd: Lantern Net sold after 2 years of grow out at 10,000 : 250000 by 10,000 
# Ear Hanging assumes an automated drilling maching is selected for these scenarios


output = data.frame()
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y3'
Gear.Specification <- 'Lantern Net'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 0      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 0     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <-  P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                       Longline.Quantity,        # Number of longlines on the farm                  
                       Longline.Depth,           # Lease Depth (Feet) at low tide
                       Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                       Product[i],                  # Number of individual scallop spat
                       Year.Start,               # Year of projected farm operations start: Model begins August 1st
                       Consumables,              # Includes general expenditures like Gear,coffee,misc
                       Owner.salary,             # Predicted annual owner salary
                       Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                       Full.Time.Employee,       # Number of full time employees
                       Employee.Salary,          # Annual full time employee salary
                       Part.Time.Wage,           # Hourly rate for part time wages
                       Harvest.Season,
                       Harvest.Year,
                       Gear.Specification
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S4.AB.PL <- output
S4.AB.PL$Scenario <- 'Scenario 4'
S4.AB.PL$Sub <- 'A/B'

# Costs for 100000 scallop farm



# Scenario D/C 

output = data.frame()
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y3'
Gear.Specification <- 'Lantern Net'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 1      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 1     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <-  P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                       Longline.Quantity,        # Number of longlines on the farm                  
                       Longline.Depth,           # Lease Depth (Feet) at low tide
                       Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                       Product[i],                  # Number of individual scallop spat
                       Year.Start,               # Year of projected farm operations start: Model begins August 1st
                       Consumables,              # Includes general expenditures like Gear,coffee,misc
                       Owner.salary,             # Predicted annual owner salary
                       Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                       Full.Time.Employee,       # Number of full time employees
                       Employee.Salary,          # Annual full time employee salary
                       Part.Time.Wage,           # Hourly rate for part time wages
                       Harvest.Season,
                       Harvest.Year,
                       Gear.Specification
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S4.DC.PL <- output
S4.DC.PL$Scenario <- 'Scenario 4'
S4.DC.PL$Sub <- 'C/D'

# Costs for 100000 scallop farm



# Combine all scenarios
Scaling <- rbind(S1.AB.PL,S1.DC.PL,S2.AB.PL,S2.DC.PL,S3.AB.PL,S3.DC.PL,S4.AB.PL,S4.DC.PL)

# categorize into grow-out and harvest years
Scaling$Growout <- ifelse(Scaling$Scenario == "Scenario 1" | Scaling$Scenario == "Scenario 2", 'Ear Hanging', 'Lantern Net')
Scaling$Harvest.Year <- ifelse(Scaling$Scenario == "Scenario 1" | Scaling$Scenario == "Scenario 3", '1 Year Grow-Out', 
                               '2 Years Grow-Out')

# Offset scenarios for comparison on the same plot
Scaling$offset.Year <- ifelse(Scaling$Sub == 'A/B', Scaling$Year+.1, Scaling$Year-.1)

# Create a scaling break from 50000 to 200000 as the general area where model preset parameters are considered normal
Scaling.sub1 <- subset(Scaling, Product >50000 & Product <200000)

# Create a scaling visualization for showcasing the metrics
Scaling.sub <- subset(Scaling.sub1, Growout == 'Ear Hanging'& Harvest.Year == '2 Years Grow-Out')

# Visualization 

library(viridis)
#  Plot trio to show the difference between metrics in plots 
P1 <-ggplot(Scaling.sub, aes(x = offset.Year))  + 
  geom_point(aes(y = MaxPrice.AdductorWeight, shape = Sub), size = 1.2)+
  geom_point (data = subset(Scaling.sub, Product == 100000), aes(x=offset.Year, y=MaxPrice.AdductorWeight,shape=Sub), color = 'green',size=5,pch=21) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ggtitle("Break Even Price for Scaled Production 50000-200000 Seed in Ear Hanging Harvesting after 2 years") +
  ylab("Annual Yearly Break Even Sales Price")+
  labs(color = "Projected Starting Seed")+
  xlab("Business Year")+
  theme(plot.title = element_text(size=14, face="bold"),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "right",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 


Scaling.sub.10 <- subset(Scaling.sub, Year == 10)
P2 <- ggplot(Scaling.sub.10, aes(x = Product, y = MinPrice.AdductorWeight))  + 
  geom_line( size = 1.2)+
  geom_point(data=subset(Scaling.sub.10, Product == 100000), aes(x=Product,y=MinPrice.AdductorWeight), size=5,fill='gold',pch=21) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ggtitle("Run Rate Price for Scaled Production 50000-200000 Seed in Ear Hanging Harvesting after 2 years") +
  ylab("Run Rate")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_text(size=14, face="bold"),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 
  
  P3 <- ggplot(data = subset(Scaling.sub, Product == 100000), aes(x=offset.Year, y=MaxPrice.AdductorWeight,shape=Sub))  + 
    geom_point(size=5, fill = 'green',pch=21) +
    geom_hline(data=subset(Scaling.sub.10, Product == 100000), aes(yintercept=MinPrice.AdductorWeight),size=1.2, color='gold',linetype='dashed') +
    theme_minimal() +
    theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
    theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
    ggtitle("Single Production Scenario for 100,000 Seed Farm")+
  ylab("Cost per lbs to Break Even (Green) and Run Rate(Gold)")+ 
    labs(color = "Grow-Out Type", linetype = "Harvest")+
    xlab("Business Year")+
    theme(plot.title = element_text(size=14, face="bold"),
          strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
          strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
          legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
          axis.title.y = element_text(face="bold", size=8,
                                      margin = margin(t = 0, r = 10, b = 0, l = 0)), 
          axis.text.y = element_text(size=12),
          axis.text.x = element_text(size=12, angle = 35, hjust = .85),
          panel.border = element_rect(colour = "black", fill=NA, size=1)) 
  
  plot_grid(P1,P2,P3,ncol=1)
 

   
# Plots showing the scale for all scenarios for whole scallops
  ggplot(Scaling.sub1, aes(x = offset.Year))  + 
    geom_point(aes(y = MaxPrice.WholeScallop, shape = Sub, color = Product), size = 1.2)+
    theme_minimal() +
    scale_color_viridis () +
    facet_grid (Growout~Harvest.Year)+
    theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
    theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
    ggtitle("Break Even Price for Scaled Production 50000-200000 Seed - Whole Scallop") +
    ylab("Annual Yearly Break Even Sales Price")+
    labs(color = "Projected Starting Seed")+
    xlab("Business Year")+
    theme(plot.title = element_text(size=14, face="bold"),
          strip.text.x = element_text(size=12, face="bold"), legend.position = "right",
          strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
          legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
          axis.title.y = element_text(face="bold", size=12,
                                      margin = margin(t = 0, r = 10, b = 0, l = 0)), 
          axis.text.y = element_text(size=12),
          axis.text.x = element_text(size=12, angle = 35, hjust = .85),
          panel.border = element_rect(colour = "black", fill=NA, size=1)) 
    
# Plots showing scenarios for adductor only
    ggplot(Scaling.sub1, aes(x = offset.Year))  + 
    geom_point(aes(y = MaxPrice.AdductorWeight, shape = Sub, color = Product), size = 1.2)+
    theme_minimal() +
    scale_color_viridis () +
    facet_grid (Growout~Harvest.Year)+
    theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
    theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
    ggtitle("Break Even Price for Scaled Production 50000-200000 Seed - Adductor Only") +
    ylab("Annual Yearly Break Even Sales Price")+
    labs(color = "Projected Starting Seed")+
    xlab("Business Year")+
    theme(plot.title = element_text(size=14, face="bold"),
          strip.text.x = element_text(size=12, face="bold"), legend.position = "right",
          strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
          legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
          axis.title.y = element_text(face="bold", size=12,
                                      margin = margin(t = 0, r = 10, b = 0, l = 0)), 
          axis.text.y = element_text(size=12),
          axis.text.x = element_text(size=12, angle = 35, hjust = .85),
          panel.border = element_rect(colour = "black", fill=NA, size=1))   
  
    Scaling.sub1.10 <- subset(Scaling.sub1, Year == 10)  
  

# Runr Rate cap ex doesn't matter here    

P1 <- ggplot(Scaling.sub1.10, aes(x = Product, y = MinPrice.WholeScallop))  + 
      geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
      theme_minimal() +
      theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
      theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
      ylab("Run Rate")+
      labs(color = "Grow-Out Type", linetype = "Harvest")+
      xlab("Total Seed Goal")+
      theme(plot.title = element_blank (),
            strip.text.x = element_text(size=12, face="bold"), legend.position = 'none',
            strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
            legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
            axis.title.y = element_text(face="bold", size=12,
                                        margin = margin(t = 0, r = 10, b = 0, l = 0)), 
            axis.text.y = element_text(size=12),
            axis.text.x = element_blank(),
            panel.border = element_rect(colour = "black", fill=NA, size=1))    
    
P2 <- ggplot(Scaling.sub1.10, aes(x = Product, y = MinPrice.AdductorWeight))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("Run Rate")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

plot_grid(P1,P2,nrow = 2, labels = c('Whole Scallop', 'Adductor Only'))

# Debt fulfillment timing

ggplot(Scaling.sub1.10, aes(x = Product, y = MaxPrice.WholeScallop))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  theme_minimal() +
  facet_grid(~Sub) +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("10 Year Price to Debt Fulfillment")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

ggplot(Scaling.sub1.10, aes(x = Product, y = MaxPrice.AdductorWeight))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  theme_minimal() +
  facet_grid(~Sub) +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("10 Year Price to Debt Fulfillment")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

Scaling.sub.4 <- subset(Scaling.sub1, Year == 4)

ggplot(Scaling.sub.4, aes(x = Product, y = MaxPrice.AdductorWeight))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  theme_minimal() +
  facet_grid(~Sub) +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("4 Year Price to Debt Fulfillment")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

ggplot(subset(Scaling, Year == 10), aes(x = AnnualScallop.AdductorWeight, y = Depreciation))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  theme_minimal() +
  facet_grid(~Sub) +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("10 Year Price to Debt Fulfillment")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 


ggplot(Scaling, aes(x = Product, y = Lease.Footprint.Acres))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  geom_hline(aes(yintercept = 3.9), color = 'blue') +
  annotate("text", x=900000, y=5.2, label="Median Maine Lease Size = 3.9 acres") +
  geom_hline(aes(yintercept = 8.04), color = 'blue') +
  annotate("text", x=900000, y=9.3, label="Mean Maine Lease Size = 8.04 acres") +
  geom_hline(aes(yintercept = 22.028), color = 'blue') +
  annotate("text", x=250000, y=23.3, label="90th Percentile Maine Lease Size = 22 acres") +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("Lease Size (Acres)")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 


library(treemapify)

scaling.costs <- gather(Scaling.sub1,'Category','Cost', Fuel:Depreciation)
scaling.costs <- subset (scaling.costs, Product == 50000 | Product == 150000 | Product == 250000)
scaling.costs <- subset(scaling.costs, Sub == 'C/D'&Harvest.Year == '2 Years Grow-Out')

ggplot(scaling.costs, aes(area =Cost, fill = Category,
                          label = paste(Category, Cost, sep = "\n")))  + 
  geom_treemap() +
  geom_treemap_text(colour = "white",
                    place = "centre",
                    size = 15) +
  facet_grid(Product~Growout) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
 
  labs(fill = "Annual Cost Category")+

  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

scaling.costs.2 <- gather(Scaling.sub,'Category','Cost', c(Fuel:Depreciation,Total.Annual.Costs))
scaling.costs.2 <- subset(scaling.costs.2, Category == 'Total.Annual.Costs')
scaling.costs.2 <- subset (scaling.costs.2, Product == 50000 | Product == 150000 | Product == 250000)
scaling.costs.2 <- subset(scaling.costs.2, Sub == 'C/D')   

ggplot(scaling.costs.2, aes(area =Cost, fill = Growout,
                          label = paste(Category, Cost, sep = "\n")))  + 
  geom_treemap() +
  geom_treemap_text(colour = "white",
                    place = "centre",
                    size = 15) +
  facet_grid (Product~Harvest.Year) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  
  labs(fill = "Annual Cost Category")+
  
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1))


scaling.costs.3 <- scaling.costs
scaling.costs.3$Costs <- ifelse(scaling.costs.3$Category == 'Labor', scaling.costs.3$Cost-50000, scaling.costs.3$Cost)

ggplot(scaling.costs.3, aes(area =Costs, fill = Category,
                          label = paste(Category, Costs, sep = "\n")))  + 
  geom_treemap() +
  geom_treemap_text(colour = "white",
                    place = "centre",
                    size = 15) +
  facet_grid(Product~Growout) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  
  labs(fill = "Annual Cost Category")+
  
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

# Let's try a bump chart

x <- seq(0,1000000, by=50000)

library(ggbump)
scaling.costs.3 <- gather(Scaling.sub,'Category','Cost', Fuel:Depreciation)
scaling.costs.3 <- subset(scaling.costs.3, Sub == 'C/D'&Harvest.Year == '2 Years Grow-Out')
scaling.costs.3 <- subset(scaling.costs.3, Product == 10000 |Product == 150000 |Product == 300000 |Product == 450000 |Product == 600000 |Product == 750000 |Product == 900000 |Product == 1000000 )
scaling.costs.3$Costs <- ifelse(scaling.costs.3$Category == 'Labor', scaling.costs.3$Cost-50000, scaling.costs.3$Cost)
scaling.costs.3$Total.Annual.Costs<- scaling.costs.3$Total.Annual.Costs-50000
scaling.costs.3$Prop.cost <- scaling.costs.3$Costs/scaling.costs.3$Total.Annual.Costs

P2 <- ggplot(scaling.costs.3, aes( x=Product, y = Prop.cost, color = Category))  + 
  geom_bump(size=1.5) +
  geom_point(size=3)+
  facet_grid (~Growout) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  
  labs(fill = "Annual Cost Category")+
  
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1))

library(cowplot)
plot_grid(P1,P2, ncol=1)

scaling.costs.3$Product <- as.factor(scaling.costs.3$Product)
 ggplot(scaling.costs.3, aes(y = Costs,x = Product, fill = Category))  + 
  geom_bar(stat = 'identity') +
  facet_grid (~Growout) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  
  labs(fill = "Annual Cost Category")+
  
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1))
 
 Scaling.Hours <- Scaling
 Scaling.Hours <- aggregate(data = Scaling.Hours, Hours.Worked ~ Product+Growout+Harvest.Year,sum,na.rm=TRUE) 
Scaling.Hours$Days <- Scaling.Hours$Hours.Worked/8 

Scaling.Hours.Sub <- subset(Scaling.Hours, Product<200000)
ggplot(Scaling.Hours.Sub, aes(x = Product, y = Days))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("Days Worked (Based on 8 Hour Day)")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 


