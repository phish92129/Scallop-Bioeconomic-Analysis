

####### Input Longline and Lease Specifications ######

# Leasing Setup and fees
Lease.Type <- 'Standard Lease'

# Longline System Specs
Longline.Quantity = 1     # Number of longlines on the farm                 
Longline.Depth = 60     # Lease Depth (Feet) at low tide
Longline.Suspended.Depth = 15     #Projected Longline Depth at low tide

############## Business Model ##############

Product <- 100000     # Number of individual scallop spat
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
Harvest.Year <- 'Y1'
Gear.Specification <- 'Lantern Net'

# Y0 Product Metrics - Spat Procurement and Nursery Culture

Wild.Spat.Collector <- 2500     # Number of Wild Spat estimated/collector
Spat.Site.Depth <- 150  # Assumes a Depth of 150 feet
Seed.Net.Density <- 250     # Assumes 250/tier initial stocking density

# Y1 Product Metrics - Intermediate Culture

Y1.Stocking.Density <- 30     # Intermediary Culture stocking density (recommended 45-25)

# Year 2/3 August 01 Y2 to August 01 Y4

# Y2/Y3 Product Metrics - Lantern Net

Y2.LN.Stocking.Density <- 10
Y3.LN.Stocking.Density <- 10

# Y2/Y3 Product Metrics - Lantern Net

Y2.EH.Dropper.Scallops.per <- 140     # Total scallops per dropper (would relate to 70 paired)
Y2.EH.Scallop.Spacing <- .5    # In feet
Y2.EH.Dropper.Margins <- 10   # In feet


# Ear Hanging - Grow-Out in Ear Hanging
Y0.Mortality <- .12   # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
Y1.Mortality <- .12     # Mortality from August Y1 till August Y2
Y2.Mortality <- .12
Y3.Mortality <- .12



############## Costs and secondary Inputs ###########

# Secondary Inputs

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
######## Scenarios #######
S1<-         P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                  Longline.Quantity,        # Number of longlines on the farm                  
                  Longline.Depth,           # Lease Depth (Feet) at low tide
                  Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                  Product,                  # Number of individual scallop spat
                  Year.Start,               # Year of projected farm operations start: Model begins August 1st
                  Consumables,              # Includes general expenditures like Gear,coffee,misc
                  Owner.salary,             # Predicted annual owner salary
                  Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                  Full.Time.Employee,       # Number of full time employees
                  Employee.Salary,          # Annual full time employee salary
                  Part.Time.Wage,           # Hourly rate for part time wages
                  Harvest.Season,
                  Harvest.Year,
                  Gear.Specification, 
                  Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                  Spat.Site.Depth,          # Depth at which spat collection lines are set
                  Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                  Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                  Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                  Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                  Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                  Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                  Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                  Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                  Y1.Mortality,             # Mortality from August Y1 till August Y2
                  Y2.Mortality,             # Mortality from August Y2 till August Y3
                  Y3.Mortality             # Mortality from August Y3 till August Y4
                  
)

####### Scenarios: Lantern Net starting from Y1 Summer - Y3 Summer
######## Production Planning
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y1'
Gear.Specification <- 'Lantern Net'

S.S.Y1.LN <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                  Longline.Quantity,        # Number of longlines on the farm                  
                  Longline.Depth,           # Lease Depth (Feet) at low tide
                  Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                  Product,                  # Number of individual scallop spat
                  Year.Start,               # Year of projected farm operations start: Model begins August 1st
                  Consumables,              # Includes general expenditures like Gear,coffee,misc
                  Owner.salary,             # Predicted annual owner salary
                  Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                  Full.Time.Employee,       # Number of full time employees
                  Employee.Salary,          # Annual full time employee salary
                  Part.Time.Wage,           # Hourly rate for part time wages
                  Harvest.Season,
                  Harvest.Year,
                  Gear.Specification, 
                  Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                  Spat.Site.Depth,          # Depth at which spat collection lines are set
                  Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                  Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                  Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                  Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                  Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                  Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                  Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                  Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                  Y1.Mortality,             # Mortality from August Y1 till August Y2
                  Y2.Mortality,             # Mortality from August Y2 till August Y3
                  Y3.Mortality             # Mortality from August Y3 till August Y4
                  
)

S.S.Y1.LN$Gear <- Gear.Specification
S.S.Y1.LN$Y.class <- Harvest.Year
S.S.Y1.LN$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Fall'
Harvest.Year <- 'Y2'

S.F.Y2.LN <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.F.Y2.LN$Gear <- Gear.Specification
S.F.Y2.LN$Y.class <- Harvest.Year
S.F.Y2.LN$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Winter'
Harvest.Year <- 'Y2'

