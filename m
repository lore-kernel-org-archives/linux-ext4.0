From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] ext4: Automatically allocate delay allocated blocks on rename
Date: Tue, 24 Feb 2009 00:05:52 -0500
Message-ID: <1235451952-2726-7-git-send-email-tytso@mit.edu>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu>
 <1235451952-2726-2-git-send-email-tytso@mit.edu>
 <1235451952-2726-3-git-send-email-tytso@mit.edu>
 <1235451952-2726-4-git-send-email-tytso@mit.edu>
 <1235451952-2726-5-git-send-email-tytso@mit.edu>
 <1235451952-2726-6-git-send-email-tytso@mit.edu>
Cc: aneesh.kumar@linux.vnet.ibm.com, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40270 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZBXFGE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 00:06:04 -0500
In-Reply-To: <1235451952-2726-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When renaming a file such that a link to another inode is overwritten,
force any delay allocated blocks that to be allocated so that if the
filesystem is mounted with data=ordered, the data blocks will be
pushed out to disk along with the journal commit.  Many application
programs expect this, so we do this to avoid zero length files if the
system crashes unexpectedly.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/namei.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cb15900..a9a7581 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2357,7 +2357,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct inode *old_inode, *new_inode;
 	struct buffer_head *old_bh, *new_bh, *dir_bh;
 	struct ext4_dir_entry_2 *old_de, *new_de;
-	int retval;
+	int retval, force_da_alloc = 0;
 
 	old_bh = new_bh = dir_bh = NULL;
 
@@ -2497,6 +2497,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		ext4_mark_inode_dirty(handle, new_inode);
 		if (!new_inode->i_nlink)
 			ext4_orphan_add(handle, new_inode);
+		force_da_alloc = 1;
 	}
 	retval = 0;
 
@@ -2505,6 +2506,8 @@ end_rename:
 	brelse(old_bh);
 	brelse(new_bh);
 	ext4_journal_stop(handle);
+	if (retval == 0 && force_da_alloc)
+		ext4_alloc_da_blocks(old_inode);
 	return retval;
 }
 
-- 
1.5.6.3

