#-------------------------------------------------------------------------------------------------
# Copyright (c) 2020 5axes
# Initial Source from Johnny Matthews https://github.com/johnnygizmo/CuraSettingsWriter 
# The HTML plugin is released under the terms of the AGPLv3 or higher.
# Version 1.0.3 : simplify the source code with WriteTd
#               : Export also the meshfix paramater section by extruder and complementary information on extruder for machine definition
# Version 1.0.4 : html cleanup, no jquery dependency  thanks to https://github.com/etet100
# Version 1.0.5 : for configuration with multi extruder export the right extrudeur position and the information concerning the enabled
# Version 1.0.6 : table width='100%'
# Version 1.0.7 : Set in green variable modified in the top stack ( User modification )
# Version 1.0.8 : Option are now also translated
# Version 1.1.0 : New Top_Bottom category (for Beta and Master)
# Version 1.1.1 : Machine_manager.activeIntentCategory if Intent is used ( Ultimaker Machine)
# Version 1.1.2 : Bug correction with Arachne beta release
#-------------------------------------------------------------------------------------------------
import os
import platform

from datetime import datetime
from typing import cast, Dict, List, Optional, Tuple, Any, Set
from cura.CuraApplication import CuraApplication
from UM.Workspace.WorkspaceWriter import WorkspaceWriter
from UM.Settings.InstanceContainer import InstanceContainer

from cura.CuraVersion import CuraVersion  # type: ignore
from UM.Version import Version

from UM.i18n import i18nCatalog
i18n_cura_catalog = i18nCatalog("cura")
i18n_catalog = i18nCatalog("fdmprinter.def.json")
i18n_extrud_catalog = i18nCatalog("fdmextruder.def.json")

from UM.Logger import Logger
from UM.Message import Message

class HtmlCuraSettings(WorkspaceWriter):

    def write(self, stream, nodes, mode = WorkspaceWriter.OutputMode.TextMode):
    
        # Current File path
        # Logger.log("d", "stream = %s", os.path.abspath(stream.name))

        self.Major=1
        self.Minor=0

        # Logger.log('d', "Info Version CuraVersion --> " + str(Version(CuraVersion)))
        Logger.log('d', "Info CuraVersion --> " + str(CuraVersion))
        
        # Test version for futur release 4.9
        if "master" in CuraVersion or "beta" in CuraVersion or "BETA" in CuraVersion:
            # Master is always a developement version.
            self.Major=4
            self.Minor=9

        else:
            try:
                self.Major = int(CuraVersion.split(".")[0])
                self.Minor = int(CuraVersion.split(".")[1])
            except:
                pass
            
        
        stream.write("""<!DOCTYPE html>
            <meta charset='UTF-8'>
            <head>
                <title>Cura Settings Export</title>
                <style>
                    tr.category td { font-size: 1.1em; background-color: rgb(142,170,219); }
                    tr.disabled td { background-color: #eaeaea; color: #717171; }
                    tr.local td { background-color: #77DD77; }
                    body.hide-disabled tr.disabled { display: none; }
                    body.hide-local tr.normal { display: none; }
                    .val { width: 200px; text-align: right; }
                    .w-10 { width: 10%; }
                    .w-50 { width: 50%; }
                    .w-70 { width: 70%; }
                    .pl-l { padding-left: 20px; }
                    .pl-2 { padding-left: 40px; }
                    .pl-3 { padding-left: 60px; }
                    .pl-4 { padding-left: 80px; }
                    .pl-5 { padding-left: 100px; }
                </style>
            </head>
            <body lang=EN>
        \n""")
        
        machine_manager = CuraApplication.getInstance().getMachineManager()        
        stack = CuraApplication.getInstance().getGlobalContainerStack()

        global_stack = machine_manager.activeMachine

        TitleTxt =i18n_cura_catalog.i18nc("@label","Print settings")
        ButtonTxt = i18n_cura_catalog.i18nc("@action:label","Visible settings:")
        ButtonTxt2 = i18n_cura_catalog.i18nc("@action:label","Custom selection")

        stream.write("<h1>" + TitleTxt + "</h1>\n")
        stream.write("<button id='enabled'>" + ButtonTxt + "</button><P>\n")
        stream.write("<button id='local'>" + ButtonTxt2 + "</button><P>\n")

        # Script       
        stream.write("""<script>
                            var enabled = document.getElementById('enabled');
                            enabled.addEventListener('click', function() {
                                document.body.classList.toggle('hide-disabled');
                            });
                        </script>\n""")
        stream.write("""<script>
                            var local = document.getElementById('local');
                            local.addEventListener('click', function() {
                                document.body.classList.toggle('hide-local');
                            });
                        </script>\n""")
                        
        #Get extruder count
        extruder_count=stack.getProperty("machine_extruder_count", "value")
        print_information = CuraApplication.getInstance().getPrintInformation()
        
        stream.write("<table width='100%' border='1' cellpadding='3'>")
        # Job
        self._WriteTd(stream,i18n_cura_catalog.i18nc("@label","Job Name"),print_information.jobName)
        
        # File
        # self._WriteTd(stream,"File",os.path.abspath(stream.name))
        # Date
        self._WriteTd(stream,"Date",datetime.now().strftime("%d/%m/%Y %H:%M:%S"))
        # platform
        self._WriteTd(stream,"Os",str(platform.system()) + " " + str(platform.version()))
       
        # Version  
        self._WriteTd(stream,"Cura Version",CuraVersion)
            
        # Profile || Intent for Ultimaker Machine
        P_Name = global_stack.qualityChanges.getMetaData().get("name", "")
        if P_Name=="empty":
            P_Name = machine_manager.activeIntentCategory
            self._WriteTd(stream,i18n_cura_catalog.i18nc("@label","Intent"),P_Name)
        else:
            self._WriteTd(stream,i18n_cura_catalog.i18nc("@label","Profile"),P_Name)
        
        # Quality
        Q_Name = global_stack.quality.getMetaData().get("name", "")
        self._WriteTd(stream,i18n_cura_catalog.i18nc("@label:table_header","Quality"),Q_Name)
                
        # Material
        extruders = list(global_stack.extruders.values())      

        for Extrud in list(global_stack.extruders.values()):
            PosE = int(Extrud.getMetaDataEntry("position"))
            PosE += 1
            
            M_Name = Extrud.material.getMetaData().get("material", "")
            
            MaterialStr="%s %s : %d"%(i18n_cura_catalog.i18nc("@label", "Material"),i18n_cura_catalog.i18nc("@label", "Extruder"),PosE)
            self._WriteTd(stream,MaterialStr,M_Name)
            
            if extruder_count>1:
                M_Enabled = Extrud.getMetaDataEntry("enabled")
                EnabledStr="%s %s : %d"%(i18n_cura_catalog.i18nc("@label", "Extruder"),i18n_cura_catalog.i18nc("@label", "Enabled"),PosE)
                self._WriteTd(stream,EnabledStr,M_Enabled)
            
        MAterial=0
        #   materialWeights
        for Mat in list(print_information.materialWeights):
            MAterial=MAterial+Mat
        if MAterial>0:
            M_Weight= "{:.1f} g".format(MAterial).rstrip("0").rstrip(".")
            self._WriteTd(stream,i18n_cura_catalog.i18nc("@label","Material estimation"),M_Weight)            
            
            #   Print time
            P_Time = "%d d %d h %d mn"%(print_information.currentPrintTime.days,print_information.currentPrintTime.hours,print_information.currentPrintTime.minutes)
            self._WriteTd(stream,i18n_cura_catalog.i18nc("@label","Printing Time"),P_Time)   
            
        # Define every section to get the same order as in the Cura Interface
        # Modification from global_stack to extruders[0]
        i=0
        for Extrud in list(global_stack.extruders.values()):    
            i += 1                        
            self._doTree(Extrud,"resolution",stream,0,i)
            # Shell before 4.9 and now walls
            self._doTree(Extrud,"shell",stream,0,i)
            # New section Arachne and 4.9 ?
            if self.Major > 4 or ( self.Major == 4 and self.Minor >= 9 ) :
                self._doTree(Extrud,"top_bottom",stream,0,i)

            self._doTree(Extrud,"infill",stream,0,i)
            self._doTree(Extrud,"material",stream,0,i)
            self._doTree(Extrud,"speed",stream,0,i)
            self._doTree(Extrud,"travel",stream,0,i)
            self._doTree(Extrud,"cooling",stream,0,i)

            # If single extruder doesn't export the data
            if extruder_count>1 :
                self._doTree(Extrud,"dual",stream,0,i)

        self._doTree(extruders[0],"support",stream,0,0)
        self._doTree(extruders[0],"platform_adhesion",stream,0,0)
        
        i=0
        for Extrud in list(global_stack.extruders.values()):
            i += 1
            self._doTree(Extrud,"meshfix",stream,0,i)
        
        self._doTree(extruders[0],"blackmagic",stream,0,0)
        self._doTree(extruders[0],"experimental",stream,0,0)
        self._doTree(extruders[0],"machine_settings",stream,0,0)
        
        i=0
        for Extrud in list(global_stack.extruders.values()):
            i += 1
            self._doTreeExtrud(Extrud,"machine_settings",stream,0,i)

        # This Method is smarter but unfortunatly settings are not in the same ordrer as the Cura interface
        # for key in global_stack.getAllKeys():
        #     if global_stack.getProperty(key,"enabled") == True:
        #         if global_stack.getProperty(key,"type") == "category":
        #             self._doTree(global_stack,key,stream,0)

        stream.write("</table>")
        stream.write("</body>")
        stream.write("</html>")
        return True

    def _WriteTd(self,stream,Key,ValStr):

        stream.write("<tr>")
        stream.write("<td class='w-50'>" + Key + "</td>")
        stream.write("<td colspan='2'>" + str(ValStr) + "</td>")
        stream.write("</tr>\n")
            
               
    def _doTree(self,stack,key,stream,depth,extrud):   
        #output node
        Info_Extrud=""
        definition_key=key + " label"
        ExtruderStrg = i18n_cura_catalog.i18nc("@label", "Extruder")
        top_of_stack = cast(InstanceContainer, stack.getTop())  # Cache for efficiency.
        changed_setting_keys = top_of_stack.getAllKeys()            

        if stack.getProperty(key,"type") == "category":
            stream.write("<tr class='category'>")
            if extrud>0:
                untranslated_label=stack.getProperty(key,"label")
                translated_label=i18n_catalog.i18nc(definition_key, untranslated_label) 
                Pos = int(stack.getMetaDataEntry("position"))   
                Pos += 1
                Info_Extrud="%s : %d %s"%(ExtruderStrg,Pos,translated_label)
            else:
                untranslated_label=stack.getProperty(key,"label")
                translated_label=i18n_catalog.i18nc(definition_key, untranslated_label)
                Info_Extrud=str(translated_label)
            stream.write("<td colspan='3'>" + str(Info_Extrud) + "</td>")
            #stream.write("<td class=category>" + str(key) + "</td>")
            stream.write("</tr>\n")
        else:
            if stack.getProperty(key,"enabled") == False:
                stream.write("<tr class='disabled'>")
            else:
                if key in changed_setting_keys:
                    stream.write("<tr class='local'>")
                else:
                    stream.write("<tr class='normal'>")
            
            # untranslated_label=stack.getProperty(key,"label").capitalize()
            untranslated_label=stack.getProperty(key,"label")           
            translated_label=i18n_catalog.i18nc(definition_key, untranslated_label)
            
            stream.write("<td class='w-70 pl-"+str(depth)+"'>" + str(translated_label) + "</td>")
            
            GetType=stack.getProperty(key,"type")
            GetVal=stack.getProperty(key,"value")
            
            if str(GetType)=='float':
                # GelValStr="{:.2f}".format(GetVal).replace(".00", "")  # Formatage
                GelValStr="{:.4f}".format(GetVal).rstrip("0").rstrip(".") # Formatage thanks to r_moeller
            else:
                # enum = Option list
                if str(GetType)=='enum':
                    definition_option=key + " option " + str(GetVal)
                    get_option=str(GetVal)
                    GetOption=stack.getProperty(key,"options")
                    GetOptionDetail=GetOption[get_option]
                    GelValStr=i18n_catalog.i18nc(definition_option, GetOptionDetail)
                    # Logger.log("d", "GetType_doTree = %s ; %s ; %s ; %s",definition_option, GelValStr, GetOption, GetOptionDetail)
                else:
                    GelValStr=str(GetVal)
            
            stream.write("<td class='val'>" + GelValStr + "</td>")
            
            stream.write("<td class='w-10'>" + str(stack.getProperty(key,"unit")) + "</td>")
            stream.write("</tr>\n")

            depth += 1

        #look for children
        if len(CuraApplication.getInstance().getGlobalContainerStack().getSettingDefinition(key).children) > 0:
            for i in CuraApplication.getInstance().getGlobalContainerStack().getSettingDefinition(key).children:       
                self._doTree(stack,i.key,stream,depth,extrud)                
    
    def _doTreeExtrud(self,stack,key,stream,depth,extrud):   
        #output node
        Info_Extrud=""
        definition_key=key + " label"
        ExtruderStrg = i18n_cura_catalog.i18nc("@label", "Extruder")
        top_of_stack = cast(InstanceContainer, stack.getTop())  # Cache for efficiency.
        changed_setting_keys = top_of_stack.getAllKeys()
        
        if stack.getProperty(key,"type") == "category":
            if extrud>0:
                untranslated_label=stack.getProperty(key,"label")
                translated_label=i18n_extrud_catalog.i18nc(definition_key, untranslated_label)
                Pos = int(stack.getMetaDataEntry("position"))   
                Pos += 1                
                Info_Extrud="%s : %d %s"%(ExtruderStrg,Pos,translated_label)
            else:
                untranslated_label=stack.getProperty(key,"label")
                translated_label=i18n_extrud_catalog.i18nc(definition_key, untranslated_label)
                Info_Extrud=str(translated_label)
            stream.write("<tr class='category'><td colspan='3'>" + str(Info_Extrud) + "</td>")
            stream.write("</tr>\n")
        else:
            if stack.getProperty(key,"enabled") == False:
                stream.write("<tr class='disabled'>")
            else:
                if key in changed_setting_keys:
                    stream.write("<tr class='local'>")
                else:
                    stream.write("<tr class='normal'>")
            
            # untranslated_label=stack.getProperty(key,"label").capitalize()
            untranslated_label=stack.getProperty(key,"label")           
            translated_label=i18n_extrud_catalog.i18nc(definition_key, untranslated_label)
            
            stream.write("<td class='w-70 pl-"+str(depth)+"'>" + str(translated_label) + "</td>")
            
            GetType=stack.getProperty(key,"type")
            GetVal=stack.getProperty(key,"value")
            if str(GetType)=='float':
                # GelValStr="{:.2f}".format(GetVal).replace(".00", "")  # Formatage
                GelValStr="{:.4f}".format(GetVal).rstrip("0").rstrip(".") # Formatage thanks to r_moeller
            else:
                # enum = Option list
                if str(GetType)=='enum':
                    definition_option=key + " option " + str(GetVal)
                    get_option=str(GetVal)
                    GetOption=stack.getProperty(key,"options")
                    GetOptionDetail=GetOption[get_option]
                    GelValStr=i18n_catalog.i18nc(definition_option, GetOptionDetail)
                    # Logger.log("d", "GetType_doTree = %s ; %s ; %s ; %s",definition_option, GelValStr, GetOption, GetOptionDetail)
                else:
                    GelValStr=str(GetVal)
                
            stream.write("<td class='val'>" + GelValStr + "</td>")
            
            stream.write("<td class='w-10'>" + str(stack.getProperty(key,"unit")) + "</td>")
            stream.write("</tr>\n")

            depth += 1

        #look for children
        if len(stack.getSettingDefinition(key).children) > 0:
            for i in stack.getSettingDefinition(key).children:       
                self._doTreeExtrud(stack,i.key,stream,depth,extrud)
