include("GlobalEnergyGIS.jl")
import .GlobalEnergyGIS as GEG

#Comment: ctrl + K + C
#Remove comment: ctrl + K +U

#How to make regions and states:
#region = ["USA_COL" GEG.GADM(["United States"],"Colorado")]
#GEG.saveregions("Colorado", region)
#GEG.makedistances("Colorado")
# const russia8 = [
#     "RU_NW"  GEG.GADM(["Russia"], "Arkhangel'sk","Vologda","Karelia","Komi","Leningrad","Murmansk","Nenets","Novgorod","Pskov","City of St. Petersburg")
#     "RU_C"   GEG.GADM(["Russia"], "Belgorod","Bryansk","Vladimir","Voronezh","Ivanovo","Kaluga","Kostroma","Kursk","Lipetsk","Moscow City","Moskva","Orel","Ryazan'","Smolensk","Tambov","Tver'","Tula","Yaroslavl'")
#     "RU_SW"  GEG.GADM(["Russia"], "Adygey","Astrakhan'","Volgograd","Kalmyk","Krasnodar","Rostov","Dagestan","Ingush","Kabardin-Balkar","Karachay-Cherkess","North Ossetia","Stavropol'","Chechnya")
#     "RU_VL"  GEG.GADM(["Russia"], "Bashkortostan","Kirov","Mariy-El","Mordovia","Nizhegorod","Orenburg","Penza","Perm'","Samara","Saratov","Tatarstan","Udmurt","Ul'yanovsk","Chuvash")
#     "RU_UR"  GEG.GADM(["Russia"], "Kurgan","Sverdlovsk","Tyumen'","Khanty-Mansiy","Chelyabinsk","Yamal-Nenets")
#     "RU_SB"  GEG.GADM(["Russia"], "Irkutsk","Krasnoyarsk","Tuva")
#     "RU_S"  GEG.GADM(["Russia"], "Altay","Gorno-Altay","Kemerovo","Novosibirsk","Omsk","Tomsk","Khakass")
#     "RU_E"   GEG.GADM(["Russia"], "Amur","Buryat","Yevrey","Zabaykal'ye","Maga Buryatdan","Primor'ye","Sakha","Sakhalin","Khabarovsk")
# ]
# const newZealand = [
#     "NZL_S"   GEG.GADM(["New Zealand"],"Southland", "Otago", "Canterbury", "West Coast", "Marlborough", "Nelson")
#     "NZL_N"   GEG.GADM(["New Zealand"], "Wellington", "Manawatu-Wanganui", "Hawke's Bay", "Taranaki", "Gisborne", "Bay of Plenty", "Waikato", "Auckland", "Northland")
# ]
# country = "Russia"
# GEG.saveregions(country,russia8)
# GEG.makedistances(country)
# country = "New Zealand"
# GEG.saveregions(country,newZealand)
# GEG.makedistances(country)

## Final assumptions
#"Australia",
#"New Zealand", "NZL",
regions = String.([:Brazil,:Canada,:China,:Germany,:Kenya,:Netherlands,:Nigeria,:Venezuela,:Vietnam])
regions = ["Estonia","Iceland","Ireland","Latvia"]
codes = ["GMB","SEN","SVK","CHE"]
suffix = "TEST"
categories = [0.35,1]
categories = [1]
make_regions = false
for i in 1:length(regions)
    region = regions[i]
    if make_regions
        region_code = codes[i]
        if region_code == "USA" || region_code == "CHN" || region_code == "NZL" || region_code == "RUS"
            #do nothing. The regions are already created as they should be 
        else
            regionlist = [region_code GEG.GADM(region)]
            GEG.saveregions(region,regionlist)
            GEG.makedistances(region)
        end
    end
    try
        for j in 1:length(categories)
            GEG.GISwind(gisregion=region,
                        filenamesuffix = suffix * string(categories[j]),
                        onshore_density = categories[j],
                        area_onshore = 1, 
                        distance_elec_access = 100,
                        persons_per_km2 = 1000,
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
                        savetodisk=false)
            # GEG.GISsolar(gisregion=region,
            #             filenamesuffix = suffix * string(categories[j]),
            #             plotmasks = false,
            #             downsample_masks = 1)
        end
        # GEG.GIShydro(gisregion=region)
        # GEG.predictdemand(gisregion=region, sspscenario="ssp2-34", sspyear=2050, era_year=2018)
    catch e
        @warn "$(region) has the error: $(e)"
    end
end

#GEG.createmaps("Sweden")
 
