From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] EXT4: Add missing brelse() in ext4_iget()
Date: Sat, 7 Nov 2009 23:17:32 +0100
Message-ID: <20091107221732.GA16212@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:37760 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZKGWRd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Nov 2009 17:17:33 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT4: Add missing brelse() in ext4_iget()

One of the invalid error paths in ext4_iget() forgot to brelse() the inode
buffer head. Fix that.

Found during code review.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ext4/inode.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.32-rc6-ak/fs/ext4/inode.c
===================================================================
--- linux-2.6.32-rc6-ak.orig/fs/ext4/inode.c
+++ linux-2.6.32-rc6-ak/fs/ext4/inode.c
@@ -4882,6 +4882,7 @@ struct inode *ext4_iget(struct super_blo
 	      (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
 	       EXT4_SB(sb)->s_gdb_count)) ||
 	     (ei->i_file_acl >= ext4_blocks_count(EXT4_SB(sb)->s_es)))) {
+		brelse(bh);
 		ext4_error(sb, __func__,
 			   "bad extended attribute block %llu in inode #%lu",
 			   ei->i_file_acl, inode->i_ino);
