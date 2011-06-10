From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] debugfs: fix icheck finding blocks used for xattrs
Date: Fri, 10 Jun 2011 00:02:50 -0600
Message-ID: <1307685770-6099-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63875 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1FJGCw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 02:02:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was an "uninitialized variable" warning, but it turns out to be
a real bug.  Without this change, it is not possible to use "icheck"
to find blocks that are used for the i_file_acl (xattr) block.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 debugfs/icheck.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/debugfs/icheck.c b/debugfs/icheck.c
index 643bc5b..729ac93 100644
--- a/debugfs/icheck.c
+++ b/debugfs/icheck.c
@@ -106,13 +106,15 @@ void do_icheck(int argc, char **argv)
 	}
 
 	while (ino) {
+		blk64_t blk;
+
 		if (!inode.i_links_count)
 			goto next;
 
 		bw.inode = ino;
 
-		if (ext2fs_file_acl_block(&inode)) {
-			blk64_t blk;
+		blk = ext2fs_file_acl_block(&inode);
+		if (blk) {
 			icheck_proc(current_fs, &blk, 0,
 				    0, 0, &bw);
 			if (bw.blocks_left == 0)
-- 
1.7.3.4

