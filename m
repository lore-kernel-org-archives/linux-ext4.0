From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext2,ext3,ext4: don't inherit APPEND_FL or IMMUTABLE_FL for new inodes
Date: Sat, 13 Aug 2011 22:28:06 -0400
Message-ID: <1313288886-32689-1-git-send-email-tytso@mit.edu>
References: <20110814020617.GB3524@thunk.org>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46338 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1HNC2L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Aug 2011 22:28:11 -0400
In-Reply-To: <20110814020617.GB3524@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This doesn't make much sense, and it exposes a bug in the kernel where
attempts to create a new file in an append-only directory using
O_CREAT will fail (but still leave a zero-length file).  This was
discovered when xfstests #79 was generalized so it could run on all
file systems.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h          |    3 +--
 include/linux/ext2_fs.h |    4 ++--
 include/linux/ext3_fs.h |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e717dfd..be593d5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -357,8 +357,7 @@ struct flex_groups {
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
-			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
-			   EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
+			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
 			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
 
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 53792bf..ce1b719 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -197,8 +197,8 @@ struct ext2_group_desc
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT2_FL_INHERITED (EXT2_SECRM_FL | EXT2_UNRM_FL | EXT2_COMPR_FL |\
-			   EXT2_SYNC_FL | EXT2_IMMUTABLE_FL | EXT2_APPEND_FL |\
-			   EXT2_NODUMP_FL | EXT2_NOATIME_FL | EXT2_COMPRBLK_FL|\
+			   EXT2_SYNC_FL | EXT2_NODUMP_FL |\
+			   EXT2_NOATIME_FL | EXT2_COMPRBLK_FL |\
 			   EXT2_NOCOMP_FL | EXT2_JOURNAL_DATA_FL |\
 			   EXT2_NOTAIL_FL | EXT2_DIRSYNC_FL)
 
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 67a803a..0244611 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -180,8 +180,8 @@ struct ext3_group_desc
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT3_FL_INHERITED (EXT3_SECRM_FL | EXT3_UNRM_FL | EXT3_COMPR_FL |\
-			   EXT3_SYNC_FL | EXT3_IMMUTABLE_FL | EXT3_APPEND_FL |\
-			   EXT3_NODUMP_FL | EXT3_NOATIME_FL | EXT3_COMPRBLK_FL|\
+			   EXT3_SYNC_FL | EXT3_NODUMP_FL |\
+			   EXT3_NOATIME_FL | EXT3_COMPRBLK_FL |\
 			   EXT3_NOCOMPR_FL | EXT3_JOURNAL_DATA_FL |\
 			   EXT3_NOTAIL_FL | EXT3_DIRSYNC_FL)
 
-- 
1.7.4.1.22.gec8e1.dirty

