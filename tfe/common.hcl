# Necessary for initial setup when no s3 backend is available
inputs = {
    resource_prefix="tfe-v2"
    default_tags = {
        "global.opco"         = "AGO"
        "global.dcs"          = "cloud_products"
        "global.app"          = "terraform"
        "global.project"      = "000000"
        "global.owner"        = "Oliver Goetz"
        "global.dataclass"    = "Internal"
        "global.cbp"          = "A00000"
        "global.appserviceid" = "8cf39aff1b05c1503b69edf2b24bcb28"
        "ManagedByTerraform"  = "True"
        }

}