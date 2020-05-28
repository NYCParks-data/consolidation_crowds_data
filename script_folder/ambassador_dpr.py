#!/usr/bin/env python
# coding: utf-8

# In[1]:


#Import required libraries
import gspread
import sys
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd
import numpy as np
import urllib
import sqlalchemy
from gspread_dataframe import set_with_dataframe
from gspread_dataframe import get_as_dataframe


# In[2]:


#Import project specific functions
from column_map import column_map
from yesno_functions import *


# In[59]:


#Import shared functions
sys.path.append('../..')
from IPM_Shared_Code_public.Python.google_creds_functions import create_assertion_session
from IPM_Shared_Code_public.Python.utils import get_config
from IPM_Shared_Code_public.Python.delta_functions import *
from IPM_Shared_Code_public.Python.sql_functions import *


# ### Use the config file to setup connections

# In[4]:


config = get_config('c:\Projects\config.ini')

driver = config['srv']['driver']
server = config['srv']['server']
dwh = config['db']['crowdsdb']
cred_file = config['google']['path_to_file']


# In[5]:


con_string = 'Driver={' + driver + '};Server=' + server +';Database=' + dwh + ';Trusted_Connection=Yes;'
params = urllib.parse.quote_plus(con_string)
engine = sqlalchemy.create_engine("mssql+pyodbc:///?odbc_connect=%s" % params)


# ### Execute the function to get the renamed columns for this sheet

# In[6]:


#Call the column map function to get the dictionary to be used for renaming and subsetting the columns
col_rename = column_map('ambassador_dpr')


# In[7]:


#Because of duplicate column names these columns are renamed based on the column index and the keys and 
#values need to be switched
col_rename = {v[0]: k for k, v in col_rename.items()}


# In[8]:


cols = list(col_rename.values())


# ### Read the site reference list from SQL

# In[31]:


sql = 'select * from crowdsdb.dbo.tbl_ref_sites'


# In[32]:


site_ref = pd.read_sql(con = engine, sql = sql)[['site_id', 'site_desc', 'borough']]


# ### Read the current data from SQL

# In[33]:


sql = 'select * from crowdsdb.dbo.tbl_dpr_ambassador'


# In[34]:


ambass_sql = (pd.read_sql(con = engine, sql = sql)
              .drop(columns = ['ambassador_id', 'patroncount'])
              .fillna(value = np.nan, axis = 1))


# In[35]:


sql_cols = list(ambass_sql.columns.values)


# In[36]:


hash_rows(ambass_sql, exclude_cols = ['site_id', 'encounter_timestamp'], hash_name = 'row_hash')


# ### Read the latest data from Google Sheets

# In[37]:


scope = ['https://spreadsheets.google.com/feeds',
         'https://www.googleapis.com/auth/drive']
creds = ServiceAccountCredentials.from_json_keyfile_name(cred_file, scope)
client = gspread.authorize(creds)


# In[38]:


sheet = client.open('_Combined INTERNAL PARKS Ambassador COVID-19 Reporting (Responses)')


# In[39]:


ws = sheet.worksheet('Form Responses 1')


# In[40]:


ambass = (get_as_dataframe(ws, evaluate_formulas = True, header= None)
          #Always remove row 0 with the column headers
          .iloc[1:]
          .rename(columns = col_rename)
          .fillna(value = np.nan, axis = 1))[cols]


# In[41]:


ambass.head()


# In[42]:


yesno = ['sd_pdcontact', 'closed_approach', 'closed_outcome', 'closed_pdcontact']


# In[43]:


yesno_cols(ambass, yesno)


# In[44]:


#Remove rows with no timestamp because these rows have no data
ambass = ambass[ambass['encounter_timestamp'].notnull()]


# In[45]:


ambass = ambass.merge(site_ref, how = 'left', on = ['site_desc', 'borough'])#[sql_cols]


# In[46]:


ambass.head()


# In[50]:


hash_rows(ambass, exclude_cols = ['site_id', 'encounter_timestamp'], hash_name = 'row_hash')


# ### Find the deltas based on the row hashes

# In[51]:


ambass_deltas = (check_deltas(new_df = ambass, old_df = ambass_sql, on = ['encounter_timestamp', 'site_id'], 
                              hash_name = 'row_hash', dml_col = 'dml_verb'))[sql_cols + ['dml_verb']]


# In[52]:


ambass_deltas.head()


# In[54]:


ambass_inserts = ambass_deltas[ambass_deltas['dml_verb'] == 'I'][sql_cols]


# In[ ]:


ambass_inserts.head()


# In[55]:


ambass_inserts.to_sql('tbl_dpr_ambassador', engine, index = False, if_exists = 'append')


# In[56]:


ambass_updates = ambass_deltas[ambass_deltas['dml_verb'] == 'U'][sql_cols]


# In[57]:


ambass_updates.head()


# In[60]:


sql_update(ambass_updates, 'tbl_dpr_ambassador', engine, ['encounter_timestamp', 'site_id'])

