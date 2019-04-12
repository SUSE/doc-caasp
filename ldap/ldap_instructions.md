# LDAP Container
These instructions are meant to set up an OpenLDAP server for the purpose of user authentication for Dex.  The configuration described below ensures that TLS is enforced for all communication.  Note that use of TLS requires communication via hostname and not IP - so the LDAP server must be accessible by its hostname (either through a registered domain, local DNS or by modifying /etc/hosts).  The user can supply their own certificates (including TLS certificate, private key and CA certificate) by bind mounting the containing directory on the host machine to the container.  The user can also access and back up the LDAP database and configuration by bind mounting directories to the host.  These options as well as all of the docker flags are detailed below.  Additional documentation for the container can be found here:  https://github.com/osixia/docker-openldap

## How to start and configure the LDAP Container
1. Start the OpenLDAP Server with the following command. Include the optional bind mounts to map in pre-generated SSL/TLS certs or to access and backup the LDAP database and/or configuration files on the host machine if desired. The OpenLDAP server can take a few minutes to initialize in the default configuration since it must generate its own certificates and matching key.  The status can be checked via `docker logs ldapcontainer`.  The server is ready when you see "slapd starting".

  **Start the OpenLDAP Server**

```
docker run \
--name {container name} \
--hostname {ldap hostname} \
--env LDAP_DOMAIN={ldap domain} \
--env LDAP_TLS_CRT_FILENAME={ldap cert name; default: ldap.crt} \
--env LDAP_TLS_KEY_FILENAME={ldap key name; default: ldap.key} \
--env LDAP_TLS_CA_CRT_FILENAME={ldap ca cert name; default: ca.crt} \
--env LDAP_ADMIN_PASSWORD={admin password} \
--env LDAP_CONFIG_PASSWORD={config password} \
--env LDAP_BACKEND="mdb" \
--env LDAP_TLS="true" \
--env LDAP_TLS_ENFORCE="true" \
--env LDAP_TLS_VERIFY_CLIENT="try" \
--env LDAP_TLS_CIPHER_SUITE="SECURE256:+SECURE128:-VERS-TLS-ALL:+VERS-TLS1.2:-RSA:-DHE-DSS:-CAMELLIA-128-CBC:-CAMELLIA-256-CBC" \
--env LDAP_TLS_PROTOCOL_MIN="1.2" \
--env LDAP_REMOVE_CONFIG_AFTER_SETUP="true" \
-p 636:636 \
--detach \
osixia/openldap:1.2.4
```

  **Optional flags**
  
```
--volume {cert and key location}:/container/service/slapd/assets/certs
--volume {ldap database file dir}:/var/lib/ldap
--volume {ldap config dir}:/etc/ldap/slapd.d
```

2. Test that OpenLDAP server is accessible (for simplicity, the commands below assume LDAP_DOMAIN='ldaptest.com' and LDAP_ADMIN_PASSWORD='password'):
  
  * `ldapsearch -x -H ldaps://ldaptest.com -b dc=ldaptest,dc=com -D "cn=admin,dc=ldaptest,dc=com" -w password`
  
  * The result should look like:
  
  ```
  # extended LDIF
#
# LDAPv3
# base <dc=ldaptest,dc=com> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# ldaptest.com
dn: dc=ldaptest,dc=com
objectClass: top
objectClass: dcObject
objectClass: organization
o: Example Inc.
dc: ldaptest

# admin, ldaptest.com
dn: cn=admin,dc=ldaptest,dc=com
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword:: e1NTSEF9U3k4K2ZjVDZTa0xuSU9JNXJxVUtzM2JKbGR4RnB6aXk=

# search result
search: 3
result: 0 Success

# numResponses: 3
# numEntries: 2
```

  * You can also run the same command through the OpenLDAP container as a sanity check:  `docker exec ldapcontainer ldapsearch -x -H ldaps://ldaptest.com -b dc=ldaptest,dc=com -D "cn=admin,dc=ldaptest,dc=com" -w admin`

3. Add a user to the OpenLDAP Server by creating and LDIF file describing the user and adding to the server (for simplicity, the commands below assume LDAP_DOMAIN='ldaptest.com' and LDAP_ADMIN_PASSWORD='password').
    - Here is an example LDIF file named 'newuser.ldif'
  ```
dn: cn=user,dc=ldaptest,dc=com
changetype: add
objectClass: person
objectClass: inetOrgPerson
cn: user
sn: Surname
givenName: User
mail: user@suse.com
uid: user
userPassword: {SSHA}XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```
    - Use of hashed password is highly recommended.  This can be generated with `slappasswd -h {SSHA} -s plaintextpassword`
    - Add the user with `ldapadd -x -D "cn=admin,dc=ldaptest,dc=com" -w admin -H ldaps://ldaptest.com -f newuser.ldif`

	
### Docker command flag description:
Configuration environment variables are documented here:  https://github.com/osixia/docker-openldap#environment-variables

--name:  Name to keep references simple

--hostname:  For container network.  May only be useful if deploying locally and not with DNS-handled domain

--volume:  Maps a volume containing own certs (TLS cert/key and CA cert)

--env LDAP_DOMAIN:  Domain name used for cert generation if using auto-generated certs

--env LDAP_TLS_{CRT/KEY/CA}_FILENAME:  Specifies the file name of the cert/key files.  This is required if using your own certs/key.

--env LDAP_ADMIN_PASSWORD:  Specifies the LDAP "admin" account password

--env LDAP_CONFIG_PASSWORD:  Specifies the LDAP "config" account password

--env LDAP_BACKEND:  Specifies backing database type.  Default is mdb.

--env LDAP_TLS:  enables TLS

--env LDAP_TLS_ENFORCE:  Makes TLS required

--env LDAP_TLS_VERIFY_CLIENT:  This directive specifies what checks to perform on client certificates in an incoming TLS session.

--env LDAP_TLS_CIPHER_SUITE:  Enables TLS ciphers.  The example list at left is recommended.

--env LDAP_TLS_PROTOCOL_MIN:  Specifies the TLS protocol.  TLSv1.2 is recommended.

--env LDAP_REMOVE_CONFIG_AFTER_SETUP: Choose whether to remove config folder in the container after setup.  Default is true.

-p 636:636:  By mapping only port 636, we add additional enforcement of TLS in LDAP communication.


--volume {cert and key location}:/container/service/slapd/assets/certs:  This flag maps a user's pre-existing LDAP cert, key and CA cert into the container.  If this is not specified, the container will auto-generate these files.

 --volume {ldap database file dir}:/var/lib/ldap:  This flag maps the host dir to the container's LDAP database file location.  This is helpful to keep a persistent database after the container is stopped.
 
--volume {ldap config dir}:/etc/ldap/slapd.d:  This flag maps the host dir to the container's LDAP config file(s) location.  This is helpful to keep a persistent config after the container is stopped.
