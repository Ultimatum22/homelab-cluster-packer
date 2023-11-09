#!/bin/bash





# usernames=("system")

# getent group wheel || groupadd wheel

# for username in "${usernames[@]}"
# do

#     sudo useradd -m -s /bin/bash -r "$username"
#     echo "$username:system" | sudo chpasswd
#     sudo chown -R "$username:$username" "/home/$username"
#     sudo chmod 700 "/home/$username"
#     sudo usermod -aG wheel,docker "$username"

# done

# sudo userdel -r -f pi
