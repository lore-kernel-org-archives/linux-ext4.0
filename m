From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4: unneeded variable in ext4_try_add_inline_entry()
Date: Wed, 5 Dec 2012 11:08:37 +0300
Message-ID: <20121205080836.GA10259@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22293 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2LEIIs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2012 03:08:48 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We never actually use "backup_buf" so I have removed it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 1fe0cc4..26e4218 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1224,7 +1224,7 @@ int ext4_try_add_inline_entry(handle_t *handle, struct dentry *dentry,
 			      struct inode *inode)
 {
 	int ret, inline_size;
-	void *inline_start, *backup_buf = NULL;
+	void *inline_start;
 	struct ext4_iloc iloc;
 	struct inode *dir = dentry->d_parent->d_inode;
 
@@ -1276,7 +1276,6 @@ int ext4_try_add_inline_entry(handle_t *handle, struct dentry *dentry,
 	ret = ext4_convert_inline_data_nolock(handle, dir, &iloc);
 
 out:
-	kfree(backup_buf);
 	ext4_mark_inode_dirty(handle, dir);
 	up_write(&EXT4_I(dir)->xattr_sem);
 	brelse(iloc.bh);
