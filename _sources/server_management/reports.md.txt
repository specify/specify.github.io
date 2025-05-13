# Hosting Reports

Our team generates a "Hosting Report" with database metrics that will be added to the SCC Vault automatically on the 1st and 15th of every month.

As of 2025-05-13, this is run on the North America report runner EC2 instance.

```bash
HostName ec2-54-163-71-241.compute-1.amazonaws.com
User ubuntu
```

The column headers for the export are:
- **Database**: Name of the database.
- **DatabaseSizeGB**: Size of the database in gigabytes.
- **InstitutionName**: Name of the institution.
- **DisciplineName**: The name of the discipline.- 
- **CollectionName**: Name of the specific collection.
- **NumCollectionObjects**: Total number of CO records in the collection.
- **LatestCollectionObjectCreated**: Date when the last CO was added.
- **MostCommonCataloger**: Name of the cataloger with the most COs in the collection.

To set this configuration up, you need to clone the [github.com/grantfitzsimmons/run_query](https://github.com/grantfitzsimmons/run_query) repository on each server, located in the ~/run_query/ directory. For each, you need to follow the installation instructions to setup the veritual environment, install the requirements, and create an `.env` file. See those instructions in the [README.md](https://github.com/grantfitzsimmons/run_query/blob/main/README.md) in that repository.

