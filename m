From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Define s_jnl_backup_type in superblock
Date: Mon,  5 Jul 2010 09:15:49 -0400
Message-ID: <1278335749-9593-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37952 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab0GENPw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jul 2010 09:15:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This has been in use by e2fsprogs for a while; define it to keep the
super block fields in sync.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5d3d768..4c7d472 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -984,7 +984,7 @@ struct ext4_super_block {
 	__le32	s_last_orphan;		/* start of list of inodes to delete */
 	__le32	s_hash_seed[4];		/* HTREE hash seed */
 	__u8	s_def_hash_version;	/* Default hash version to use */
-	__u8	s_reserved_char_pad;
+	__u8	s_jnl_backup_type;
 	__le16  s_desc_size;		/* size of group descriptor */
 /*100*/	__le32	s_default_mount_opts;
 	__le32	s_first_meta_bg;	/* First metablock block group */
@@ -1002,7 +1002,7 @@ struct ext4_super_block {
 	__le64  s_mmp_block;            /* Block for multi-mount protection */
 	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
 	__u8	s_log_groups_per_flex;  /* FLEX_BG group size */
-	__u8	s_reserved_char_pad2;
+	__u8	s_reserved_char_pad;
 	__le16  s_reserved_pad;
 	__le64	s_kbytes_written;	/* nr of lifetime kilobytes written */
 	__le32	s_snapshot_inum;	/* Inode number of active snapshot */
-- 
1.7.0.4

