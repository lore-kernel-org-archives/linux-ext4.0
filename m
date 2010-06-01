From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 05/40] ext4: fix error handling in migrate
Date: Tue,  1 Jun 2010 08:02:52 -0400
Message-ID: <1275393807-14369-5-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47264 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab0FAMDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:33 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit f39490bcd1691d65dc33689222a12e1fc13dd824 upstream (as of v2.6.33-git11)

Set i_nlink to zero for temporary inode from very beginning.
otherwise we may fail to start new journal handle and this
inode will be unreferenced but with i_nlink == 1
Since we hold inode reference it can not be pruned.

Also add missed journal_start retval check.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/migrate.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 46a4101..8b87bd0 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -503,14 +503,10 @@ int ext4_ext_migrate(struct inode *inode)
 	}
 	i_size_write(tmp_inode, i_size_read(inode));
 	/*
-	 * We don't want the inode to be reclaimed
-	 * if we got interrupted in between. We have
-	 * this tmp inode carrying reference to the
-	 * data blocks of the original file. We set
-	 * the i_nlink to zero at the last stage after
-	 * switching the original file to extent format
+	 * Set the i_nlink to zero so it will be deleted later
+	 * when we drop inode reference.
 	 */
-	tmp_inode->i_nlink = 1;
+	tmp_inode->i_nlink = 0;
 
 	ext4_ext_tree_init(handle, tmp_inode);
 	ext4_orphan_add(handle, tmp_inode);
@@ -537,6 +533,16 @@ int ext4_ext_migrate(struct inode *inode)
 	up_read((&EXT4_I(inode)->i_data_sem));
 
 	handle = ext4_journal_start(inode, 1);
+	if (IS_ERR(handle)) {
+		/*
+		 * It is impossible to update on-disk structures without
+		 * a handle, so just rollback in-core changes and live other
+		 * work to orphan_list_cleanup()
+		 */
+		ext4_orphan_del(NULL, tmp_inode);
+		retval = PTR_ERR(handle);
+		goto out;
+	}
 
 	ei = EXT4_I(inode);
 	i_data = ei->i_data;
@@ -618,15 +624,8 @@ err_out:
 
 	/* Reset the extent details */
 	ext4_ext_tree_init(handle, tmp_inode);
-
-	/*
-	 * Set the i_nlink to zero so that
-	 * generic_drop_inode really deletes the
-	 * inode
-	 */
-	tmp_inode->i_nlink = 0;
