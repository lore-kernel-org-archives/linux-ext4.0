From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] - ext4: fix setup_new_group_blocks locking
Date: Mon, 01 Oct 2007 14:25:35 -0500
Message-ID: <470149AF.10107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbXJAT1r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2007 15:27:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

setup_new_group_blocks() manipulates the group descriptor block bh
under the block_bitmap bh's lock.  It shouldn't matter since nobody
but resize should be touching these blocks, but it's worth fixing up.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.23-rc7/fs/ext4/resize.c
===================================================================
--- linux-2.6.23-rc7.orig/fs/ext4/resize.c
+++ linux-2.6.23-rc7/fs/ext4/resize.c
@@ -218,10 +218,10 @@ static int setup_new_group_blocks(struct
 			brelse(gdb);
 			goto exit_bh;
 		}
-		lock_buffer(bh);
-		memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, bh->b_size);
+		lock_buffer(gdb);
+		memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, gdb->b_size);
 		set_buffer_uptodate(gdb);
-		unlock_buffer(bh);
+		unlock_buffer(gdb);
 		ext4_journal_dirty_metadata(handle, gdb);
 		ext4_set_bit(bit, bh->b_data);
 		brelse(gdb);
