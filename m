From: Sage Weil <sage@newdream.net>
Subject: [PATCH 13/18] ext2: remove unnecessary dentry_unhash on rmdir/rename_dir
Date: Mon,  9 May 2011 21:43:31 -0700
Message-ID: <1305002616-16782-14-git-send-email-sage@newdream.net>
References: <1305002616-16782-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: viro@ZenIV.linux.org.uk, hch@lst.de, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:57315 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab1EJFKv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 01:10:51 -0400
In-Reply-To: <1305002616-16782-1-git-send-email-sage@newdream.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2 has no problems with lingering references to unlinked directory
inodes.

CC: Jan Kara <jack@suse.cz>
CC: linux-ext4@vger.kernel.org
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ext2/namei.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 516c31d..ed5c5d4 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -296,8 +296,6 @@ static int ext2_rmdir (struct inode * dir, struct dentry *dentry)
 	struct inode * inode = dentry->d_inode;
 	int err = -ENOTEMPTY;
 
-	dentry_unhash(dentry);
-
 	if (ext2_empty_dir(inode)) {
 		err = ext2_unlink(dir, dentry);
 		if (!err) {
@@ -320,9 +318,6 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	struct ext2_dir_entry_2 * old_de;
 	int err = -ENOENT;
 
-	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
-		dentry_unhash(new_dentry);
