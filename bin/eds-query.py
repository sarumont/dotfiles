#!/usr/bin/env python
# 
# Description: A Python script for use with the Mutt query_command
# which lets you search your Evolution address book for contacts.
#
# For additional information/help contact Homme Zwaagstra
# (<hrz@geodata.soton.ac.uk>)

import cStringIO
import sqlite3
import sys, os

def die(msg):
    print >> sys.stderr, msg
    sys.exit(1)

# Try and import required but non standard modules
try:
    import vobject
except ImportError:
    die("""The vobject module is required to access vcards.
It can be found at <http://vobject.skyhouseconsulting.com/>""")


# The location of the evolution address book
address_file = '~/.local/share/evolution/addressbook/system/contacts.db'

# The query as a case insensitive string
query = sys.argv[1].lower()

# Could be a simple vcard file...
#vcards = file('~/personal/contacts.vcf', 'r')
# ...but we read the vcards from the evolution address book

#print "Searching contacts for %s..." % query,
contact_count = 0
matches = []

conn = sqlite3.connect(os.path.expanduser(address_file));
try:
    cursor = conn.execute("select vcard from folder_id where full_name like ?", ('%'+query+'%', ))
    vc = cursor.fetchone();
    while vc is not None:
        try:
            vcard = vobject.readOne(vc[0])
            for email in vcard.contents['email']:
                matches.append((email.value, vcard.fn.value))
        except TypeError, KeyError:
            pass
        contact_count += 1
        vc = cursor.fetchone();

finally:
    if conn is not None:
        conn.close()

match_count = len(matches)
if not match_count:
    print " no matches in %d entries" % contact_count
    sys.exit(1)

if match_count > 1:
    plural = 'es'
else:
    plural = ''
    
#print " %d match%s in %d entries" % (match_count, plural, contact_count)
for contact in matches:
    print "%s\t%s" % contact
