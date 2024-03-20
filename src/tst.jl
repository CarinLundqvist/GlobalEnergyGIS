include("GlobalEnergyGIS.jl")
import .GlobalEnergyGIS as GEG

#Comment: ctrl + K + C
#Remove comment: ctrl + K +U

#How to make regions and states:
#region = ["USA_COL" GEG.GADM(["United States"],"Colorado")]
#GEG.saveregions("Colorado", region)
#GEG.makedistances("Colorado")

#Final assumptions
#"Australia",
regions = ["Brazil","Canada","China","Germany","Kenya","Netherlands","Nigeria","Venezuela","Vietnam"]
codes = ["GER","PRT","SWE"]
suffix = "CapDen"
categories = [0.4,1]
make_regions = false
for i in 1:length(regions)
    region = regions[i]
    if make_regions
        region_code = codes[i]
        if region_code == "USA"
            GEG.saveregions(region,GEG.usa9)
            GEG.makedistances(region)
        else
            regionlist = [region_code GEG.GADM(region)]
            GEG.saveregions(region,regionlist)
            GEG.makedistances(region)
        end
    end
    for j in 1:length(categories)
        GEG.GISwind(gisregion=region,
                    filenamesuffix = suffix * string(categories[j]),
                    onshore_density = categories[j],
                    area_onshore = 1, 
                    distance_elec_access = 150,
                    persons_per_km2 = 5000,
                    exclude_landtypes = [0],
                    protected_codes = [1,2,3,4,5,6,7,9],
                    onshoreclasses_min = [],
                    onshoreclasses_max = [],
                    offshore_density = 10,
                    area_offshore = 0.33,
                    max_depth = 50,
                    area_based_onshoreclasses = true,
                    number_of_classes = 10,
                    min_windspeed = 6,
                    plotmasks = false,
                    downsample_masks = 1,
                    savetodisk=true)
    end
    GEG.GISsolar(gisregion=region,
                filenamesuffix = suffix,
                plotmasks = false,
                downsample_masks = 1)
    GEG.GIShydro(gisregion=region)
    GEG.predictdemand(gisregion=region, sspscenario="ssp2-34", sspyear=2050, era_year=2018)
end

#GEG.createmaps("Sweden")
 
#POPULATION DENSITY
# regions = ["Sweden"]
# suffix = "_Test"
# categories = [5000]
# make_regions = false
# for i in 1:length(regions)
#     region = regions[i]
#     if make_regions
#         region_code = codes[i]
#         if region_code == "USA"
#             GEG.saveregions(region,GEG.usa9)
#             GEG.makedistances(region)
#         else
#             regionlist = [region_code GEG.GADM(region)]
#             GEG.saveregions(region,regionlist)
#             GEG.makedistances(region)
#         end
#     end
#     for j in 1:length(categories)
#         GEG.GISwind(gisregion=region,
#                     filenamesuffix = suffix*string(categories[j]),
#                     onshore_density = 1,
#                     area_onshore = 1, 
#                     distance_elec_access = 150,
#                     persons_per_km2 = categories[j],
#                     exclude_landtypes = [0],
#                     protected_codes = [],
#                     onshoreclasses_min = [],
#                     onshoreclasses_max = [],
#                     offshore_density = 10,
#                     area_offshore = 0.33,
#                     max_depth = 60,
#                     max_altitude = 1e4,
#                     savetodisk=false)
#     end
# end


#LAND TYPE
# regions = ["Australia","Brazil","Canada","Germany", "India","Kenya","Netherlands","Saudi Arabia"]
# codes = ["AUS","BRA","CAN","DEU","IND","KEN","NLD","SAU"]
# suffix = "_CapDen10_Landtype"
# categories = ["Water","Shrubland","Forest","Grassland","Cropland","Wetland","Urban","Barren and Ice"]
# values = [[0],[0,6,7,8],[0,1,2,3,4,5],[0,9,10],[0,12,14],[0,11],[0,13],[0,15,16]]
# make_regions = true
# for i in 1:length(regions)
#     region = regions[i]
#     if make_regions
#         regioncode = codes[i]
#         if regioncode == "USA"
#             GEG.saveregions(region,GEG.usa9)
#             GEG.makedistances(region)
#         elseif regioncode == "CHN"
#             GEG.saveregions(region,GEG.china6)
#             GEG.makedistances(region)
#         else
#             regionlist = [regioncode GEG.GADM(region)]
#             GEG.saveregions(region,regionlist)
#             GEG.makedistances(region)
#         end
#     end
#     for j in 1:length(categories)
#         GEG.GISwind(gisregion=region,
#                     filenamesuffix = suffix*categories[j],
#                     onshore_density = 10,
#                     area_onshore = 0.1, 
#                     distance_elec_access = 150,
#                     persons_per_km2 = 1e11,
#                     exclude_landtypes = values[j],
#                     protected_codes = [],
#                     onshoreclasses_min = [],
#                     onshoreclasses_max = [],
#                     offshore_density = 10,
#                     area_offshore = 0.33,
#                     max_depth = 60,
#                     savetodisk=true)
#     end
# end

#PROTECTED AREA
# regions = ["Brazil","Bulgaria","Cambodia","Germany","India","United States","Venezuela","Zambia"]
# codes = ["BRA","BGR","KHM","DEU","IND","USA","VEN","ZMB"]
# suffix = "_CapDen10_ProtectedArea"
# categories = ["No restriction","Strict NatRes","WildArea","NatPark","NatMonument","HabitatMang","ProtectedLandscape","MangResProtArea","Not reported","Not applicable","Not assigned"]
# values = [[],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10]]
# make_regions = true
# for i in 1:length(regions)
#     region = regions[i]
#     if make_regions
#         regioncode = codes[i]
#         if regioncode == "USA"
#             GEG.saveregions(region,GEG.usa9)
#             GEG.makedistances(region)
#         elseif regioncode == "CHN"
#             GEG.saveregions(region,GEG.china6)
#             GEG.makedistances(region)
#         else
#             regionlist = [regioncode GEG.GADM(region)]
#             GEG.saveregions(region,regionlist)
#             GEG.makedistances(region)
#         end
#     end
#     for j in 1:length(categories)
#         GEG.GISwind(gisregion=region,
#                     filenamesuffix = suffix*categories[j],
#                     onshore_density = 10,
#                     area_onshore = 0.1, 
#                     distance_elec_access = 150,
#                     persons_per_km2 = 1e11,
#                     exclude_landtypes = [0],
#                     protected_codes = values[j],
#                     onshoreclasses_min = [],
#                     onshoreclasses_max = [],
#                     offshore_density = 10,
#                     area_offshore = 0.33,
#                     max_depth = 60,
#                     savetodisk=true)
#     end
# end
