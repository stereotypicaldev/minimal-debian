# Run as root
if [ $UID -ne 0 ]; then
    exec sudo -s "$0" "$@"
fi

printf "Removing packages...\n"

while read package
do
  printf "Trying to purge package: %s\n" "$package"  # Show which package is being purged
  apt purge --ignore-missing --auto-remove -y "$package"
  
done < "packages.txt"

printf "\nPackages removed successfully!\n"
