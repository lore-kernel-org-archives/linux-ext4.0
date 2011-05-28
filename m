From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH v2 1/3] ext4: Fix missing acl release in error path in acl.c
Date: Fri, 27 May 2011 23:16:56 -0700
Message-ID: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
Cc: Manish Katiyar <mkatiyar@gmail.com>
To: tytso@mit.edu, jack@suse.cz, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61821 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab1E1GRa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 May 2011 02:17:30 -0400
Received: by pvg12 with SMTP id 12so1038444pvg.19
        for <linux-ext4@vger.kernel.org>; Fri, 27 May 2011 23:17:29 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

a) Incase journal transaction allocation
fails due to ENOMEM don't call ext4_std_error() since it will remount
the fs as readonly and logs the message in kernel log.

b) Call posix_acl_release() incase journal allocation fails in case
of error paths.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/acl.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 21eacd7..93dc9a6 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -354,7 +354,8 @@ ext4_acl_chmod(struct inode *inode)
 				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
-			ext4_std_error(inode->i_sb, error);
+			if (error != -ENOMEM)
+				ext4_std_error(inode->i_sb, error);
 			goto out;
 		}
 		error = ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, clone);
@@ -450,8 +451,10 @@ ext4_xattr_set_acl(struct dentry *dentry, const char *name, const void *value,
 
 retry:
 	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		error = PTR_ERR(handle);
+		goto release_and_out;
+	}
 	error = ext4_set_acl(handle, inode, type, acl);
 	ext4_journal_stop(handle);
 	if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-- 
1.7.4.1

