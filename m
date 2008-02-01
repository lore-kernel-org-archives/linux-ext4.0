From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] make mballoc history a config option
Date: Fri, 01 Feb 2008 14:22:29 -0600
Message-ID: <47A37F85.1050006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbYBAUWb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Feb 2008 15:22:31 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m11KMU6A026234
	for <linux-ext4@vger.kernel.org>; Fri, 1 Feb 2008 15:22:30 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m11KMUZe006784
	for <linux-ext4@vger.kernel.org>; Fri, 1 Feb 2008 15:22:30 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m11KMTqu026569
	for <linux-ext4@vger.kernel.org>; Fri, 1 Feb 2008 15:22:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mballoc history is likely a great debugging tool, but it seems a
bit heavyweight.  If I make it a config option and turn it off,
things lighten up considerably, from:

220 ext4_mb_free_blocks
188 ext4_mb_seq_groups_show
176 ext4_mb_regular_allocator
164 ext4_mb_init_cache
156 ext4_mb_new_blocks
152 ext4_mb_release_inode_pa
136 ext4_mb_seq_history_show
124 ext4_mb_release_group_pa
124 ext4_mb_init
...

to:

176 ext4_mb_regular_allocator
164 ext4_mb_init_cache
156 ext4_mb_new_blocks
124 ext4_mb_init
112 ext4_mb_free_blocks
...
44 ext4_mb_release_inode_pa
...
16 ext4_mb_release_group_pa

It's a bit shocking how much this matters to the size of
ext4_mb_release_inode_pa etc; I've not yet found the 
reason why.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-git9/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.24-git9.orig/fs/ext4/mballoc.c
+++ linux-2.6.24-git9/fs/ext4/mballoc.c
@@ -367,10 +367,9 @@
 #endif
 
 /*
- * with EXT4_MB_HISTORY mballoc stores last N allocations in memory
- * and you can monitor it in /proc/fs/ext4/<dev>/mb_history
+ * with CONFIG_EXT4DEV_FS_MBHISTORY mballoc stores last N allocations in
+ * memory and you can monitor it in /proc/fs/ext4/<dev>/mb_history
  */
-#define EXT4_MB_HISTORY
 #define EXT4_MB_HISTORY_ALLOC		1	/* allocation */
 #define EXT4_MB_HISTORY_PREALLOC	2	/* preallocated blocks used */
 #define EXT4_MB_HISTORY_DISCARD		4	/* preallocation discarded */
@@ -562,7 +561,7 @@ struct ext4_buddy {
 #define EXT4_MB_BITMAP(e4b)	((e4b)->bd_bitmap)
 #define EXT4_MB_BUDDY(e4b)	((e4b)->bd_buddy)
 
-#ifndef EXT4_MB_HISTORY
+#ifndef CONFIG_EXT4DEV_FS_MBHISTORY
 static inline void ext4_mb_store_history(struct ext4_allocation_context *ac)
 {
 	return;
@@ -2093,7 +2092,7 @@ out:
 	return err;
 }
 
-#ifdef EXT4_MB_HISTORY
+#ifdef CONFIG_EXT4DEV_FS_MBHISTORY
 struct ext4_mb_proc_session {
 	struct ext4_mb_history *history;
 	struct super_block *sb;
Index: linux-2.6.24-rc6-mm1/fs/Kconfig
===================================================================
--- linux-2.6.24-rc6-mm1.orig/fs/Kconfig
+++ linux-2.6.24-rc6-mm1/fs/Kconfig
@@ -202,6 +202,13 @@ config EXT4DEV_FS_SECURITY
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
 
+config EXT4DEV_FS_MBHISTORY
+	bool "Ext4dev mballoc allocator history"
+	help
+	  Enabling this option make it possible to monitor mballoc
+	  allocator history via /proc/fs/ext4/<dev>/mb_history.
+	  Disabling this option will save memory and stack space.
+
 config JBD
 	tristate
 	help
