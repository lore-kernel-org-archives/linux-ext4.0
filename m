From: Mike Snitzer <snitzer@gmail.com>
Subject: [PATCH] ext4: Remove stale block allocator code
Date: Sat, 10 Jan 2009 15:28:46 -0500
Message-ID: <1231619326-29963-1-git-send-email-snitzer@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:43104 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZAJUgm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Jan 2009 15:36:42 -0500
Received: by yx-out-2324.google.com with SMTP id 8so3206765yxm.1
        for <linux-ext4@vger.kernel.org>; Sat, 10 Jan 2009 12:36:41 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove some leftovers from when the old block allocator was removed
(c2ea3fde).  ext4_sb_info is now a bit lighter.  Also remove a dangling
read_block_bitmap() prototype.

Signed-off-by: Mike Snitzer <snitzer@gmail.com>
---

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c668e43..a519efc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -32,14 +32,6 @@
 #undef EXT4FS_DEBUG
 
 /*
- * Define EXT4_RESERVATION to reserve data blocks for expanding files
- */
-#define EXT4_DEFAULT_RESERVE_BLOCKS	8
-/*max window size: 1024(direct blocks) + 3([t,d]indirect blocks) */
-#define EXT4_MAX_RESERVE_BLOCKS		1027
-#define EXT4_RESERVE_WINDOW_NOT_ALLOCATED 0
-
-/*
  * Debug code
  */
 #ifdef EXT4FS_DEBUG
@@ -53,8 +45,6 @@
 #define ext4_debug(f, a...)	do {} while (0)
 #endif
 
-#define EXT4_MULTIBLOCK_ALLOCATOR	1
-
 /* prefer goal again. length */
 #define EXT4_MB_HINT_MERGE		1
 /* blocks already reserved */
diff --git a/fs/ext4/ext4_i.h b/fs/ext4/ext4_i.h
index e69acc1..2d516c0 100644
--- a/fs/ext4/ext4_i.h
+++ b/fs/ext4/ext4_i.h
@@ -33,9 +33,6 @@ typedef __u32 ext4_lblk_t;
 /* data type for block group number */
 typedef unsigned int ext4_group_t;
 
-#define rsv_start rsv_window._rsv_start
-#define rsv_end rsv_window._rsv_end
-
 /*
  * storage for cached extent
  */
diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
index 039b6ea..e318f48 100644
--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -65,10 +65,6 @@ struct ext4_sb_info {
 	struct blockgroup_lock s_blockgroup_lock;
 	struct proc_dir_entry *s_proc;
 
-	/* root of the per fs reservation window tree */
-	spinlock_t s_rsv_window_lock;
-	struct rb_root s_rsv_window_root;
