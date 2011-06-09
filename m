From: Andreas Dilger <adilger@dilger.ca>
Subject: Updated heuristics for mke2fs on large filesystems
Date: Thu, 9 Jun 2011 17:55:06 -0600
Message-ID: <97674ACD-2827-443F-98C8-A43B39613229@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ext4 List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:9009 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab1FIXzJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jun 2011 19:55:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As discussed previously, there was an interest to solicit input on
changing the default parameters to mke2fs so that it takes newer disks
into account better by default, instead of expecting users to know the
right tunables to pass.

Some of the issues proposed were:

- higher inode ratio (up 1MB for large LUNs)

 With multi-TB drives, and modern media files, the average file size
 in large filesystems is much larger than the default of 16kB/inode.
 The   "unint_bg" feature keeps a high-watermark for inode table usage,
 but errors in the group descriptor checksum with large inode tables
 can cause major slowdowns to e2fsck.  Also, it takes a serious amount
 of time to format the filesystem when zeroing the inode tables, if
 the kernel doesn't support automatic itable zeroing.


- flex_bg aligned to s_raid_stride, with aligned inode tables/bitmaps

 With newer versions of mke2fs, it automatically detects the underlying
 geometry of the device (if available).  This is used to specify the
 s_raid_stride and s_raid_stripe_size values in the superblock, which
 aid in aligning the block/inode bitmaps, for non-flex_bg filesystems.
 For flex_bg filesystems it would make sense to make the flex_bg factor
 equal to the s_raid_stripe_size, so that the block/inode bitmaps can
 be sized/aligned on RAID stripe or SSD erase block boundaries.


- ability to specify journal offset directly

 This is useful for being able to align the journal on RAID boundaries,
 or allocated within an SSD portion of the filesystem, if desired.


- larger journal size

 There is data that indicates having a larger journal size can improve
 IO performance with many concurrent threads.  This needs to be balanced
 against the journal consuming too much RAM on systems that don't have
 much.


- lower reserved space ratio

 Some people feel that reserving 5% of very large filesystems wastes too
 much space, and the reserved space ratio should be capped at some limit
 regardless of how large the filesystem is.



Cheers, Andreas





