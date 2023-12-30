resource r0 {

  syncer {
    rate 100M;
    al-extents 257;
  }

  on arawn {
    device    /dev/drbd0;
    disk      /dev/sda1;
    address   192.168.2.223:7788;
    meta-disk internal;
  }

  on danu {
    device    /dev/drbd0;
    disk      /dev/sda1;
    address   192.168.2.222:7788;
    meta-disk internal;
  }
}
