#!/usr/bin/env bash

set -e

mkdir -p /opt/startup


converted_arch=$(convert_arch "$ARCH")
echo "Converted ARCH: $converted_arch"

echo "==> arch: $converted_arch / ${ARCH}"

cat <<EOF > /opt/startup/160_install_terraform.sh
#!/usr/bin/env bash

# Download, decompress and install
curl --silent --remote-name https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_$converted_arch.zip
unzip terraform_${TERRAFORM_VERSION}_linux_$converted_arch.zip
sudo chown root:root terraform
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_$converted_arch.zip

# Check if everything is correct
terraform version

# Install autocomplete functionality
terraform -install-autocomplete

EOF

chmod +x /opt/startup/160_install_terraform.sh

