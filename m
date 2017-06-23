From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: return EFSBADCRC if a bad checksum error is found in ext4_find_entry()
Date: Fri, 23 Jun 2017 00:47:16 -0400
Message-ID: <20170623044716.12850-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34816 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751171AbdFWErT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Jun 2017 00:47:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previously a bad directory block with a bad checksum is skipped; we
should be returning EFSBADCRC (aka EBADMSG).

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2a7f2dc7f4dd..13f0cadb1238 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1456,7 +1456,8 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 			EXT4_ERROR_INODE(dir, "checksumming directory "
 					 "block %lu", (unsigned long)block);
 			brelse(bh);
-			goto next;
+			ret = ERR_PTR(-EFSBADCRC);
+			goto cleanup_and_exit;
 		}
 		set_buffer_verified(bh);
 		i = search_dirblock(bh, dir, &fname,
-- 
2.11.0.rc0.7.gbe5a750
