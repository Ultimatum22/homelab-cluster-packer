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

resource r10 {

  protocol A;

  stacked-on-top-of r0 {
    device    /dev/drbd10;
    address   {{ drbd_vip }}:7788;
  }

  on server-dr {
    device    /dev/drbd10;
    disk      /dev/sda1;
    address   192.168.1.221:7788;
    meta-disk internal;
  }
}
