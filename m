From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Subject: [PATCH] ext4: fix possible memory leak in ext4_xattr_set_acl()
Date: Mon,  8 Oct 2012 15:11:12 +0400
Message-ID: <1349694672-16992-1-git-send-email-eugene.shatokhin@rosalab.ru>
Cc: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from collab.rosalab.ru ([217.199.216.181]:56388 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab2JHLWh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2012 07:22:37 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by collab.rosalab.ru (Postfix) with ESMTP id E55F629C2AC
	for <linux-ext4@vger.kernel.org>; Mon,  8 Oct 2012 15:12:54 +0400 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_xattr_set_acl(), if ext4_journal_start() returns an error,
posix_acl_release() will not be called for 'acl' which may result
in a memory leak.

This patch fixes that.

Signed-off-by: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
---
 fs/ext4/acl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index a5c29bb..8535c45 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -410,8 +410,10 @@ ext4_xattr_set_acl(struct dentry *dentry, const char *name, const void *value,
 
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
1.7.10.4

