{% for disk in drbd_disks %}
resource "{{ disk['resource'] }}" {

{% for h in groups['drbd_cluster'] %}
  on {{ hostvars[h]['inventory_hostname_short'] }} {
    device {{ disk['device'] }};
    disk {{ disk['use_partition'] }};
    meta-disk internal;
    address {{ hostvars[h]['ansible_eth0']['ipv4']['address'] }}:7788;
  }
{% endfor %}

}
{% endfor %}
