From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Issue cache flush on data partition when converting unwritten extents
Date: Mon, 13 Feb 2012 20:24:13 +0100
Message-ID: <1329161053-31977-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, jmoyer@redhat.com,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab2BMTYT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 14:24:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we convert unwritten extents to normal extents (either after direct IO or
buffered IO), we should make sure we don't expose uninitialized block contents
after crash at least in data=ordered mode. Thus we have to make sure
transaction commit issues a cache flush to filesystem partition before
finishing transaction commit.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.h |    7 +++++++
 fs/ext4/extents.c   |    7 ++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 5802fa1..2901f7f 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -258,6 +258,13 @@ static inline void ext4_update_inode_fsync_trans(handle_t *handle,
 	}
 }
 
+static inline void ext4_mark_trans_data_flush(handle_t *handle)
+{
+	if (ext4_handle_valid(handle) &&
+	    !handle->h_transaction->t_need_data_flush)
+		handle->h_transaction->t_need_data_flush = 1;
+}
+
 /* super.c */
 int ext4_force_commit(struct super_block *sb);
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 74f23c2..fb9535f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3489,6 +3489,8 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 			ext4_update_inode_fsync_trans(handle, inode, 1);
 			err = check_eofblocks_fl(handle, inode, map->m_lblk,
 						 path, map->m_len);
+			if (!err && ext4_should_order_data(inode))
+				ext4_mark_trans_data_flush(handle);
 		} else
 			err = ret;
 		goto out2;
@@ -3516,8 +3518,11 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 
 	/* buffered write, writepage time, convert*/
 	ret = ext4_ext_convert_to_initialized(handle, inode, map, path);
-	if (ret >= 0)
+	if (ret >= 0) {
 		ext4_update_inode_fsync_trans(handle, inode, 1);
+		if (ext4_should_order_data(inode))
+			ext4_mark_trans_data_flush(handle);
+	}
 out:
 	if (ret <= 0) {
 		err = ret;
-- 
1.7.1

