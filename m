From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Problem with delayed allocation
Date: Mon, 4 Aug 2008 20:22:49 +0530
Message-ID: <20080804145249.GA9397@skywalker>
References: <E1KPNNn-0003IN-0B@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:41836 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbYHDOxZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 10:53:25 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m74EqZon017766
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 00:52:35 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m74ErMVa301600
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 00:53:22 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m74ErMrf027400
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 00:53:22 +1000
Content-Disposition: inline
In-Reply-To: <E1KPNNn-0003IN-0B@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 02, 2008 at 04:07:19PM -0400, Theodore Ts'o wrote:
> 
> Apparently __fsync_super(), which is called right before remounting a
> filesystem read-only, isn't working correctly.  To reproduce, create a
> script which does this:
> 
> #!/bin/sh
> DEVICE=/dev/closure/test
> mke2fs -t ext4dev /dev/closure/test
> mount $DEVICE /mnt
> cd /mnt
> tar xfj /var/tmp/linux-2.6.26.tar.gz  <----- or some really big file
> du -s
> cd ..
> mount -o remount,ro /mnt
> sync
> dmesg > /tmp/dmesg.out  <----- note all of the ext4_da_writepages error messages
> umount /mnt
> du -s /mnt
> sync
> mount $DEVICE /mnt
> du -s /mnt    <---  note that size of the unpacked hierarcy is much smaller
> 
> This doesn't happen if the ext4 filesystem is mounted with nodelalloc,
> so I assume the problem is in ext4_da_writepages().
> 

Can you try this patch and see if it makes any difference ?

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 25adfc3..5a8a2d3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -518,6 +518,7 @@ void generic_sync_sb_inodes(struct super_block *sb,
 		spin_lock(&inode_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
+			printk(KERN_CRIT "Breaking from the %s loop\n", __func__);
 			break;
 		}
 		if (!list_empty(&sb->s_more_io))
@@ -611,6 +612,8 @@ void sync_inodes_sb(struct super_block *sb, int wait)
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
 			nr_dirty + nr_unstable;
 	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
+	wbc.nr_to_write =  LONG_MAX;
+
 	sync_sb_inodes(sb, &wbc);
 }
 

