From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] use atomic functions to set bh_state
Date: Mon, 09 Jun 2008 15:59:39 -0500
Message-ID: <484D99BB.8070907@redhat.com>
References: <484D95CF.9020801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex.tomas@sun.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbYFIU7n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jun 2008 16:59:43 -0400
In-Reply-To: <484D95CF.9020801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

use the BUFFER_FNS functions (set_buffer_foo) to set buffer
head state atomically, not the nonatomic __set_bit.

Alex, please speak up if you had a good reason for __set_bit() :)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


Index: linux-2.6/fs/ext4/extents.c
===================================================================
--- linux-2.6.orig/fs/ext4/extents.c	2008-06-05 13:44:20.000000000 -0500
+++ linux-2.6/fs/ext4/extents.c	2008-06-09 15:53:11.060045685 -0500
@@ -2616,8 +2616,7 @@ int ext4_ext_get_blocks(handle_t *handle
 				 */
 				if (allocated > max_blocks)
 					allocated = max_blocks;
-				/* mark the buffer unwritten */
-				__set_bit(BH_Unwritten, &bh_result->b_state);
+				set_buffer_unwritten(bh);
 				goto out2;
 			}
 
@@ -2723,7 +2722,7 @@ int ext4_ext_get_blocks(handle_t *handle
 	newblock = ext_pblock(&newex);
 	allocated = ext4_ext_get_actual_len(&newex);
 outnew:
-	__set_bit(BH_New, &bh_result->b_state);
+	set_buffer_new(bh_result);
 
 	/* Cache only when it is _not_ an uninitialized extent */
 	if (create != EXT4_CREATE_UNINITIALIZED_EXT)
@@ -2733,7 +2732,7 @@ out:
 	if (allocated > max_blocks)
 		allocated = max_blocks;
 	ext4_ext_show_leaf(inode, path);
-	__set_bit(BH_Mapped, &bh_result->b_state);
+	set_buffer_mapped(bh_result);
 	bh_result->b_bdev = inode->i_sb->s_bdev;
 	bh_result->b_blocknr = newblock;
 out2:

