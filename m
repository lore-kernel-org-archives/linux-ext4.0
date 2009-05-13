From: "Don Bowman" <don@sandvine.com>
Subject: RE: ext4 corruption on md [7x1TB in RAID5]
Date: Wed, 13 May 2009 06:32:06 -0400
Message-ID: <EB618291F3454E4DA10D152B9045C01701D2853A@exchange-2.sandvine.com>
References: <EB618291F3454E4DA10D152B9045C01701D2836F@exchange-2.sandvine.com> <20090509185615.GN3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: <linux-ext4@vger.kernel.org>
To: "Andreas Dilger" <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from Mail1.sandvine.com ([64.7.137.134]:19036 "EHLO
	mail2.sandvine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758696AbZEMKcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2009 06:32:08 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20090509185615.GN3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: linux-ext4-owner@vger.kernel.org [mailto:linux-ext4-
> 
> On May 09, 2009  14:36 -0400, Don Bowman wrote:
> > To follow my own email, the results of the 'findsuper' program are:
> >
> > starting at 0, with 512 byte increments
> > byte_offset  byte_start       byte_end   fs_blocks blksz  grp
> last_mount_time           sb_uuid label
> >        1024           0  6001228775424  1465143744  4096    0  Wed
 ...

> >
> > Can this help me somehow?
> 
> These are all showing available backup superblocks and group
> descriptors.
> Pick one of the "grp" numbers and use that as the argument for "-b"
per
> my previous email:  "e2fsck -f -b $((729 * 32768)) -B 4096 /dev/XXX".
> A backup first is still a good idea, however.
> 
> Note that this appears to be a bug that has been hit by several Ubuntu
> users.  I would suggest to upgrade to the latest vanilla kernel (at
> least 2.6.29.stable, search the archives for details), which has fixed
> it for many users.

So i upgraded to 2.26.29 generic.
I than ran e2fsck as above. It ran for ~4 days, and then produced this
after processing ~100% of the inodes:

Error allocating 512 contiguous block(s) in block group 44709 for inode
table: Could not allocate block in ext2 filesystem
Relocating group 44710's block bitmap to 1465057282...
Relocating group 44712's block bitmap to 1465122817...
Relocating group 44712's inode table to 1465132694...
Resize inode (re)creation failed: A block group is missing an inode
table.Abort? yes

e2fsck: aborted

so am i stuck?


