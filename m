From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] ext3: Add replace-on-rename hueristics for data=writeback mode
Date: Fri,  3 Apr 2009 03:01:07 -0400
Message-ID: <1238742067-30814-5-git-send-email-tytso@mit.edu>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu>
 <1238742067-30814-2-git-send-email-tytso@mit.edu>
 <1238742067-30814-3-git-send-email-tytso@mit.edu>
 <1238742067-30814-4-git-send-email-tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: torvalds@linuxfoundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36445 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZDCHBL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2009 03:01:11 -0400
In-Reply-To: <1238742067-30814-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In data=writeback mode, start an asynchronous flush when renaming a
file on top of an already-existing file.  This lowers the probability
of data loss in the case of applications that attempt to replace a
file via using rename().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext3/namei.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 4db4ffa..ab98a66 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2265,7 +2265,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	struct inode * old_inode, * new_inode;
 	struct buffer_head * old_bh, * new_bh, * dir_bh;
 	struct ext3_dir_entry_2 * old_de, * new_de;
-	int retval;
+	int retval, flush_file = 0;
 
 	old_bh = new_bh = dir_bh = NULL;
 
@@ -2401,6 +2401,8 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 		ext3_mark_inode_dirty(handle, new_inode);
 		if (!new_inode->i_nlink)
 			ext3_orphan_add(handle, new_inode);
+		if (ext3_should_writeback_data(new_inode))
+			flush_file = 1;
 	}
 	retval = 0;
 
@@ -2409,6 +2411,8 @@ end_rename:
 	brelse (old_bh);
 	brelse (new_bh);
 	ext3_journal_stop(handle);
+	if (retval == 0 && flush_file)
+		filemap_flush(old_inode->i_mapping);
 	return retval;
 }
 
-- 
1.5.6.3

