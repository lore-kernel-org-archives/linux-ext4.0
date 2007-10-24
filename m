From: Mingming Cao <cmm@us.ibm.com>
Subject: Ext4 patch queue updated(2.6.23-git17)
Date: Tue, 23 Oct 2007 18:03:56 -0700
Message-ID: <1193187836.3888.15.camel@localhost.localdomain>
References: <1189643439.4935.30.camel@localhost.localdomain>
	 <46E95011.7040309@bull.net>
	 <1189717301.3751.11.camel@localhost.localdomain>
	 <1189796613.3841.14.camel@localhost.localdomain>
	 <1190856993.4517.33.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33565 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbXJXBER (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Oct 2007 21:04:17 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9O13v1t001166
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 21:03:57 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9O13voo106790
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 21:03:57 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9O13uQ6028300
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 21:03:56 -0400
In-Reply-To: <1190856993.4517.33.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

http://repo.or.cz/w/ext4-patch-queue.git
This patch queue is against mainline.

Changes: 

Rebase ext4 patch queue after Linus pull patches from ext4 git tree.
Added ext4-Return-after-ext4_error-in-case-of-failures.patch from Aneesh
Added mballoc-compilebench-fix.patch from Aneesh
Reordered series to move some cleanup patches to stable series.


# This series applies on 2.6.24-git17
#

#
# Large blocksize support for ext4
#
ext4_large_blocksize_support.patch
ext4_rec_len_overflow_with_64kblk_fix-v2.patch

large-file-blocktype.patch

#block group varibles ext4_grpnum_t
ext4_grpnum_t.patch
ext4_grpnum_t_int_fix.patch

#large file support
ext4-cleanup.patch
ext4-cleanup-2.patch
ext4-cleanup-3.patch
ext4-cleanup-4.patch
48-bit-i_blocks.patch
large-file.patch
ext2_fix_max_size.patch
ext3_fix_max_size.patch

ext4_sync_group_desciptor_with_e2fsprogs.patch
ext4-Return-after-ext4_error-in-case-of-failures.patch
####################################################
# unstable patches still have outstanding comments from lkml
####################################################
stable-boundary
stable-boundary-undo.patch

# Export jbd stats through procfs
# Fold together:
#    ext4-jbd-stats-through-procfs.patch
#    ext4-jbd-stats-through-procfs_fix.patch
#    ext4-fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
# still have comments from akpm to be addressed
jbd-stats-through-procfs

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

# New delayed allocation patch
delalloc-vfs.patch
delalloc-ext4.patch

ext-truncate-mutex.patch
ext3-4-migrate.patch

###################################################
#mballoc
###################################################
# n.b. in the rc7-mm1 tree as introduce-ext4_find_next_bit.patch
generic-find-next-le-bit
new-extent-function.patch
mballoc-core.patch
mballoc-bug-workaround.patch
ext4_grpnumt-mballoc-fix.patch
mballoc-compilebench-fix.patch

# Large block support for blocksize > pagesize
# Needed for Christoph Lameter's largeblock patchset
# to support large block on system that
# blocksize > pagesize
jbd-blocks-reservation-fix-for-large-blk.patch
jbd2-blocks-reservation-fix-for-large-blk.patch
