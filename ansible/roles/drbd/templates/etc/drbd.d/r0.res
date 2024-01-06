resource {{ drbd_disks[0]['resource'] }} {

  net {
    protocol C;
  }

{% for h in groups['drbd_cluster'] %}
{% if hostvars[h]['drbd_node'] == 'primary' or hostvars[h]['drbd_node'] =='secondary' %}
  on {{ hostvars[h]['inventory_hostname_short'] }} {
    device /dev/drbd0;
    disk {{ drbd_disks[0]['disk']}}{{ drbd_disks[0]['partitions']}};
    address {{ hostvars[h]['ansible_'+ drbd_iface]['ipv4']['address'] }}:7788;
    meta-disk internal;
  }

{% endif %}
{% endfor %}
}

resource {{ drbd_disks[0]['resource'] }}-U {

  net {
    protocol A;
  }

  stacked-on-top-of {{ drbd_disks[0]['resource'] }} {
    device    /dev/drbd10;
    address   {{ drbd_vip }}:7788;
  }

{% for h in groups['drbd_cluster'] %}
{% if hostvars[h]['drbd_node'] == 'backup' %}
  on {{ hostvars[h]['inventory_hostname_short'] }} {
    device /dev/drbd10;
    disk {{ drbd_disks[0]['disk']}}{{ drbd_disks[0]['partitions']}};
    address {{ hostvars[h]['ansible_'+ drbd_iface]['ipv4']['address'] }}:7788;
    meta-disk internal;
  }

{% endif %}
{% endfor %}
}
