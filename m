From: akpm@linux-foundation.org
Subject: - ext4-fix-online-resize-bug.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:50 -0700
Message-ID: <200806122037.m5CKboqg005466@imap1.linux-foundation.org>
To: jbacik@redhat.com, adilger@sun.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756644AbYFLUid (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 16:38:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: fix online resize bug
has been removed from the -mm tree.  Its filename was
     ext4-fix-online-resize-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: fix online resize bug
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

Patches currently in -mm which might be from jbacik@redhat.com are

origin.patch

