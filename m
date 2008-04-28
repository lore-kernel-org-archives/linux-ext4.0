From: akpm@linux-foundation.org
Subject: - ext3-add-missing-ext3_journal_stop.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:37 -0700
Message-ID: <200804282200.m3SM0b82018722@imap1.linux-foundation.org>
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965608AbYD1WAj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: add missing ext3_journal_stop()
has been removed from the -mm tree.  Its filename was
     ext3-add-missing-ext3_journal_stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: add missing ext3_journal_stop()
From: Akinobu Mita <akinobu.mita@gmail.com>

Add missing ext3_journal_stop() in error handling.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/resize.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ext3/resize.c~ext3-add-missing-ext3_journal_stop fs/ext3/resize.c
--- a/fs/ext3/resize.c~ext3-add-missing-ext3_journal_stop
+++ a/fs/ext3/resize.c
@@ -1049,6 +1049,7 @@ int ext3_group_extend(struct super_block
 		ext3_warning(sb, __FUNCTION__,
 			     "multiple resizers run on filesystem!");
 		unlock_super(sb);
+		ext3_journal_stop(handle);
 		err = -EBUSY;
 		goto exit_put;
 	}
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
idr-create-idr_layer_cache-at-boot-time.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch

