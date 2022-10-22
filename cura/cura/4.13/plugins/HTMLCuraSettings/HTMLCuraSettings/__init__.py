# Copyright (c) 2020 5axes
# The HtmlCuraSettings plugin is released under the terms of the AGPLv3 or higher.

from . import HtmlCuraSettings

from UM.Platform import Platform
from UM.i18n import i18nCatalog
catalog = i18nCatalog("cura")

def getMetaData():    
    metaData = {}
    
    metaData["workspace_writer"] = {
        "output": [{
            "extension": "html",
            "description": catalog.i18nc("@item:inlistbox", "Cura Settings Documentation"),
            "mime_type": "text/html",
            "mode": HtmlCuraSettings.HtmlCuraSettings.OutputMode.TextMode
        }]
    }
    return metaData

def register(app):
    return { "workspace_writer": HtmlCuraSettings.HtmlCuraSettings() }
