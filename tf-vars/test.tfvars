#resourcegroup under which storageaccount needs to be created
rgname                              = "rg-storage-test"
location                            = "eastus"
tagsmap = {            
            env                                 = "test"
            Owner                               = "user1"
            Product                             = "blog"            
}

# use these variables to enable encryption on the storageaccount, keyvault with the key should already exist in the same subscription
keyvault                            = "kektest"
keyvaultresourcegroup               = "rg-keyvault-test"
enckeyname = "enckey2"
enckeyversion = "xxxxxxxxxxxxxxxxxxxx"

# name of the lock to be create for sa
salockname = "Lock-SA"

#Variable defining storageaccount names and gen2_filesystem names.
#Allows to create storage accounts without any gen2_filesystem
sa = {   
    "storage1test" = ["st1fs1","st1fs2"]
    "storage2test" = ["st2fs1"]
    "storage3test" = ["st3fs1", "st4fs2", "st3fs3", "st3fs4"]
    "storage4test" = [] 
}

# list of subnets tha can access storage account
subnetidmap  = {  
  "storage1test" = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroup/subnets/subnets/sn1test", "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroup/subnets/subnets/sn2"]
  "storage2test" = ["/subscrptions/00000000-0000-0000-0000-000000000000/resourcegroup/subnets/subnets/subnet1test"]
  "storage3test" = ["/subscrptions/00000000-0000-0000-0000-000000000000/resourcegroup/subnets/subnets/sn1", "/subscrptions/00000000-0000-0000-0000-000000000000/resourcegroup/subnets/subnets/sn2", "/subscrptions/00000000-0000-0000-0000-000000000000/resourcegroup/subnets/subnets/subnet1"]
  "storage4test" = ["/subscrptions/00000000-0000-0000-0000-000000000000/resourcegroup/subnets/subnets/subnet3"]
} 

#Define groups and users that need access on each filesystem
fsacl = {
    "st1fs1" = {                         
                                   grpread = ["group1", "group2" ]
                                   grpwrite = ["group2"]
                                   usrread = ["user1"]
                                   usrwrite = []
                                  
                             }
    "st1fs2"  = { 
                                   grpread = ["groupr", "groupr2", "group1" ]
                                   grpwrite = []
                                   usrread  = ["userr", "userr2"]                                 
                                   usrwrite = ["userw"]

                                }
    "st3fs1"  = { 
                                  grpread = ["groupr"]
                                  grpwrite = ["groupw1" , "groupw2"]
                                  usrread = []
                                  usrwrite = ["userw1","userw2"]

    }

}