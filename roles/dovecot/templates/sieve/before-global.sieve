# Global sieve script executed before for user
require [
  "fileinto",
  "imap4flags",
  "envelope",
  "duplicate",
  "subaddress",
  "mailbox",
  "variables"
];

{% if mail.discard_duplicates %}
# Remove duplicate messages sent from mailing lists
if duplicate :seconds 3600 :header "message-id"
{
  discard;
}
{% endif %}

# Mark emails sent as read
# When using the internal LMTP, these tests are needed:
# 1 - Get from and to,
# 2 - Check if to contains +Sent, and mark the message as read
if envelope :matches "from" "*@{{ network.domain }}" {
  set "from" "${1}";
}
if envelope :matches "to" "*@{{ network.domain }}" {
  set "to" "${1}";
}

# Sent messages: mark the email as read and move it to the sent folder
# Use the first recipient delimiter character.
# Do not stop the processing here, as the sent-check script will also
# check that the email is not stored twice.
if string :is "${from}{{ mail.recipient_delimiter[0] }}Sent" "${to}" {
  setflag "\\Seen";
  fileinto "Sent";
}

# Flag the Homebox email alerts as important and keep them in inbox
# This header is used for backup; we do not stop processing, though.
if header :matches "X-Postmaster-Alert" "*" {
  addflag "$label1";
}
