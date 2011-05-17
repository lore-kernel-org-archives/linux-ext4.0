From: jiayingz@google.com (Jiaying Zhang)
Subject: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()
Date: Tue, 17 May 2011 15:59:26 -0700 (PDT)
Message-ID: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:57060 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab1EQW7a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 18:59:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is a bug in commit c8d46e41 "ext4: Add flag to files with blocks
intentionally past EOF" that if we fallocate a file with FALLOC_FL_KEEP_SIZE
flag and then ftruncate the file to a size larger than the file's i_size,
any allocated but unwritten blocks will be freed but the file size is set
to the size that ftruncate specifies.

Here is a simple test to reproduce the problem:
  1. fallocate a 12k size file with KEEP_SIZE flag
  2. write the first 4k
  3. ftruncate the file to 8k
Then 'ls -l' shows that the i_size of the file becomes 8k but debugfs
shows the file has only the first written block left.

Below is the proposed patch to fix the bug:

ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr().

Change ext4_setattr() to use vmtruncate(inode, attr->ia_size) instead
of ext4_truncate(inode) when it needs to truncate an inode so that
if the inode has EXT4_EOFBLOCKS_FL flag set and we are trying to truncate
to a size larger than the inode's i_size, we will only truncate the blocks
beyond the specified truncate size instead of all of blocks beyond i_size.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3424e82..3bfad57 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5347,8 +5347,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			}
 		}
 		/* ext4_truncate will clear the flag */
-		if ((ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)))
-			ext4_truncate(inode);
+		if ((ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))) {
+			rc = vmtruncate(inode, attr->ia_size);
+			if (rc)
+				goto err_out;
+		}
 	}
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
