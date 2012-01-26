From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4: using PTR_ERR() on the wrong variable in
 ext4_ext_migrate()
Date: Thu, 26 Jan 2012 09:14:06 +0300
Message-ID: <20120126061406.GB15856@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:26253 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2AZGOK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jan 2012 01:14:10 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"inode" is a valid pointer here.  "tmp_inode" was intended.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index e7d6bb0..f39f80f 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -471,7 +471,7 @@ int ext4_ext_migrate(struct inode *inode)
 	tmp_inode = ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
 				   S_IFREG, NULL, goal, owner);
 	if (IS_ERR(tmp_inode)) {
-		retval = PTR_ERR(inode);
+		retval = PTR_ERR(tmp_inode);
 		ext4_journal_stop(handle);
 		return retval;
 	}
