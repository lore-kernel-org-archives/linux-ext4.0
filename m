From: Sage Weil <sage@newdream.net>
Subject: [PATCH 11/18] ext4: remove unnecessary dentry_unhash on rmdir/rename_dir
Date: Mon,  9 May 2011 21:43:29 -0700
Message-ID: <1305002616-16782-12-git-send-email-sage@newdream.net>
References: <1305002616-16782-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: viro@ZenIV.linux.org.uk, hch@lst.de, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:57311 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab1EJFKs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 01:10:48 -0400
In-Reply-To: <1305002616-16782-1-git-send-email-sage@newdream.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 has no problems with lingering references to unlinked directory
inodes.

CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Andreas Dilger <adilger.kernel@dilger.ca>
CC: linux-ext4@vger.kernel.org
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ext4/namei.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 792d06e..67fd0b0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2123,8 +2123,6 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	struct ext4_dir_entry_2 *de;
 	handle_t *handle;
 
-	dentry_unhash(dentry);
-
 	/* Initialize quotas before so that eventual writes go in
 	 * separate transaction */
 	dquot_initialize(dir);
@@ -2352,9 +2350,6 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ext4_dir_entry_2 *old_de, *new_de;
 	int retval, force_da_alloc = 0;
 
-	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
-		dentry_unhash(new_dentry);
