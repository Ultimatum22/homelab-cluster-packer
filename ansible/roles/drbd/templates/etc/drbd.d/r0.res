resource r0 {

  syncer {
    rate 100M;
    al-extents 257;
  }

{% for h in groups['drbd_cluster'] %}
{% if hostvars[h]['drbd_node'] == 'primary' or hostvars[h]['drbd_node'] =='secondary' %}
  on {{ hostvars[h]['inventory_hostname_short'] }} {
    device /dev/drbd0;
    disk /dev/sda1;
    address {{ hostvars[h]['ansible_eth0']['ipv4']['address'] }}:7788;
    meta-disk internal;
  }

{% endif %}
{% endfor %}
}

resource r10 {

  protocol A;

  stacked-on-top-of r0 {
    device    /dev/drbd10;
    address   {{ drbd_vip }}:7788;
  }

{% for h in groups['drbd_cluster'] %}
{% if hostvars[h]['drbd_node'] == 'backup' %}
  on {{ hostvars[h]['inventory_hostname_short'] }} {
    device /dev/drbd10;
    disk /dev/sda1;
    address {{ hostvars[h]['ansible_eth0']['ipv4']['address'] }}:7788;
    meta-disk internal;
  }

{% endif %}
{% endfor %}
}
