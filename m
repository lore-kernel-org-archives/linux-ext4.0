From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/11] ext4: Let S_DAX set only if DAX is really supported
Date: Tue,  8 Nov 2016 12:08:08 +0100
Message-ID: <1478603297-11793-3-git-send-email-jack@suse.cz>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752633AbcKHLKE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Nov 2016 06:10:04 -0500
In-Reply-To: <1478603297-11793-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we have S_DAX set inode->i_flags for a regular file whenever
ext4 is mounted with dax mount option. However in some cases we cannot
really do DAX - e.g. when inode is marked to use data journalling, when
inode data is being encrypted, or when inode is stored inline. Make sure
S_DAX flag is appropriately set/cleared in these cases.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inline.c | 10 ++++++++++
 fs/ext4/inode.c  |  9 ++++++++-
 fs/ext4/super.c  |  5 +++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index f74d5ee2cdec..c29678965c3c 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -299,6 +299,11 @@ static int ext4_create_inline_data(handle_t *handle,
 	EXT4_I(inode)->i_inline_size = len + EXT4_MIN_INLINE_DATA_SIZE;
 	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
 	ext4_set_inode_flag(inode, EXT4_INODE_INLINE_DATA);
+	/*
+	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
+	 * get cleared
+	 */
+	ext4_set_inode_flags(inode);
 	get_bh(is.iloc.bh);
 	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
 
@@ -442,6 +447,11 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
 		}
 	}
 	ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
+	/*
+	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
+	 * get set.
+	 */
+	ext4_set_inode_flags(inode);
 
 	get_bh(is.iloc.bh);
 	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3d58b2b477e8..5337828c68a7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4355,7 +4355,9 @@ void ext4_set_inode_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
 		new_fl |= S_DIRSYNC;
-	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode))
+	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode) &&
+	    !ext4_should_journal_data(inode) && !ext4_has_inline_data(inode) &&
+	    !ext4_encrypted_inode(inode))
 		new_fl |= S_DAX;
 	inode_set_flags(inode, new_fl,
 			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
@@ -5623,6 +5625,11 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	}
 	ext4_set_aops(inode);
+	/*
+	 * Update inode->i_flags after EXT4_INODE_JOURNAL_DATA was updated.
+	 * E.g. S_DAX may get cleared / set.
+	 */
+	ext4_set_inode_flags(inode);
 
 	jbd2_journal_unlock_updates(journal);
 	percpu_up_write(&sbi->s_journal_flag_rwsem);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 20da99da0a34..b3108e6fa5f3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1126,6 +1126,10 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
 			ext4_clear_inode_state(inode,
 					EXT4_STATE_MAY_INLINE_DATA);
+			/*
+			 * Update inode->i_flags - e.g. S_DAX may get disabled
+			 */
+			ext4_set_inode_flags(inode);
 		}
 		return res;
 	}
@@ -1140,6 +1144,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 			len, 0);
 	if (!res) {
 		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
+		/* Update inode->i_flags - e.g. S_DAX may get disabled */
 		res = ext4_mark_inode_dirty(handle, inode);
 		if (res)
 			EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
-- 
2.6.6

