From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix races in ext4_sync_parent()
Date: Tue, 26 Jul 2011 21:13:12 -0400
Message-ID: <1311729192-30598-1-git-send-email-tytso@mit.edu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60759 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab1G0BNQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 21:13:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix problems if fsync() races against a rename of a parent directory
as pointed out by Al Viro in his own inimitable way:

>While we are at it, could somebody please explain what the hell is ext4
>doing in
>static int ext4_sync_parent(struct inode *inode)
>{
>        struct writeback_control wbc;
>        struct dentry *dentry = NULL;
>        int ret = 0;
>
>        while (inode && ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
>                ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
>                dentry = list_entry(inode->i_dentry.next,
>                                    struct dentry, d_alias);
>                if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
>                        break;
>                inode = dentry->d_parent->d_inode;
>                ret = sync_mapping_buffers(inode->i_mapping);
>                ...
>Note that dentry obviously can't be NULL there.  dentry->d_parent is never
>NULL.  And dentry->d_parent would better not be negative, for crying out
>loud!  What's worse, there's no guarantees that dentry->d_parent will
>remain our parent over that sync_mapping_buffers() *and* that inode won't
>just be freed under us (after rename() and memory pressure leading to
>eviction of what used to be our dentry->d_parent)......

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/fsync.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index ce66d2f..5dd17d5 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -129,15 +129,21 @@ static int ext4_sync_parent(struct inode *inode)
 {
 	struct writeback_control wbc;
 	struct dentry *dentry = NULL;
+	struct inode *next;
 	int ret = 0;
 
-	while (inode && ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
+	if (!ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY))
+		return 0;
+	inode = igrab(inode);
+	while (ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
-		dentry = list_entry(inode->i_dentry.next,
-				    struct dentry, d_alias);
-		if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
+		dentry = list_first_entry(&inode->i_dentry,
+					  struct dentry, d_alias);
+		next = igrab(dentry->d_parent->d_inode);
+		if (!next)
 			break;
-		inode = dentry->d_parent->d_inode;
+		iput(inode);
+		inode = next;
 		ret = sync_mapping_buffers(inode->i_mapping);
 		if (ret)
 			break;
@@ -148,6 +154,7 @@ static int ext4_sync_parent(struct inode *inode)
 		if (ret)
 			break;
 	}
+	iput(inode);
 	return ret;
 }
 
-- 
1.7.4.1.22.gec8e1.dirty