S.W.Y2.LN <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.W.Y2.LN$Gear <- Gear.Specification
S.W.Y2.LN$Y.class <- Harvest.Year
S.W.Y2.LN$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Spring'
Harvest.Year <- 'Y2'

S.Sp.Y2.LN <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.Sp.Y2.LN$Gear <- Gear.Specification
S.Sp.Y2.LN$Y.class <- Harvest.Year
S.Sp.Y2.LN$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y2'

S.S.Y2.LN <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.S.Y2.LN$Gear <- Gear.Specification
S.S.Y2.LN$Y.class <- Harvest.Year
S.S.Y2.LN$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Fall'
Harvest.Year <- 'Y3'

S.F.Y3.LN <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.F.Y3.LN$Gear <- Gear.Specification
S.F.Y3.LN$Y.class <- Harvest.Year
S.F.Y3.LN$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Winter'
Harvest.Year <- 'Y3'

S.W.Y3.LN <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.W.Y3.LN$Gear <- Gear.Specification
S.W.Y3.LN$Y.class <- Harvest.Year
S.W.Y3.LN$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Spring'
Harvest.Year <- 'Y3'

S.Sp.Y3.LN <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.Sp.Y3.LN$Gear <- Gear.Specification
S.Sp.Y3.LN$Y.class <- Harvest.Year
S.Sp.Y3.LN$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y3'

S.S.Y3.LN <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.S.Y3.LN$Gear <- Gear.Specification
S.S.Y3.LN$Y.class <- Harvest.Year
S.S.Y3.LN$S.class <- Harvest.Season

S.Seasonal <- rbind(S.S.Y1.LN,S.F.Y2.LN,S.W.Y2.LN,S.Sp.Y2.LN,S.S.Y2.LN,S.F.Y3.LN,S.W.Y3.LN,S.Sp.Y3.LN,S.S.Y3.LN)
S.Seasonal <- subset(S.Seasonal, Year == 10)

####### Scenarios: Lantern Net starting from Y1 Summer - Y3 Summer
######## Production Planning
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y1'
Gear.Specification <- 'Ear Hanging'

S.S.Y1.EH <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.S.Y1.EH$Gear <- Gear.Specification
S.S.Y1.EH$Y.class <- Harvest.Year
S.S.Y1.EH$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Fall'
Harvest.Year <- 'Y2'

S.F.Y2.EH <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.F.Y2.EH$Gear <- Gear.Specification
S.F.Y2.EH$Y.class <- Harvest.Year
S.F.Y2.EH$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Winter'
Harvest.Year <- 'Y2'

S.W.Y2.EH <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.W.Y2.EH$Gear <- Gear.Specification
S.W.Y2.EH$Y.class <- Harvest.Year
S.W.Y2.EH$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Spring'
Harvest.Year <- 'Y2'

S.Sp.Y2.EH <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                          Longline.Quantity,        # Number of longlines on the farm                  
                          Longline.Depth,           # Lease Depth (Feet) at low tide
                          Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                          Product,                  # Number of individual scallop spat
                          Year.Start,               # Year of projected farm operations start: Model begins August 1st
                          Consumables,              # Includes general expenditures like Gear,coffee,misc
                          Owner.salary,             # Predicted annual owner salary
                          Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                          Full.Time.Employee,       # Number of full time employees
                          Employee.Salary,          # Annual full time employee salary
                          Part.Time.Wage,           # Hourly rate for part time wages
                          Harvest.Season,
                          Harvest.Year,
                          Gear.Specification, 
                          Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                          Spat.Site.Depth,          # Depth at which spat collection lines are set
                          Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                          Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                          Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                          Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                          Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                          Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                          Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                          Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                          Y1.Mortality,             # Mortality from August Y1 till August Y2
                          Y2.Mortality,             # Mortality from August Y2 till August Y3
                          Y3.Mortality             # Mortality from August Y3 till August Y4
                          
)

S.Sp.Y2.EH$Gear <- Gear.Specification
S.Sp.Y2.EH$Y.class <- Harvest.Year
S.Sp.Y2.EH$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y2'

S.S.Y2.EH <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.S.Y2.EH$Gear <- Gear.Specification
S.S.Y2.EH$Y.class <- Harvest.Year
S.S.Y2.EH$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Fall'
Harvest.Year <- 'Y3'

S.F.Y3.EH <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.F.Y3.EH$Gear <- Gear.Specification
S.F.Y3.EH$Y.class <- Harvest.Year
S.F.Y3.EH$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Winter'
Harvest.Year <- 'Y3'

