echo !------------------! Rolling back S2CREFDB V$VERSION... !------------------!
VERSION=$1
DATE=${2:-$(date +'%m-%d-%Y')}
if [ -d "backups/$VERSION/ReferralDatabase" ]; then
    if [ -L "backups/$VERSION/ReferralDatabase" ]; then
        # It is a symlink!
        # Symbolic link specific commands go here.
        echo "Cannot rollback from a Symlink, exiting..."
        exit 1
    else
        # It's a directory!
        # Directory command goes here.
        echo !---! switching folders '(Downtime expected)'... !---!
    fi
else
    echo "Could not find restore points for Version $VERSION, exiting..."
    exit 1
fi

shopt -s dotglob
start=$(date +%s%3N)
mv /var/www/referraldb/ReferralDatabase staging/$VERSION
mv backups/$VERSION/ReferralDatabase /var/www/referraldb
end=$(date +%s%3N)
downtime=$(($end - $start))
echo Total downtime is $downtime ms.
echo !---! Cleaning up... !---!
rm -rf staging/$VERSION

echo !------------------! Version $VERSION Rolled Back Successful with $downtime ms downtime! !------------------!
