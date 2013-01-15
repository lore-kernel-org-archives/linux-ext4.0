From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] debugfs: fix mknod command so that it updates the block group statistics
Date: Tue, 15 Jan 2013 14:53:44 -0500
Message-ID: <1358279625-3098-1-git-send-email-tytso@mit.edu>
References: <20130115194330.GF17719@thunk.org>
Cc: dvhart@infradead.org, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43573 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab3AOTxw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 14:53:52 -0500
In-Reply-To: <20130115194330.GF17719@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 59860e7..2a1525a 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1747,8 +1747,7 @@ void do_mknod(int argc, char *argv[])
 	}
         if (ext2fs_test_inode_bitmap2(current_fs->inode_map,newfile))
 		com_err(argv[0], 0, "Warning: inode already set");
-	ext2fs_mark_inode_bitmap2(current_fs->inode_map, newfile);
-	ext2fs_mark_ib_dirty(current_fs);
+	ext2fs_inode_alloc_stats2(current_fs, newfile, +1, 0);
 	memset(&inode, 0, sizeof(inode));
 	inode.i_mode = mode;
 	inode.i_atime = inode.i_ctime = inode.i_mtime =
-- 
1.7.12.rc0.22.gcdd159b

