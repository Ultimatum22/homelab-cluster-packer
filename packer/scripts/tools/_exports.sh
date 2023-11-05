export HOST_PUBLIC_IP=$(hostname -I | cut -d " " -f 1)
export HOST_PRIVATE_IP=$(hostname -I | cut -d " " -f 3)