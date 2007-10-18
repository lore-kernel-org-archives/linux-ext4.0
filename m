From: akpm@linux-foundation.org
Subject: [patch 129/155] ext3: fix setup_new_group_blocks locking
Date: Thu, 18 Oct 2007 03:06:57 -0700
Message-ID: <200710181006.l9IA6vbX006173@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756591AbXJRKPn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 06:15:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
