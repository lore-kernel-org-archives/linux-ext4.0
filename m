From: akpm@linux-foundation.org
Subject: - ext3-fix-setup_new_group_blocks-locking.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:40 -0700
Message-ID: <200710190345.l9J3jedL013239@imap1.linux-foundation.org>
To: sandeen@redhat.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966067AbXJSDz3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: fix setup_new_group_blocks locking
has been removed from the -mm tree.  Its filename was
     ext3-fix-setup_new_group_blocks-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3: fix setup_new_group_blocks locking
From: Eric Sandeen <sandeen@redhat.com>

setup_new_group_blocks() manipulates the group descriptor block bh under
the block_bitmap bh's lock.  It shouldn't matter since nobody but resize
should be touching these blocks, but it's worth fixing up.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
C: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/resize.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ext3/resize.c~ext3-fix-setup_new_group_blocks-locking fs/ext3/resize.c
--- a/fs/ext3/resize.c~ext3-fix-setup_new_group_blocks-locking
+++ a/fs/ext3/resize.c
@@ -245,10 +245,10 @@ static int setup_new_group_blocks(struct
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
 		ext3_journal_dirty_metadata(handle, gdb);
 		ext3_set_bit(bit, bh->b_data);
 		brelse(gdb);
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
