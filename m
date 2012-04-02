From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH v2 2/4] ext4: Convert last user of ext4_mark_super_dirty() to ext4_handle_dirty_super()
Date: Mon,  2 Apr 2012 14:45:37 +0300
Message-ID: <1333367140-28370-3-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab2DBLpP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2012 07:45:15 -0400
In-Reply-To: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

The last user of ext4_mark_super_dirty() in ext4_file_open() is so rare it
can well be modifying the superblock properly by journalling the change.
Change it and get rid of ext4_mark_super_dirty() as it's not needed anymore.

Artem: small amendments.
Artem: tested using xfstests for both journalled and non-journalled ext4.

Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/ext4.h |    6 ------
 fs/ext4/file.c |   14 +++++++++++++-
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ab2594a..aba3749 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2226,12 +2226,6 @@ static inline void ext4_unlock_group(struct super_block *sb,
 	spin_unlock(ext4_group_lock_ptr(sb, group));
 }
 
-static inline void ext4_mark_super_dirty(struct super_block *sb)
-{
-	if (EXT4_SB(sb)->s_journal == NULL)
-		sb->s_dirt =1;
-}
-
 /*
  * Block validity checking
  */
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cb70f18..708b28e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -181,9 +181,21 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		path.dentry = mnt->mnt_root;
 		cp = d_path(&path, buf, sizeof(buf));
 		if (!IS_ERR(cp)) {
+			handle_t *handle;
+			int err;
+
+			handle = ext4_journal_start_sb(sb, 1);
+			if (IS_ERR(handle))
+				return PTR_ERR(handle);
+			err = ext4_journal_get_write_access(handle, sbi->s_sbh);
+			if (err) {
+				ext4_journal_stop(handle);
+				return err;
+			}
 			strlcpy(sbi->s_es->s_last_mounted, cp,
 				sizeof(sbi->s_es->s_last_mounted));
-			ext4_mark_super_dirty(sb);
+			ext4_handle_dirty_super(handle, sb);
+			ext4_journal_stop(handle);
 		}
 	}
 	/*
-- 
1.7.7.6

