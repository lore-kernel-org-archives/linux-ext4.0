From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Problem with delayed allocation
Date: Sat, 02 Aug 2008 16:07:19 -0400
Message-ID: <E1KPNNn-0003IN-0B@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:32813 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752997AbYHBUHY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2008 16:07:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Apparently __fsync_super(), which is called right before remounting a
filesystem read-only, isn't working correctly.  To reproduce, create a
script which does this:

#!/bin/sh
DEVICE=/dev/closure/test
mke2fs -t ext4dev /dev/closure/test
mount $DEVICE /mnt
cd /mnt
tar xfj /var/tmp/linux-2.6.26.tar.gz  <----- or some really big file
du -s
cd ..
mount -o remount,ro /mnt
sync
dmesg > /tmp/dmesg.out  <----- note all of the ext4_da_writepages error messages
umount /mnt
du -s /mnt
sync
mount $DEVICE /mnt
du -s /mnt    <---  note that size of the unpacked hierarcy is much smaller

This doesn't happen if the ext4 filesystem is mounted with nodelalloc,
so I assume the problem is in ext4_da_writepages().

Aneesh, can you look at this?  I've tried going through the code paths
starting with __fsync_super(), going down through __sync_single_inode(),
and I can't see anything obvious.

I've checked and we've had this problem for a while.  I don't think this
is a recent regression.  The "sync" command does seem to force file data
out, but it looks like we're not properly waiting for writes to complete
before __fsync_super() returns.  There is a call filemap_fdatawait() in
__sync_single_inode(), but it's apparently not doing the right thing.
Aneesh, can you try to find whatever it is that I missed?  Thanks!!

						- Ted
