From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 4/5] ext4 : Add missing posix_acl_release() in
 ext4_xattr_set_acl() in error path.
Date: Sun, 24 Apr 2011 17:18:02 -0700
Message-ID: <BANLkTin4PDgtZUHgrPnQbg_0+dN6_Fj_Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Manish Katiyar <manish.katiyar@in.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46898 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab1DYASW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Apr 2011 20:18:22 -0400
Received: by qyk7 with SMTP id 7so507212qyk.19
        for <linux-ext4@vger.kernel.org>; Sun, 24 Apr 2011 17:18:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixes the following.

a) Incase journal transaction allocation fails due to ENOMEM don't
call ext4_std_error() since it will
    remount the fs as readonly and logs the message in kernel log.
b) Call posix_acl_release() incase journal allocation fails in case of
error paths.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/acl.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 21eacd7..0c98710 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -354,7 +354,6 @@ ext4_acl_chmod(struct inode *inode)
 				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
-			ext4_std_error(inode->i_sb, error);
 			goto out;
 		}
 		error = ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, clone);
@@ -450,8 +449,10 @@ ext4_xattr_set_acl(struct dentry *dentry, const
char *name, const void *value,

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
1.7.1

-- 
Thanks -
Manish
