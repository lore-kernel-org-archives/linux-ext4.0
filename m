From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 2/2] EXT4: fix online resize bug
Date: Thu, 29 May 2008 14:19:41 -0400
Message-ID: <20080529181941.GG23090@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbYE2S2s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2008 14:28:48 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

There is a bug when we are trying to verify that the reserve inode's double
indirect blocks point back to the primary gdt blocks.  The fix is obvious, we
need to mod the gdb count by the addr's per block.  This was verified using the
same testcase as with the ext3 equivalent of this patch.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


Index: linux-2.6/fs/ext4/resize.c
===================================================================
--- linux-2.6.orig/fs/ext4/resize.c
+++ linux-2.6/fs/ext4/resize.c
@@ -563,7 +563,8 @@ static int reserve_backup_gdb(handle_t *
 	}
 
 	blk = EXT4_SB(sb)->s_sbh->b_blocknr + 1 + EXT4_SB(sb)->s_gdb_count;
-	data = (__le32 *)dind->b_data + EXT4_SB(sb)->s_gdb_count;
+	data = (__le32 *)dind->b_data + (EXT4_SB(sb)->s_gdb_count %
+					 EXT4_ADDR_PER_BLOCK(sb));
 	end = (__le32 *)dind->b_data + EXT4_ADDR_PER_BLOCK(sb);
 
 	/* Get each reserved primary GDT block and verify it holds backups */
