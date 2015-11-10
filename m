From: Jan Kara <jack@suse.com>
Subject: [PATCH 5/9] ext4: Document lock ordering
Date: Tue, 10 Nov 2015 20:50:55 +0100
Message-ID: <1447185059-16166-6-git-send-email-jack@suse.com>
References: <1447185059-16166-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	dan.j.williams@intel.com, brian.boylston@hpe.com,
	Jan Kara <jack@suse.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbbKJTvR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Nov 2015 14:51:17 -0500
In-Reply-To: <1447185059-16166-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have enough locks that it's probably worth documenting the lock
ordering rules we have in ext4.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/ext4/super.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6d307dac9622..05a426e0fa1f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -80,6 +80,36 @@ static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
 
+/*
+ * Lock ordering
+ *
+ * Note the difference between i_mmap_sem (EXT4_I(inode)->i_mmap_sem) and
+ * i_mmap_rwsem (inode->i_mmap_rwsem)!
+ *
+ * page fault path:
+ * mmap_sem -> sb_start_pagefault -> i_mmap_sem (r) -> transaction start ->
+ *   page lock -> i_data_sem (rw)
+ *
+ * buffered write path:
+ * sb_start_write -> i_mutex -> mmap_sem
+ * sb_start_write -> i_mutex -> transaction start -> page lock ->
+ *   i_data_sem (rw)
+ *
+ * truncate:
+ * sb_start_write -> i_mutex -> EXT4_STATE_DIOREAD_LOCK (w) -> i_mmap_sem (w) ->
+ *   i_mmap_rwsem (w) -> page lock
+ * sb_start_write -> i_mutex -> EXT4_STATE_DIOREAD_LOCK (w) -> i_mmap_sem (w) ->
+ *   transaction start -> i_data_sem (rw)
+ *
+ * direct IO:
+ * sb_start_write -> i_mutex -> EXT4_STATE_DIOREAD_LOCK (r) -> mmap_sem
+ * sb_start_write -> i_mutex -> EXT4_STATE_DIOREAD_LOCK (r) ->
+ *   transaction start -> i_data_sem (rw)
+ *
+ * writepages:
+ * transaction start -> page lock(s) -> i_data_sem (rw)
+ */
+
 #if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT2)
 static struct file_system_type ext2_fs_type = {
 	.owner		= THIS_MODULE,
-- 
2.1.4

