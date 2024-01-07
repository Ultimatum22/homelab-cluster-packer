resource {{ drbd_resource_lower }} {

  net {
    protocol C;
  }

{% for h in groups['drbd_cluster'] %}
{% if hostvars[h]['drbd_node'] == 'primary' or hostvars[h]['drbd_node'] =='secondary' %}
  on {{ hostvars[h]['inventory_hostname_short'] }} {
    device {{ hostvars[h]['drbd_disk']['device'] }};
    disk {{ hostvars[h]['drbd_disk']['disk']}}{{ hostvars[h]['drbd_disk']['partitions']}};
    address {{ hostvars[h]['ansible_'+ drbd_iface]['ipv4']['address'] }}:7788;
    meta-disk internal;
  }

{% endif %}
{% endfor %}
}

resource {{ drbd_resource_upper }} {

  net {
    protocol A;
  }

{% for h in groups['drbd_cluster'] %}
{% if hostvars[h]['drbd_node'] == 'backup' %}
  stacked-on-top-of {{ drbd_resource_lower }} {
    device    {{ hostvars[h]['drbd_disk']['device'] }};
    address   {{ drbd_vip }}:7788;
  }

  on {{ hostvars[h]['inventory_hostname_short'] }} {
    device {{ hostvars[h]['drbd_disk']['device'] }};
    disk {{ hostvars[h]['drbd_disk']['disk']}}{{ hostvars[h]['drbd_disk']['partitions']}};
    address {{ hostvars[h]['ansible_'+ drbd_iface]['ipv4']['address'] }}:7788;
    meta-disk internal;
  }

{% endif %}
{% endfor %}
}
