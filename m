From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 14/24] ext4: Check for an valid i_mode when reading the inode from disk
Date: Tue,  2 Jun 2009 08:09:26 -0400
Message-ID: <1243944576-20915-14-git-send-email-tytso@mit.edu>
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
 <1243944576-20915-12-git-send-email-tytso@mit.edu>
 <1243944576-20915-13-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59301 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbZFBMJu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:50 -0400
In-Reply-To: <1243944576-20915-13-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 563bdd61fe4dbd6b58cf7eb06f8d8f14479ae1dc)
---
 fs/ext4/inode.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1c79655..a3c3e1e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4129,7 +4129,8 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			inode->i_op = &ext4_symlink_inode_operations;
 			ext4_set_aops(inode);
 		}
-	} else {
+	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+	      S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		inode->i_op = &ext4_special_inode_operations;
 		if (raw_inode->i_block[0])
 			init_special_inode(inode, inode->i_mode,
@@ -4137,6 +4138,13 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		else
 			init_special_inode(inode, inode->i_mode,
 			   new_decode_dev(le32_to_cpu(raw_inode->i_block[1])));
+	} else {
+		brelse(bh);
+		ret = -EIO;
+		ext4_error(inode->i_sb, __func__, 
+			   "bogus i_mode (%o) for inode=%lu",
+			   inode->i_mode, inode->i_ino);
+		goto bad_inode;
 	}
 	brelse (iloc.bh);
 	ext4_set_inode_flags(inode);
-- 
1.6.3.1.1.g75fc.dirty

