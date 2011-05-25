From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 1/3] ext4 : Fix error handling in acl.c if journal start fails
Date: Wed, 25 May 2011 00:18:11 -0700
Message-ID: <4DDCAD33.6080208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:34081 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1EYHSO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 03:18:14 -0400
Received: by pxi16 with SMTP id 16so4851265pxi.4
        for <linux-ext4@vger.kernel.org>; Wed, 25 May 2011 00:18:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

   This patch fixes following issues.

a) Incase journal transaction allocation fails due to ENOMEM
don't call ext4_std_error() since it will remount the fs as readonly
and logs the message in kernel log.

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

-- 
Thanks -
Manish
