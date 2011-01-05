From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/6] ext4: reorder ext4_inode_info structure elements to remove unneeded padding
Date: Tue,  4 Jan 2011 20:01:08 -0500
Message-ID: <1294189270-16733-5-git-send-email-tytso@mit.edu>
References: <1294189270-16733-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56643 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab1AEBBQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jan 2011 20:01:16 -0500
In-Reply-To: <1294189270-16733-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

By reordering the elements in the ext4_inode_info structure, we can
reduce the padding needed on an x86_64 system by 16 bytes.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index de937fc..50e3d24 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -763,10 +763,10 @@ struct ext4_inode_info {
 	 * near to their parent directory's inode.
 	 */
 	ext4_group_t	i_block_group;
+	ext4_lblk_t	i_dir_start_lookup;
 	unsigned long	i_state_flags;		/* Dynamic state flags */
 	unsigned long	i_flags;
 
-	ext4_lblk_t		i_dir_start_lookup;
 #ifdef CONFIG_EXT4_FS_XATTR
 	/*
 	 * Extended attributes can be read independently of the main file
@@ -835,7 +835,6 @@ struct ext4_inode_info {
 	/* on-disk additional length */
 	__u16 i_extra_isize;
 
-	spinlock_t i_block_reservation_lock;
 #ifdef CONFIG_QUOTA
 	/* quota space reservation, managed internally by quota code */
 	qsize_t i_reserved_quota;
@@ -844,9 +843,11 @@ struct ext4_inode_info {
 	/* completed IOs that might need unwritten extents handling */
 	struct list_head i_completed_io_list;
 	spinlock_t i_completed_io_lock;
+	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
 	/* current io_end structure for async DIO write*/
 	ext4_io_end_t *cur_aio_dio;
-	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
+
+	spinlock_t i_block_reservation_lock;
 
 	/*
 	 * Transactions that contain inode's metadata needed to complete
-- 
1.7.3.1

