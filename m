From: Mingming Cao <cmm@us.ibm.com>
Subject: Ext4 patch queue updated(2.6.23-rc6)
Date: Fri, 14 Sep 2007 12:03:33 -0700
Message-ID: <1189796613.3841.14.camel@localhost.localdomain>
References: <1189643439.4935.30.camel@localhost.localdomain>
	 <46E95011.7040309@bull.net>
	 <1189717301.3751.11.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, tytso@mit.edu
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34395 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXINTDp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Sep 2007 15:03:45 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8EJ3iKi028327
	for <linux-ext4@vger.kernel.org>; Fri, 14 Sep 2007 15:03:45 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8EJ3iH0582186
	for <linux-ext4@vger.kernel.org>; Fri, 14 Sep 2007 15:03:44 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8EJ3iFG004403
	for <linux-ext4@vger.kernel.org>; Fri, 14 Sep 2007 15:03:44 -0400
In-Reply-To: <1189717301.3751.11.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Changes:

Rebase to 2.6.23-rc6
updated jbd_slab_cleanup.patch. (from Mingming)
updated commit messages to different patches in the patch-queue (from
Aneesh.)
Added JBD-blocks-reservation-fix-for-large-blk.patch (part of >4k block
support) (from Mingming)

http://repo.or.cz/w/ext4-patch-queue.git


Ted, could you please update the ext4 git tree with the patches before
the "unstable" mark, so we could get more air time in mm tree for
testing?

Thanks,
Mingming

current patch series

# Rebased the patches to 2.6.23-rc6
jbd_slab_cleanup.patch
sparse-fix.patch

# Add journal checksums
ext4-journal_chksum-2.6.20.patch
ext4-journal-chksum-review-fix.patch

# Add unused inode watermark and checksum to blockgroup descriptors
# Need e2fsprogs changes to mkfs to use this featur
ext4_uninit_blockgroup.patch

# Large blocksize support
#
ext234_enlarge_blocksize.patch
ext2_rec_len_overflow_with_64kblk_fix.patch
ext3_rec_len_overflow_with_64kblk_fix.patch
ext4_rec_len_overflow_with_64kblk_fix.patch
JBD-blocks-reservation-fix-for-large-blk.patch

####################################################
# patches still have outstanding comments from lkml
####################################################

# inode verion patch series
# inode versioning is needed for NFSv4
# Need to address overwrite case and performance concerns
# Need to repost to lkml for comments before submit
#
# vfs changes, 64 bit inode->i_version
64-bit-i_version.patch
# reserve hi 32 bit inode version on ext4 on-disk inode
i_version_hi.patch
# ext4 inode version read/store
ext4_i_version_hi_2.patch
# ext4 inode version update
i_version_update_ext4.patch

# Export jbd stats through procfs
# Shall this move to debugfs?
# Still need to address akpm's comments.
jbd-stats-through-procfs
jbd-stats-through-procfs_fix.patch

####################################################
#Unstable patches
####################################################
# New delayed allocation patch
delalloc-vfs.patch
delalloc-ext4.patch

ext-truncate-mutex.patch
ext3-4-migrate.patch
new-extent-function.patch
###################################################
#mballoc
###################################################
generic-find-next-le-bit
mballoc-core.patch

#########
#FLEX_BG
########
flex_bg_kernel.patch
