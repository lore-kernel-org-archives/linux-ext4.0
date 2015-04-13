From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v2 09/20] ext4 crypto: validate context consistency on lookup
Date: Sun, 12 Apr 2015 23:16:25 -0400
Message-ID: <1428894996-7852-10-git-send-email-tytso@mit.edu>
References: <1428894996-7852-1-git-send-email-tytso@mit.edu>
Cc: mhalcrow@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35614 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbbDMDRN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Apr 2015 23:17:13 -0400
In-Reply-To: <1428894996-7852-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change-Id: Ifb904b2bec9300b178062ee70cbdfd333f03f865
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/namei.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2fb55fd..12d2592 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1418,6 +1418,13 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 			return ERR_PTR(-EIO);
 		}
 	}
+	if (ext4_encrypted_inode(dir) &&
+	    !ext4_is_child_context_consistent_with_parent(dir,
+							  dentry->d_inode)) {
+		printk(KERN_ERR "%s: Security warning: Inconsistent contexts\n",
+		       __func__);
+		return ERR_PTR(-EINVAL);
+	}
 	return d_splice_alias(inode, dentry);
 }
 
-- 
2.3.0

