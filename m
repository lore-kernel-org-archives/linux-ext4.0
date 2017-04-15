From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: fix ASAN error when using 128 byte inodes
Date: Sat, 15 Apr 2017 10:36:22 -0400
Message-ID: <20170415143622.11938-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40022 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754315AbdDOOgZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 15 Apr 2017 10:36:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Due to the inode table buffering, it's actually hard to overrun the
end of allocated memory, so the ASAN error doesn't trigger all the
time.

Google-Bug-Id: 37326362

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/pass1.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 99e8f66a..cf2e9ed2 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1822,9 +1822,14 @@ void e2fsck_pass1(e2fsck_t ctx)
 		     inode->i_block[EXT2_DIND_BLOCK] ||
 		     inode->i_block[EXT2_TIND_BLOCK] ||
 		     ext2fs_file_acl_block(fs, inode))) {
+			struct ext2_inode_large *ip;
+
 			inodes_to_process[process_inode_count].ino = ino;
-			inodes_to_process[process_inode_count].inode =
-				       *(struct ext2_inode_large *)inode;
+			ip = &inodes_to_process[process_inode_count].inode;
+			if (inode_size < sizeof(struct ext2_inode_large))
+				memcpy(ip, inode, inode_size);
+			else
+				memcpy(ip, inode, sizeof(*ip));
 			process_inode_count++;
 		} else
 			check_blocks(ctx, &pctx, block_buf);
-- 
2.11.0.rc0.7.gbe5a750