S.W.Y3.EH <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.W.Y3.EH$Gear <- Gear.Specification
S.W.Y3.EH$Y.class <- Harvest.Year
S.W.Y3.EH$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Spring'
Harvest.Year <- 'Y3'

S.Sp.Y3.EH <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                          Longline.Quantity,        # Number of longlines on the farm                  
                          Longline.Depth,           # Lease Depth (Feet) at low tide
                          Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                          Product,                  # Number of individual scallop spat
                          Year.Start,               # Year of projected farm operations start: Model begins August 1st
                          Consumables,              # Includes general expenditures like Gear,coffee,misc
                          Owner.salary,             # Predicted annual owner salary
                          Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                          Full.Time.Employee,       # Number of full time employees
                          Employee.Salary,          # Annual full time employee salary
                          Part.Time.Wage,           # Hourly rate for part time wages
                          Harvest.Season,
                          Harvest.Year,
                          Gear.Specification, 
                          Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                          Spat.Site.Depth,          # Depth at which spat collection lines are set
                          Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                          Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                          Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                          Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                          Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                          Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                          Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                          Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                          Y1.Mortality,             # Mortality from August Y1 till August Y2
                          Y2.Mortality,             # Mortality from August Y2 till August Y3
                          Y3.Mortality             # Mortality from August Y3 till August Y4
                          
)

S.Sp.Y3.EH$Gear <- Gear.Specification
S.Sp.Y3.EH$Y.class <- Harvest.Year
S.Sp.Y3.EH$S.class <- Harvest.Season

######## Production Planning
Harvest.Season <- 'Summer'
Harvest.Year <- 'Y3'

S.S.Y3.EH <- P.L.Season( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
                         Longline.Quantity,        # Number of longlines on the farm                  
                         Longline.Depth,           # Lease Depth (Feet) at low tide
                         Longline.Suspended.Depth, # Projected Longline Depth at low tide  
                         Product,                  # Number of individual scallop spat
                         Year.Start,               # Year of projected farm operations start: Model begins August 1st
                         Consumables,              # Includes general expenditures like Gear,coffee,misc
                         Owner.salary,             # Predicted annual owner salary
                         Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
                         Full.Time.Employee,       # Number of full time employees
                         Employee.Salary,          # Annual full time employee salary
                         Part.Time.Wage,           # Hourly rate for part time wages
                         Harvest.Season,
                         Harvest.Year,
                         Gear.Specification, 
                         Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
                         Spat.Site.Depth,          # Depth at which spat collection lines are set
                         Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
                         Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
                         Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
                         Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
                         Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
                         Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
                         Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
                         Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
                         Y1.Mortality,             # Mortality from August Y1 till August Y2
                         Y2.Mortality,             # Mortality from August Y2 till August Y3
                         Y3.Mortality             # Mortality from August Y3 till August Y4
                         
)

S.S.Y3.EH$Gear <- Gear.Specification
S.S.Y3.EH$Y.class <- Harvest.Year
S.S.Y3.EH$S.class <- Harvest.Season

S.Seasonal <- rbind(S.Seasonal,S.S.Y1.EH,S.F.Y2.EH,S.W.Y2.EH,S.Sp.Y2.EH,S.S.Y2.EH,S.F.Y3.EH,S.W.Y3.EH,S.Sp.Y3.EH,S.S.Y3.EH)
S.Seasonal <- subset(S.Seasonal, Year == 10)
order(S.Seasonal$S.class,decreasing = TRUE)

Y.Month <- data.frame(Predicted.full[,c(1,2,8,9)])
colnames(Y.Month)[1] = "Gear"
colnames(Y.Month)[3] = "Y.class"
colnames(Y.Month)[4] = "S.class"

S.Seasonal.t <- 
  left_join (S.Seasonal,Y.Month)

ggplot(S.Seasonal.t, aes(x = yrDate))  + 
  geom_point(aes(color = Gear, y = MaxPrice.AdductorWeight))+
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("10 Year Break Even price/lbs")+
  labs(color = 'Gear Type')+
  xlab("Year Month")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "right",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

ggplot(S.Seasonal.t, aes(x = yrDate))  + 
  geom_point(aes(color = Gear, y = MinPrice.AdductorWeight))+
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("Annual Operating price/lbs")+
  labs(color = 'Gear Type')+
  xlab("Year Month")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "right",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

ggplot(S.Seasonal.t, aes(x = yrDate))  + 
  geom_point(aes(color = Gear, y = MinPrice.WholeScallop))+
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("Annual Price/Scallop Operating Expenses")+
  labs(color = 'Gear Type')+
  xlab("Year Month")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "right",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1))
