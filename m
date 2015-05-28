From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/8] ext4 crypto: enforce crypto policy restrictions on cross-renames
Date: Thu, 28 May 2015 19:47:44 -0400
Message-ID: <1432856867-5710-5-git-send-email-tytso@mit.edu>
References: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>, Chao Yu <chao2.yu@samsung.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35484 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbbE1Xs2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2015 19:48:28 -0400
In-Reply-To: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks to Chao Yu <chao2.yu@samsung.com> for pointing out the need for
this check.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/namei.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1e7d65d..401b099 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3647,6 +3647,15 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	u8 new_file_type;
 	int retval;
 
+	if ((ext4_encrypted_inode(old_dir) ||
+	     ext4_encrypted_inode(new_dir)) &&
+	    (old_dir != new_dir) &&
+	    (!ext4_is_child_context_consistent_with_parent(new_dir,
+							   old.inode) ||
+	     !ext4_is_child_context_consistent_with_parent(old_dir,
+							   new.inode)))
+		return -EPERM;
+
 	dquot_initialize(old.dir);
 	dquot_initialize(new.dir);
 
-- 
2.3.0

