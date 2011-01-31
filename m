From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 4/4] Fix ext4 acl routines to handle transaction allocation failures.
Date: Sun, 30 Jan 2011 17:28:32 -0800
Message-ID: <AANLkTinpVdP3kCK=N+hE1B7NbQNfRXTnUE7kSmnyCHam@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: mkatiyar@gmail.com
To: ext4 <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53134 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab1AaB24 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jan 2011 20:28:56 -0500
Received: by qyj19 with SMTP id 19so2858197qyj.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Jan 2011 17:28:56 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Following patch updates ext4 acl routines to allow failures during
journal transaction allocation.
Also update the error path to frop acl handle in case of failures.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/acl.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index e0270d1..0f7aac2 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -351,10 +351,9 @@ ext4_acl_chmod(struct inode *inode)

 	retry:
 		handle = ext4_journal_start(inode,
-				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+				EXT4_DATA_TRANS_BLOCKS(inode->i_sb), true);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
-			ext4_std_error(inode->i_sb, error);
 			goto out;
 		}
 		error = ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, clone);
@@ -449,9 +448,12 @@ ext4_xattr_set_acl(struct dentry *dentry, const
char *name, const void *value,
 		acl = NULL;

 retry:
-	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	handle = ext4_journal_start(inode,
+			            EXT4_DATA_TRANS_BLOCKS(inode->i_sb), true);
+	if (IS_ERR(handle)) {
+		error = PTR_ERR(handle);
+		goto release_and_out;
+	}
 	error = ext4_set_acl(handle, inode, type, acl);
 	ext4_journal_stop(handle);
 	if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-- 
1.6.0.4


-- 
Thanks -
Manish
