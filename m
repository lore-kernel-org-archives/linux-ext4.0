From: akpm@linux-foundation.org
Subject: + ext3-fix-setup_new_group_blocks-locking.patch added to -mm tree
Date: Wed, 17 Oct 2007 16:07:29 -0700
Message-ID: <200710172307.l9HN7TE7012954@imap1.linux-foundation.org>
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759155AbXJQXHn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2007 19:07:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: fix setup_new_group_blocks locking
has been added to the -mm tree.  Its filename is
     ext3-fix-setup_new_group_blocks-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

remove-unused-bh-in-calls-to-ext234_get_group_desc.patch
limit-minixfs-printks-on-corrupted-dir-i_size.patch
ext3-remove-ifdef-config_ext3_index.patch
ext3-lighten-up-resize-transaction-requirements.patch
ext4-remove-ifdef-config_ext4_index.patch
ext3-fix-setup_new_group_blocks-locking.patch
