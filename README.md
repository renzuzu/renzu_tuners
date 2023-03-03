# renzu_tuners
Fivem Advanced Vehicle System. Including Mileages , Degrations ,Multiple Engine Parts Variation like Racing Pistons , Tuning and more.

![image](https://user-images.githubusercontent.com/82306584/221592284-7bbf65f2-0e71-4158-a819-5e3277c255f6.png)

# Feature
- Multiple Engine Parts Upgrades. ex. Pistons, Camshaft.
- Engine Mileage
- Engine Parts Degrations. ex. mileage too high, over tuning, bad tuning.
- Scalable Engine Power - Engine Horsepower will decrease and increase depending on the Engine Efficieny Tuning %
- Multiple Tires Variations
- Tires Degration
- Vehicle Tuning System - includes Engine management, Gear Ratios, Boost Per Gears, Suspension Tuning.
- Dyno Tuning System - Semi Realistic tuning includes. Ignition Timing, Fuel Table, Final Drive Gear, Air Fuel Ratio.
- Advanced Vehicle Flags Items - utilise GTA CCarHandlingData - strHandlingFlags and strModelFlags. ex. Kinetic Energy.
- Support Changing Drivetrain - AWD, FWD, RWD.
- Job Based Upgrade Menu - Includes OEM, Elite, Pro, Racing and Ultimate Engine parts.
- Job Based Interactions - Supports Targets, Points System. (check vehicle status, tire status, engine performance, upgrade menu)
- Crafting System - All Items and Upgrades are Craftable.
- Supports Forced Induction - utilise renzu_turbo, renzu_nitro
- Engine Swap - utilise renzu_engine
- Built in Vehicle Mod Upgrade - ex. with Elite Full Upgrade is equivalent to normal GTA vehicle mod Engine, transmition lvl 4. with extra topspeed, acceleration.
- Transmission System - Set Manual Gears or Custom automatic Gears to support Custom Gear Ratios

# Commands
- this probably good in OX Radial menu.
- /tuning - Open Tuning Options if ECU is Installed.
- /upgrades - Open Package Installer. (install all in one parts by category ex. Elite)
- /repair - Simple Repair System. Single Action in Motorcycle type, and 4 Points Actions in 4 Wheels.
- /checkvehicle - See List of Engine parts status, if opened by job ex. mechanic, menu will open a upgrade.
- /manualgear - Set your current vehicle to manual gearings (arrow up and arrow down)
- /autogear - Set your current vehicle to use custom Automatic Gears. (supports gear ratios and more aggresive compare to vanilla ones.) / autogear 1 if you want to use Ecomode.
- /setmileage - set your current vehicle mileage (usage: /setmileage 1000)
- /sefuel - set your current vehicle fuel (usage: /setfuel 100) (ox_fuel)
- /sethandling - set your current vehicle parts health (usage: /sethandling 50) (max 100)

# Tuning FAQ.
- based on real life logic. semi realistic

- Ignition Timing - if ignition timing is too high, afr will become lean.
- Fuel Table - if fuel table is too high, afr will become rich.
- Final Drive - can be decrease or increase depending on your usage/track. Increase/Decrease overall topspeed of vehicle.
- Gear Ratios - Tune and decide how long or short the gear reach the redline. (this can decrease or increase duration of rpm)
- Boost Per Gears - Decide how much Turbo Pressure is allowed to enter in Intake Manifold. ( most usage is Lower boosting in lower gears to reduce Wheelspin) Over Boosting will result a Lean AFR. Lowering the boost might result a Rich AFR.

- Engine Efficiency - can be seen in Dyno Tuning. this dictate hows your engine Potencial based on your upgrade and ECU Tuning.
- AFR - This shows your current Air and Fuel Ratio. this dictate hows your engine performance, lower afr lower power and too much high AFR decrease power. Average and Recommended AFR value is 13.2 - 13.8 and 13.5 is the perfect tuning (redline)
- Engine Temperature - While in Dyno Engine can explode if your engine is too hot due to Lean tuning.
- Map Sensor - Dictate how much Air Pressure is going to Intake Manifold. this will increase when using Turbo and NOS.
- Turbo Tuning - This Produce a Massive Air Volume to Engine. can result Lean AFR and needs proper Engine Tuning Management.
- Stock Vehicle - If vehicle is default with no upgrades (ex. elite) AFR and Tuning Efficiency is always 100.
- Upgraded Engine - if vehicle is upgraded (ex. elite) Potencial is always around 80% Engine efficiency and lean AFR, all upgraded parts requires proper Tuning.

# Engine Parts Degration FAQ
- Stock Engine can degrade very fast if using NOS, Custom Turbo and Over Tuning in ECU.
- Upgraded Engine - if engine is fully upgraded (ex. elite, racing) degration is decrease, can still be degraded very fast if BAD tuning and BAD Afr.
- Mileage - Engine Degrades when specific mileage is reach.

# Engine Parts 
- Each Engine Parts have specific Handling assign to them (can be configure in config)
- Each Engine Parts have specific profiles assign to them (ex. compression, cam duration, fuel and etc.) this profiles increase the value on each variants. this profiles dictate the AFR and tuning efficiency (can be configure in config)


# Dependency
- ox_lib v3
- ox_inventory
- (ESX or qbcore)

# Inventory Support
- right now only ox_inventory/qb-inventory is supported
- Inventory porting is easy look for inventory.lua

# WIP TASKs
- ❌ thinking to support qb-menu and standalone notification, callbacks for the sake of people who cant use ox_lib from qbcore.
- ✔️ Supports Oxlib Radial in some commands.
- verify if degration is not too slow or too fast.
- ✔️ more inventory support.
- Camber Tuning - thinking a more optimise way since CCarhandlingData does not support other logic for Stancer.
- Create Simple Job Stash.
- other suggestion from community. (please dont suggest any mechanic job logic)


```
PS: Thank to MIST and his friend the modeler for providing a dynamometer model.
```

# Image Upgrade Menu
![image](https://user-images.githubusercontent.com/82306584/221533270-32ac81e9-159e-4eb9-a828-bec35a7233d7.png)
![image](https://user-images.githubusercontent.com/82306584/221533339-ea994f3d-c622-487d-ab86-3cb42ab5cc99.png)
![image](https://user-images.githubusercontent.com/82306584/221533421-75aac0b2-f5fd-4feb-92f8-dc49a7d9f9d9.png)
![image](https://user-images.githubusercontent.com/82306584/221533746-d51f34a3-f29c-4bcd-9a0d-472d9ec2ecf6.png)
![image](https://user-images.githubusercontent.com/82306584/221533792-2879da01-9607-4fae-bbd9-59b3c129b1c2.png)
![image](https://user-images.githubusercontent.com/82306584/221533993-f60ca10d-228d-409d-aa30-6fa503803406.png)
![image](https://user-images.githubusercontent.com/82306584/221534071-428bd778-989a-4666-8ec2-b3dbfa687872.png)
![image](https://user-images.githubusercontent.com/82306584/221534172-bcc4c7f8-49a5-4cb0-9207-6bdd8fdb0ede.png)
![image](https://user-images.githubusercontent.com/82306584/221534760-eb443728-2b71-421e-b931-d430d350e1c1.png)
![image](https://user-images.githubusercontent.com/82306584/221534798-5f74cc68-29cd-4930-96e3-6abb43a388a0.png)
![image](https://user-images.githubusercontent.com/82306584/222137773-fd684f4f-6447-4a9a-ae6f-d44b38f05838.png)




