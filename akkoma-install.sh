# Create a Akkoma user
adduser --system --shell  /bin/false --home /opt/akkoma akkoma

# Set the flavour environment variable to the string you got in Detecting flavour section.
# For example if the flavour is `amd64-musl` the command will be
#     export FLAVOUR="amd64-musl"
export FLAVOUR="amd64"

# Make sure the SHELL variable is set
export SHELL="${SHELL:-/bin/sh}"

# Clone the release build into a temporary directory and unpack it
su akkoma -s $SHELL -lc "
curl 'https://akkoma-updates.s3-website.fr-par.scw.cloud/stable/akkoma-$FLAVOUR.zip' -o /tmp/akkoma.zip
unzip /tmp/akkoma.zip -d /tmp/
"

# Move the release to the home directory and delete temporary files
su akkoma -s $SHELL -lc "
mv /tmp/release/* /opt/akkoma
rmdir /tmp/release
rm /tmp/akkoma.zip
"
# Create uploads directory and set proper permissions (skip if planning to use a remote uploader)
# Note: It does not have to be `/var/lib/akkoma/uploads`, the config generator will ask about the upload directory later

mkdir -p /var/lib/akkoma/uploads
chown -R akkoma /var/lib/akkoma

# Create custom public files directory (custom emojis, frontend bundle overrides, robots.txt, etc.)
# Note: It does not have to be `/var/lib/akkoma/static`, the config generator will ask about the custom public files directory later
mkdir -p /var/lib/akkoma/static
chown -R akkoma /var/lib/akkoma

# Create a config directory
mkdir -p /etc/akkoma
chown -R akkoma /etc/akkoma

# Run the config generator
su akkoma -s $SHELL -lc "./bin/pleroma_ctl instance gen --output /etc/akkoma/config.exs --output-psql /tmp/setup_db.psql"

# Create the postgres database
su postgres -s $SHELL -lc "psql -f /tmp/setup_db.psql"

# Create the database schema
su akkoma -s $SHELL -lc "./bin/pleroma_ctl migrate"

# If you have installed RUM indexes uncommend and run
# su akkoma -s $SHELL -lc "./bin/pleroma_ctl migrate --migrations-path priv/repo/optional_migrations/rum_indexing/"

# Start the instance to verify that everything is working as expected
su akkoma -s $SHELL -lc "./bin/pleroma daemon"

# Wait for about 20 seconds and query the instance endpoint, if it shows your uri, name and email correctly, you are configured correctly
sleep 20 && curl http://localhost:4000/api/v1/instance

# Stop the instance
su akkoma -s $SHELL -lc "./bin/pleroma stop"
