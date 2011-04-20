From: prasanna.panchamukhi@riverbed.com
Subject: [PATCH 4/4] ext3: ensure fast symlinks are NUL-terminated
Date: Tue, 19 Apr 2011 19:07:40 -0700
Message-ID: <1303265260-9210-4-git-send-email-prasanna.panchamukhi@riverbed.com>
References: <1303265260-9210-1-git-send-email-prasanna.panchamukhi@riverbed.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, linux-ext4@vger.kernel.org
To: prasanna.panchamukhi@riverbed.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eng.riverbed.com ([208.70.196.44]:6813 "EHLO smtp2.riverbed.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab1DTCHx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Apr 2011 22:07:53 -0400
In-Reply-To: <1303265260-9210-1-git-send-email-prasanna.panchamukhi@riverbed.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Prasanna S. Panchamukhi <ppanchamukhi@riverbed.com>

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

This patch has been back ported from upstream
commit b5ed3112b5f74c8ec1c7aa03a76c596635e85197.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
BugID: 68873
Signed-off-by: Prasanna S. Panchamukhi <ppanchamukhi@riverbed.com>
---
 fs/ext3/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 67d0af8..d669d78 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -36,6 +36,7 @@
 #include <linux/writeback.h>
 #include <linux/mpage.h>
 #include <linux/uio.h>
+#include <linux/namei.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -2481,9 +2482,11 @@ void ext3_read_inode(struct inode * inode)
 		inode->i_op = &ext3_dir_inode_operations;
 		inode->i_fop = &ext3_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext3_inode_is_fast_symlink(inode))
+		if (ext3_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext3_fast_symlink_inode_operations;
-		else {
+			nd_terminate_link(ei->i_data, inode->i_size,
+						      sizeof(ei->i_data) - 1);
+		} else {
 			inode->i_op = &ext3_symlink_inode_operations;
 			ext3_set_aops(inode);
 		}
-- 
1.7.0.4

