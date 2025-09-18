### Specify 7 - Single Sign-On (SSO) Configuration for Feide

Specify 7 supports integration with institutional identity providers using Single Sign-On (SSO). This guide outlines the steps required to configure SSO using Feide, Norway’s federated educational identity provider.

### Benefits of Using Feide for SSO

Integrating Specify 7 with Feide provides the following advantages:

- Reduces the number of required logins for users, enhancing user experience.
- Improves institutional security by utilizing a single set of secure credentials.

### Configuration Steps

1. **Obtain Feide Client Credentials:**  
   An institutional IT administrator must register Specify 7 as an application with Feide to obtain:
   - Client ID
   - Client Secret

2. **Configure Specify 7 Server:**  
   Edit the `specify_settings.py` configuration file on your Specify 7 server to include Feide as an OAuth provider:

```python
OAUTH_LOGIN_PROVIDERS = {
    'feide': {
        'title': "Feide",
        'client_id': "YOUR_FEIDE_CLIENT_ID",
        'client_secret': "YOUR_FEIDE_CLIENT_SECRET",
        'config': "https://auth.dataporten.no",
        'scope': "openid email profile",
    },
}
```
Replace `YOUR_FEIDE_CLIENT_ID` and `YOUR_FEIDE_CLIENT_SECRET` with credentials provided by Feide.

3. **Inviting Users through Specify 7:**  
   Collection administrators can link Feide accounts by generating invitation links for new users:
   - Navigate to the **Security and Accounts** panel in Specify 7.
   - Create a new user account and select the option to generate an invitation link.
   - Share this link with the intended user.

4. **Associating Feide Account with Specify User:**  
   Users clicking the invitation link will be prompted to associate their Feide account with their Specify 7 user profile:
   - Click the invitation link received.
   - Select "Feide" as the login option.
   - Authenticate via Feide when prompted.

5. **User Login Experience:**  
   Once configured, the Specify 7 login screen will display an option for Feide authentication alongside standard username/password login.

### Additional Support

If your institution is using Specify Cloud, contact our support team for assistance with Feide SSO configuration.

