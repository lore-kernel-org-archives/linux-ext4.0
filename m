From: Lev Solomonov <solo@primarydata.com>
Subject: [PATCH] debugfs: fix range mode of freei
Date: Wed,  4 Dec 2013 02:14:31 +0200
Message-ID: <1386116071-4592-1-git-send-email-solo@primarydata.com>
Cc: Lev Solomonov <solo@primarydata.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:37963 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3LDAON (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 19:14:13 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so10197403ead.6
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 16:14:12 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit 2ae5d1fdb82b31bf270c4699c59a087c846db2f0 was supposed to teach
'seti' and 'freei' to act on a range of consecutive inodes. apparently
only 'seti' has learned: 'freei' doesn't advance the ino, repeatedly
acting on the same one instead.

Signed-off-by: Lev Solomonov <solo@primarydata.com>
---
 debugfs/debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 8c32eff..cd83ffe 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1042,7 +1042,7 @@ void do_freei(int argc, char *argv[])
 	    !ext2fs_test_inode_bitmap2(current_fs->inode_map,inode))
 		com_err(argv[0], 0, "Warning: inode already clear");
 	while (len-- > 0)
-		ext2fs_unmark_inode_bitmap2(current_fs->inode_map, inode);
+		ext2fs_unmark_inode_bitmap2(current_fs->inode_map, inode++);
 	ext2fs_mark_ib_dirty(current_fs);
 }
 
-- 
1.7.6.5