#POPULATION DENSITY
# path = "C:\\Users\\carin\\Documents\\Thesis\\Code\\regions_sorted.csv"
# regions = GEG.readdlm(path,',')[:,2]
# suffix = "_Final_PopDen"
# categories = [150,500,1000,5000]
# make_regions = false
# for i in 1:length(regions)
#     region = regions[i]
#     if make_regions
#         region_code = codes[i]
#         if region_code == "USA" || region_code == "CHN" || region_code == "NZL" || region_code == "RUS"
#             #do nothing. The regions are already created as they should be 
#         else
#             regionlist = [region_code GEG.GADM(region)]
#             GEG.saveregions(region,regionlist)
#             GEG.makedistances(region)
#         end
#     end
#     try
#         for j in 1:length(categories)
#             GEG.GISwind(gisregion=region,
#                         filenamesuffix = suffix*string(categories[j]),
#                         onshore_density = 1,
#                         area_onshore = 1, 
#                         distance_elec_access = 150,
#                         persons_per_km2 = categories[j],
#                         exclude_landtypes = [0],
#                         protected_codes = [],
#                         onshoreclasses_min = [],
#                         onshoreclasses_max = [],
#                         offshore_density = 10,
#                         area_offshore = 0.33,
#                         max_depth = 50,
#                         area_based_onshoreclasses = true,
#                         number_of_classes = 10,
#                         min_windspeed = 6,
#                         plotmasks = false,
#                         downsample_masks = 1,
#                         savetodisk=true)
#         end
#     catch e
#         @warn "$(region) has the error: $(e)"
#     end
# end


#LAND TYPE
#regions = ["Australia","Brazil","Canada","Germany", "India","Kenya","Netherlands","Saudi Arabia"]
#codes = ["AUS","BRA","CAN","DEU","IND","KEN","NLD","SAU"]
# path = "C:\\Users\\carin\\Documents\\Thesis\\Code\\regions_sorted.csv"
# regions = GEG.readdlm(path,',')[:,2]
# suffix = "_Final_Landtype"
# categories = ["Water","Shrubland","Forest","Grassland","Cropland","Wetland","Urban","Barren and Ice"]
# values = [[0],[0,6,7,8],[0,1,2,3,4,5],[0,9,10],[0,12,14],[0,11],[0,13],[0,15,16]]
# make_regions = false
# for i in 1:length(regions)
#     region = regions[i]
#     if make_regions
#         region_code = codes[i]
#         if region_code == "USA" || region_code == "CHN" || region_code == "NZL" || region_code == "RUS"
#             #do nothing. The regions are already created as they should be 
#         else
#             regionlist = [region_code GEG.GADM(region)]
#             GEG.saveregions(region,regionlist)
#             GEG.makedistances(region)
#         end
#     end
#     println("\nWorking on $(region)...")
#     try
#         for j in 1:length(categories)
#             GEG.GISwind(gisregion=region,
#                         filenamesuffix = suffix*categories[j],
#                         onshore_density = 1,
#                         area_onshore = 1, 
#                         distance_elec_access = 150,
#                         persons_per_km2 = 1e11,
#                         exclude_landtypes = values[j],
#                         protected_codes = [],
#                         onshoreclasses_min = [],
#                         onshoreclasses_max = [],
#                         offshore_density = 10,
#                         area_offshore = 0.33,
#                         max_depth = 50,
#                         area_based_onshoreclasses = true,
#                         number_of_classes = 10,
#                         min_windspeed = 6,
#                         plotmasks = false,
#                         downsample_masks = 1,
#                         savetodisk=true)
#         end
#     catch e
#         @warn "$(region) has the error: $(e)"
#     end
# end

#PROTECTED AREA
# regions = ["Brazil","Bulgaria","Cambodia","Germany","India","United States","Venezuela","Zambia"]
# codes = ["BRA","BGR","KHM","DEU","IND","USA","VEN","ZMB"]
# path = "C:\\Users\\carin\\Documents\\Thesis\\Code\\regions_sorted.csv"
# regions = GEG.readdlm(path,',')[:,2]
# codes = GEG.readdlm(path,',')[:,1]
# suffix = "_Final_ProtectedArea"
# categories = ["No restriction","Strict NatRes","WildArea","NatPark","NatMonument","HabitatMang","ProtectedLandscape","MangResProtArea","Not reported","Not applicable","Not assigned"]
# values = [[],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10]]
# make_regions = true
# for i in 1:length(regions)
#     region = regions[i]
#     if make_regions
#         region_code = codes[i]
#         if region_code == "USA" || region_code == "CHN" || region_code == "NZL" || region_code == "RUS"
#             #do nothing. The regions are already created as they should be 
#         else
#             regionlist = [region_code GEG.GADM(region)]
#             GEG.saveregions(region,regionlist)
#             GEG.makedistances(region)
#         end
#     end
#     println("\nWorking on $(region)...")
#     try
#         for j in 1:length(categories)
#             GEG.GISwind(gisregion=region,
#                         filenamesuffix = suffix*categories[j],
#                         onshore_density = 1,
#                         area_onshore = 1, 
#                         distance_elec_access = 150,
#                         persons_per_km2 = 1e11,
#                         exclude_landtypes = [0],
#                         protected_codes = values[j],
#                         onshoreclasses_min = [],
#                         onshoreclasses_max = [],
#                         offshore_density = 10,
#                         area_offshore = 0.33,
#                         max_depth = 50,
#                         area_based_onshoreclasses = true,
#                         number_of_classes = 10,
#                         min_windspeed = 6,
#                         plotmasks = false,
#                         downsample_masks = 1,
#                         savetodisk=true)
#         end
#     catch e
#         @warn "$(region) has the error: $(e)"
#     end
# end
