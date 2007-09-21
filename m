From: Mingming Cao <cmm@us.ibm.com>
Subject: Ext4 patch queue updated(2.6.23-rc6)
Date: Thu, 20 Sep 2007 17:39:07 -0700
Message-ID: <1190335147.5288.18.camel@localhost.localdomain>
References: <1189643439.4935.30.camel@localhost.localdomain>
	 <46E95011.7040309@bull.net>
	 <1189717301.3751.11.camel@localhost.localdomain>
	 <1189796613.3841.14.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41326 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbXIUAjI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 20:39:08 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8L0eaDa026526
	for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2007 20:40:36 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8L0d8mc527106
	for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2007 20:39:08 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8L0d75M027698
	for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2007 20:39:08 -0400
In-Reply-To: <1189796613.3841.14.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

http://repo.or.cz/w/ext4-patch-queue.git

Changes since last time

Updated uninit block group patch
Updated mballoc core patch
Update jbd cleanup patch

Removed large block support patch (as the 64k blk size rec_len overflow
patch might be updated later)

reordered serise file

Appreciate any testing!!


Ted,Please review and pull them to your git tree. Thanks

series

# Rebased the patches to 2.6.23-rc6
#
# Note the next two are in mm tree
jbd_slab_cleanup.patch
jbd_GFP_NOFAIL_flag_cleanup.patch

#below are not in mm tree
sparse-fix.patch

# Add unused inode watermark and checksum to blockgroup descriptors
# Need e2fsprogs changes to mkfs to use this featur
ext4_uninit_blockgroup.patch

#FLEX_BG
flex_bg_kernel.patch
####################################################
# unstable patches still have outstanding comments from lkml
####################################################
# Add journal checksums
ext4-journal_chksum-2.6.20.patch
ext4-journal-chksum-review-fix.patch

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
