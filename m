From: akpm@linux-foundation.org
Subject: [patch (for 2.6.26?) 1/1] ext4: fix online resize bug
Date: Mon, 09 Jun 2008 16:49:22 -0700
Message-ID: <200806092349.m59NnMZh015687@imap1.linux-foundation.org>
Cc: cmm@us.ibm.com, akpm@linux-foundation.org, jbacik@redhat.com,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755596AbYFIXup (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jun 2008 19:50:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Josef Bacik <jbacik@redhat.com>

There is a bug when we are trying to verify that the reserve inode's
double indirect blocks point back to the primary gdt blocks.  The fix is
obvious, we need to mod the gdb count by the addr's per block.  This was
verified using the same testcase as with the ext3 equivalent of this
patch.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Acked-by: Andreas Dilger <adilger@sun.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/resize.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ext4/resize.c~ext4-fix-online-resize-bug fs/ext4/resize.c
--- a/fs/ext4/resize.c~ext4-fix-online-resize-bug
+++ a/fs/ext4/resize.c
@@ -563,7 +563,8 @@ static int reserve_backup_gdb(handle_t *
 	}
 
 	blk = EXT4_SB(sb)->s_sbh->b_blocknr + 1 + EXT4_SB(sb)->s_gdb_count;
-	data = (__le32 *)dind->b_data + EXT4_SB(sb)->s_gdb_count;
+	data = (__le32 *)dind->b_data + (EXT4_SB(sb)->s_gdb_count %
+					 EXT4_ADDR_PER_BLOCK(sb));
 	end = (__le32 *)dind->b_data + EXT4_ADDR_PER_BLOCK(sb);
 
 	/* Get each reserved primary GDT block and verify it holds backups */
_
