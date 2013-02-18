From: Eric Sandeen <sandeen@redhat.com>
Subject: Weird resize2fs failures when mounting ext3 as ext4
Date: Mon, 18 Feb 2013 15:41:11 -0600
Message-ID: <51229FF7.7090003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab3BRVlN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2013 16:41:13 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1ILfCua021925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2013 16:41:13 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r1ILfBGN016139
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2013 16:41:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Can't remember how I stumbled on this testcase, but mounting
an ext3 filesystem with "-t ext4" and then resizing leads to trouble.

With -o nodelalloc, the newly added space isn't seen by the allocator
and we get ENOSPC for the extending writes in the script below.

Without -o nodelalloc, the writes worked but I got an umount hang.

Without -t ext4 (but letting ext4.ko handle the ext3 mount) it seems
to work fine.

Haven't looked into it much at all yet but wanted to put it out
there for posterity.

(script requires xfs_io, sorry, could be changed to dd I suppose)

-Eric

#!/bin/bash

# Initial setup to create block devices prior to test:
# /root/fallocate -l 100g fsfile
# losetup /dev/loop0 fsfile
# pvcreate /dev/loop0
# vgcreate VG /dev/loop0

COUNT=20

mkdir -p mnt
umount mnt &>/dev/null
lvremove -f /dev/VG/LV 
lvcreate -L 75G -n LV /dev/VG
mkfs.ext3 -K /dev/VG/LV 
mount -t ext4 -o nodelalloc /dev/VG/LV mnt/

for I in `seq 1 $COUNT`; do mkdir mnt/dir$I; dd if=/dev/zero of=mnt/dir$I/file$I bs=1M count=4096; done
echo "before growing:"
df mnt/

umount mnt
mount -t ext4 -o nodelalloc /dev/VG/LV mnt/

lvextend -L +5g /dev/VG/LV 

echo "growing:"
resize2fs /dev/VG/LV

echo "done growing:"
df mnt/

# This gets ENOSPC for all of them
echo "try extending files:"
for I in `seq 1 $COUNT`; do xfs_io -f -F -c "pwrite -b 60m 4g 120m" mnt/dir$I/file$I; done 
df mnt/

umount mnt

