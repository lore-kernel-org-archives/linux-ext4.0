From: Eric Sandeen <sandeen@redhat.com>
Subject: Journal under-reservation bug on first >2G file
Date: Tue, 30 Sep 2014 16:10:16 -0500
Message-ID: <542B1C38.9010409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbaI3VKP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Sep 2014 17:10:15 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8ULAFNs023872
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2014 17:10:15 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s8ULAE5J009017
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2014 17:10:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey all -

So the following testcase will overrun the 1-credit journal reservation
made during a delalloc write in ext4_da_write_begin(), because we
may cross the 2G threshold, and need to modify both the inode and the
superblock in the same transaction.

I see a few was to fix this:

1) Always set LARGE_FILE on mount if not set.  This will break
   RW compatiblity with very old kernels.  Do we care?
2) Bump the reservation to 2 under the fiddly condition of
   large file not yet set but this write might do it
3) bump the delalloc reservation to 2 just in case, always

I'll be happy to write the patch to fix it, just wondering what
people think the best approach is

Thoughts?
-Eric


#!/bin/bash

# A 400m fs won't get the large_file feature, oddly
# enough, because the resize inode will be < 2G.

truncate --size=400m test.img
mkfs.ext4 -F test.img
# This shouldn't have large_file set, exit if it does for some reason
dumpe2fs -h test.img | grep large_file && exit

mkdir -p mnt
mount -o loop test.img mnt

echo "writing 1 byte at 2147483646" 
dd if=/dev/zero of=mnt/testfile bs=1 seek=2147483646 count=1 conv=notrunc of=mnt/testfile
sync

# This will make sure i_disksize is on disk, and
# that the buffer will be mapped on the next write.
#
# This is critical because ext4_da_should_update_i_disksize()
# checks buffer_mapped():
#
#        if (!buffer_mapped(bh) || (buffer_delay(bh)) || buffer_unwritten(bh))
#                return 0;
#        return 1;

# This tries to update i_disksize, and also requires a superblock
# update for the large_file feature flag, but only has 1 credit
# available on the delalloc write path

echo "writing 1 byte at 2147483647"
dd if=/dev/zero of=mnt/testfile bs=1 seek=2147483647 count=1 conv=notrunc of=mnt/testfile

# Should go boom, but if not, unmount
umount mnt
