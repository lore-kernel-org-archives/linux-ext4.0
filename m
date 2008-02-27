From: akpm@linux-foundation.org
Subject: - ext4-add-missing-ext4_journal_stop.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:17:14 -0800
Message-ID: <200802272217.m1RMHEcJ000797@imap1.linux-foundation.org>
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759267AbYB0WRe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2008 17:17:34 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: add missing ext4_journal_stop()
has been removed from the -mm tree.  Its filename was
     ext4-add-missing-ext4_journal_stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: add missing ext4_journal_stop()
From: Akinobu Mita <akinobu.mita@gmail.com>

Add missing ext4_journal_stop() in error handling.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/resize.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ext4/resize.c~ext4-add-missing-ext4_journal_stop fs/ext4/resize.c
--- a/fs/ext4/resize.c~ext4-add-missing-ext4_journal_stop
+++ a/fs/ext4/resize.c
@@ -1035,6 +1035,7 @@ int ext4_group_extend(struct super_block
 		ext4_warning(sb, __FUNCTION__,
 			     "multiple resizers run on filesystem!");
 		unlock_super(sb);
+		ext4_journal_stop(handle);
 		err = -EBUSY;
 		goto exit_put;
 	}
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
ext2-improve-ext2_readdir-return-value.patch
ext2-use-ext2_group_first_block_no.patch
ext2-use-ext2_fsblk_t-type.patch
ext3-use-ext3_group_first_block_no.patch
ext3-add-missing-ext3_journal_stop.patch
ext3-use-ext3_get_group_desc.patch
ext3-check-ext3_journal_get_write_access-errors.patch
