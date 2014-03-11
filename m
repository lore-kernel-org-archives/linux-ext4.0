From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: fstrim has no effect on a just-mounted filesystem
Date: Tue, 11 Mar 2014 21:39:32 +0000
Message-ID: <20140311213932.GA19176@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbaCKVjg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 17:39:36 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2BLdYn5030956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 17:39:35 -0400
Received: from localhost (vpn1-7-62.ams2.redhat.com [10.36.7.62])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s2BLdXsw007382
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 17:39:33 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Here's a problem I can't work out:

I have a filesystem (in a VM) that I know has at least 100MB of
deleted files on it.  Doing this in a script:

  mount -o discard /dev/sda1 /mnt
  fstrim /mnt

... does nothing.  Also the fstrim is almost instantaneous -- there's
no way it could be scanning the disk.

However, if I start with the same filesystem, mounted with -o discard,
and create and rm large files, while observing the size of the
underlying virtual disk, then discard is obviously working fine.  'rm'
of large files makes the underlying disk shrink.

Any ideas here?

Rich.

kernel: 3.12.5-302.fc20.x86_64
qemu: 1.7.0
virtio-scsi with discard=unmap

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v
