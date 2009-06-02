From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 12/24] ext4: Automatically allocate delay allocated blocks on rename
Date: Tue,  2 Jun 2009 08:09:24 -0400
Message-ID: <1243944576-20915-12-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
 <1243944576-20915-5-git-send-email-tytso@mit.edu>
 <1243944576-20915-6-git-send-email-tytso@mit.edu>
 <1243944576-20915-7-git-send-email-tytso@mit.edu>
 <1243944576-20915-8-git-send-email-tytso@mit.edu>
 <1243944576-20915-9-git-send-email-tytso@mit.edu>
 <1243944576-20915-10-git-send-email-tytso@mit.edu>
 <1243944576-20915-11-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59288 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbZFBMJs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:48 -0400
In-Reply-To: <1243944576-20915-11-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When renaming a file such that a link to another inode is overwritten,
force any delay allocated blocks that to be allocated so that if the
filesystem is mounted with data=ordered, the data blocks will be
pushed out to disk along with the journal commit.  Many application
programs expect this, so we do this to avoid zero length files if the
system crashes unexpectedly.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 8750c6d5fcbd3342b3d908d157f81d345c5325a7)
---
 fs/ext4/namei.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e2028b3..6a71680 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2314,7 +2314,7 @@ static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 	struct inode * old_inode, * new_inode;
 	struct buffer_head * old_bh, * new_bh, * dir_bh;
 	struct ext4_dir_entry_2 * old_de, * new_de;
-	int retval;
+	int retval, force_da_alloc = 0;
 
 	old_bh = new_bh = dir_bh = NULL;
 
@@ -2452,6 +2452,7 @@ static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 		ext4_mark_inode_dirty(handle, new_inode);
 		if (!new_inode->i_nlink)
 			ext4_orphan_add(handle, new_inode);
+		force_da_alloc = 1;
 	}
 	retval = 0;
 
@@ -2460,6 +2461,8 @@ end_rename:
 	brelse (old_bh);
 	brelse (new_bh);
 	ext4_journal_stop(handle);
+	if (retval == 0 && force_da_alloc)
+		ext4_alloc_da_blocks(old_inode);
 	return retval;
 }
 
-- 
1.6.3.1.1.g75fc.dirty

