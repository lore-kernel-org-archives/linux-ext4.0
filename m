From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/31] libext2fs: When writing a file that has a i_size > 2GB,
 set the large_file feature flag and update the superblock.
Date: Mon, 30 Sep 2013 18:27:28 -0700
Message-ID: <20131001012728.28415.89082.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22434 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3JAB1d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:27:33 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If someone tries to write a file that is larger than 2GB, we need to set the
large_file feature flag to affirm that i_size_hi can hold meaningful contents.
(I don't see anything checking large_file except e2fsck...)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/fileio.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 1f7002c..ae5cbf1 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -389,6 +389,18 @@ errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size)
 	old_truncate = ((old_size + file->fs->blocksize - 1) >>
 		      EXT2_BLOCK_SIZE_BITS(file->fs->super)) + 1;
 
+	/* If we're writing a large file, set the large_file flag */
+	if (LINUX_S_ISREG(file->inode.i_mode) &&
+	    EXT2_I_SIZE(&file->inode) > 0x7FFFFFFULL &&
+	    (!EXT2_HAS_RO_COMPAT_FEATURE(file->fs->super,
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE) ||
+	     file->fs->super->s_rev_level == EXT2_GOOD_OLD_REV)) {
+		file->fs->super->s_feature_ro_compat |=
+				EXT2_FEATURE_RO_COMPAT_LARGE_FILE;
+		ext2fs_update_dynamic_rev(file->fs);
+		ext2fs_mark_super_dirty(file->fs);
+	}
+
 	file->inode.i_size = size & 0xffffffff;
 	file->inode.i_size_high = (size >> 32);
 	if (file->ino) {

