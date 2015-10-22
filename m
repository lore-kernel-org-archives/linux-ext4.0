From: Jan Kara <jack@suse.com>
Subject: [PATCH 5/9] ext4: Document lock ordering
Date: Thu, 22 Oct 2015 10:15:57 +0200
Message-ID: <1445501761-14528-6-git-send-email-jack@suse.com>
References: <1445501761-14528-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>, Dan Williams <dan.j.williams@intel.com>,
	ross.zwisler@linux.intel.com, willy@linux.intel.com,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825AbbJVIQY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Oct 2015 04:16:24 -0400
In-Reply-To: <1445501761-14528-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have enough locks that it's probably worth documenting the lock
ordering rules we have in ext4.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/ext4/super.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 61fad9e33bb9..152f719a0c62 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -85,6 +85,36 @@ static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
 static int ext4_reserve_clusters(struct ext4_sb_info *, ext4_fsblk_t);
 
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

