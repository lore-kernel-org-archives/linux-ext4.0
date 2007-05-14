From: Andreas Dilger <adilger@clusterfs.com>
Subject: [PATCH] sanity check inode size vs inode ratio
Date: Mon, 14 May 2007 17:03:11 -0600
Message-ID: <20070514230311.GA5568@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:57988 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbXENXDO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2007 19:03:14 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

A quick patch to sanity check the inode ratio vs the inode size.  In some
cases Lustre users have tried specifying an inode size of 4096 bytes, while
keeping an inode ratio of one inode per 4096 bytes, causing mke2fs to spin
forever trying to allocate the inode tables.  I'm sure more people will do
this now that large inodes are available in ext4 and documented in e2fsprogs.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

======================== e2fsprogs-inode_ratio.patch ========================
--- misc/mke2fs.c	2007-05-01 05:52:35.000000000 -0600
+++ misc/mke2fs.c.sav	2007-05-14 16:53:10.000000000 -0600
@@ -1504,6 +1504,18 @@
 		((__u64) fs_param.s_blocks_count * blocksize)
 			/ inode_ratio;
 
+	if ((long long)fs_param.s_inodes_count *
+	    inode_size ?: EXT2_GOOD_OLD_INODE_SIZE >
+	    (long long)fs_param.s_blocks_count * EXT2_BLOCK_SIZE(&fs_param)) {
+		com_err(program_name, 0, _("inode_size %u * inodes_count %u "
+					  "too bit for filesystem size %lu,\n"
+					  "\tspecify higher inode_ratio (-i) "
+					  "or lower inode count (-N)\n"),
+			inode_size ?: EXT2_GOOD_OLD_INODE_SIZE,
+			fs_param.s_inodes_count, fs_param.s_blocks_count);
+		exit(1);
+	}
+
 	/*
 	 * Calculate number of blocks to reserve
 	 */
======================== e2fsprogs-inode_ratio.patch ========================
Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
