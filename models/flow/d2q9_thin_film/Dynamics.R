# Density - table of variables of LB Node to stream
#  name - variable name to stream
#  dx,dy,dz - direction of streaming
#  comment - additional comment

AddDensity( name="f[0]", dx= 0, dy= 0, group="f")
AddDensity( name="f[1]", dx= 1, dy= 0, group="f")
AddDensity( name="f[2]", dx= 0, dy= 1, group="f")
AddDensity( name="f[3]", dx=-1, dy= 0, group="f")
AddDensity( name="f[4]", dx= 0, dy=-1, group="f")
AddDensity( name="f[5]", dx= 1, dy= 1, group="f")
AddDensity( name="f[6]", dx=-1, dy= 1, group="f")
AddDensity( name="f[7]", dx=-1, dy=-1, group="f")
AddDensity( name="f[8]", dx= 1, dy=-1, group="f")


AddDensity( name="h_Z", dx=0, dy=0, group="HZ", parameter=T)


# THIS QUANTITIES ARE NEEDED FOR PYTHON INTEGRATION EXAMPLE
# COMMENT OUT FOR PERFORMANCE
# If present thei are used:
# As VelocityX/Y for Boundary conditions
# As mass force (+ GravitationX/Y) in fluid
#AddDensity( name="BC[0]", dx=0, dy=0, group="BC")
#AddDensity( name="BC[1]", dx=0, dy=0, group="BC")


AddStage("BaseIteration", "Run", 
         load=DensityAll$group == "f" | DensityAll$group == "HZ",  
         save=Fields$group=="f" | Fields$group=="HZ"
         ) 
AddStage("BaseInit", "Init",  save=Fields$group=="f" | Fields$group == "HZ") 

AddAction("Iteration", c("BaseIteration"))
AddAction("Init", c("BaseInit"))


# Quantities - table of fields that can be exported from the LB lattice (like density, velocity etc)
#  name - name of the field
#  type - C type of the field, "real_t" - for single/double float, and "vector_t" for 3D vector single/double float
# Every field must correspond to a function in "Dynamics.c".
# If one have filed [something] with type [type], one have to define a function: 
# [type] get[something]() { return ...; }

AddQuantity(name="Rho",unit="kg/m3")
AddQuantity(name="U",unit="m/s",vector=T)
AddQuantity(name="H_Z")

# Settings - table of settings (constants) that are taken from a .xml file
#  name - name of the constant variable
#  comment - additional comment
# You can state that another setting is 'derived' from this one stating for example: RelaxationRate='1.0/(3*Viscosity + 0.5)'

AddSetting(
           name="RelaxationRate", 
           S2='1-RelaxationRate',       
           comment='one over relaxation time'
            )
AddSetting(name="Viscosity", RelaxationRate='1.0/(3*Viscosity + 0.5)', default=0.16666666, comment='viscosity')
AddSetting(name="VelocityX", default=0, comment='inlet/outlet/init velocity', zonal=T)
AddSetting(name="VelocityY", default=0, comment='inlet/outlet/init velocity', zonal=T)
AddSetting(name="Pressure", default=0, comment='inlet/outlet/init density', zonal=T)

AddSetting(name="Height", default=1, comment='iinitial height in Z direction', zonal=T)

AddSetting(name="BrinkmanHeightInv", default=0, zonal=T)

AddSetting(name="GravitationX")
AddSetting(name="GravitationY")
# Globals - table of global integrals that can be monitored and optimized

AddGlobal(name="PressureLoss", comment='pressure loss', unit="1mPa")
AddGlobal(name="OutletFlux", comment='pressure loss', unit="1m2/s")
AddGlobal(name="InletFlux", comment='pressure loss', unit="1m2/s")

AddSetting(name="S2", default="0", comment='MRT Sx')
AddSetting(name="S3", default="0", comment='MRT Sx')
AddSetting(name="S4", default="0", comment='MRT Sx')

AddSetting(name="nubuffer",default=0.01, comment='Viscosity in the buffer layer (cumulant)')

#Node types for boundaries
AddNodeType(name="EPressure", group="BOUNDARY")
AddNodeType(name="WPressure", group="BOUNDARY")

AddNodeType(name="NVelocity", group="BOUNDARY")
AddNodeType(name="SVelocity", group="BOUNDARY")
AddNodeType(name="WVelocity", group="BOUNDARY")
AddNodeType(name="EVelocity", group="BOUNDARY")

AddNodeType(name="NSymmetry", group="BOUNDARY")
AddNodeType(name="SSymmetry", group="BOUNDARY")


AddNodeType(name="Cumulant", group="COLLISION")
AddNodeType("Inlet","OBJECTIVE")
AddNodeType("Outlet","OBJECTIVE")
