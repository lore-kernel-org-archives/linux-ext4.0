From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH, v5] ext4: ensure fast symlinks are NUL-terminated
Date: Fri, 19 Dec 2008 20:47:15 +0000
Message-ID: <1229719638-6982-8-git-send-email-duaneg@dghda.com>
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
 <1229719638-6982-2-git-send-email-duaneg@dghda.com>
 <1229719638-6982-3-git-send-email-duaneg@dghda.com>
 <1229719638-6982-4-git-send-email-duaneg@dghda.com>
 <1229719638-6982-5-git-send-email-duaneg@dghda.com>
 <1229719638-6982-6-git-send-email-duaneg@dghda.com>
 <1229719638-6982-7-git-send-email-duaneg@dghda.com>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Duane Griffin <duaneg@dghda.com>,
	Theodore Ts'o <tytso@mit.edu>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:35305 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbYLSUrl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2008 15:47:41 -0500
In-Reply-To: <1229719638-6982-7-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: adilger@sun.com
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Changes from v4: fixed off-by-one bug in maximum length, as pointed out by
Andreas Dilger.

 fs/ext4/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ca88060..f940859 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -34,6 +34,7 @@
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
 #include <linux/mpage.h>
+#include <linux/namei.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
 #include "ext4_jbd2.h"
@@ -4200,9 +4201,11 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		inode->i_op = &ext4_dir_inode_operations;
 		inode->i_fop = &ext4_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext4_inode_is_fast_symlink(inode))
+		if (ext4_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext4_fast_symlink_inode_operations;
-		else {
+			nd_terminate_link(ei->i_data, inode->i_size,
+				sizeof(ei->i_data) - 1);
+		} else {
 			inode->i_op = &ext4_symlink_inode_operations;
 			ext4_set_aops(inode);
 		}
-- 
1.6.0.4

