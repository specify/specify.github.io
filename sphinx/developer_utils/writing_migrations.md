# Writing Migrations

## Adding a New Table

Before writing the Django migration, you must first modify the following files:

#### datamodel.py
Add your new table and relationships. Follow the capitalization style used in the existing tables closely.  
Each new table increments the `tableId` by 1. Tables exclusive to Specify 7 start at TableID 1000.

Follow how the id field is capitalized by other tables, otherwise it will show up on schema config.

#### models.py
Add class to models.py (`specifyweb\specify\models.py` for most tables, you may put it in a different app if your table fits better there).  
Generally only the first character is capitalized in the class name, but there are some exceptions (probably unintentional). Just keep it consistent with the name you put in models_by_table_id.py later.  

#### types.ts
In: `components/DataModel/types.ts`  
Read the comment to regenerate the schema.  

#### models_by_table_id.py
Add the table name to model_names_by_table_id and model_names_by_app.  
Make sure the capitalization matches what you used on models.py.  
- Note: Attachment tables are identified by having exactly "attachment" at the end, no capital.  

You may now proceed onto generating the migration.  

## Generating New Migrations
Generate the Django migration to create the table (generated from the specification in models.py).  
Run the following command (assuming you're using docker):  
`docker exec specify7-specify7-1 ve/bin/python manage.py makemigrations`

Navigate to the newly created file and add extra operations if you need to.  
Edit the generated migration to allow for reverting if you added any additional functionality.  

Additional functionality includes adding the new table to the schema config, which you probably want.  
To add the new table's fields to the schema config, add something similar to the following:  
```python
MIGRATION_0007_TABLES = [
    ('SpDataSetAttachment', 'An attachment temporarily associated with a Specify Data Set for use in a WorkBench upload.')
]

MIGRATION_0007_FIELDS = {
    'Spdataset': ['spDataSetAttachments']
}

def apply_migration(apps, schema_editor):
    # Update Schema config
    Discipline = apps.get_model('specify', 'Discipline')
    for discipline in Discipline.objects.all(): # New SpDataSetAttachment table
        for table, desc in MIGRATION_0007_TABLES:
            update_table_schema_config_with_defaults(table, discipline.id, desc, apps)
    for discipline in Discipline.objects.all(): # New relationship Spdataset -> SpDataSetAttachment
        for table, fields in MIGRATION_0007_FIELDS.items():
            for field in fields: 
                update_table_field_schema_config_with_defaults(table, discipline.id, field, apps)
```
The following function reverses it:  
```python
def revert_migration(apps, schema_editor):
    # Revert Schema config changes
    for table, _ in MIGRATION_0007_TABLES: # Remove SpDataSetAttachment table
        revert_table_schema_config(table, apps)
    for table, fields in MIGRATION_0007_FIELDS.items(): # Remove relationship Spdataset -> SpDataSetAttachment
            for field in fields: 
                revert_table_field_schema_config(table, field, apps)
```
This is handled by adding these functions to the operations at the bottom of the file  
```python
migrations.RunPython(apply_migration, revert_migration, atomic=True)
```

#### Update datamodel.json
Update datamodel.json.  
Regenerate by going to `http://localhost/context/datamodel.json`  

#### Update tests
These front-end tests may now fail:  
`\specify7\specifyweb\frontend\js_src\lib\components\DataModel\__tests__\resource.test.ts`  

Follow the instructions in the comment to regenerate uniqueFields.json.  
```typescript
/**
 * If this test breaks, uniqueFields.json needs to be regenerated.
 * 1. Go to the dev console on the browser
 * 2. Run the function _getUniqueFields()
 * 3. Paste the text into uniqueFields.json and format with prettier
 */
```

Update front-end test snapshots to fix the rest of the tests:  
`npm run unitTests -- -u`

#### Run tests
Run the front-end tests to make sure everything works.  
`npm t`