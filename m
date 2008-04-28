From: akpm@linux-foundation.org
Subject: [patch 271/307] ext3: add missing ext3_journal_stop()
Date: Mon, 28 Apr 2008 02:16:07 -0700
Message-ID: <200804280916.m3S9G7k0019137@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, akinobu.mita@gmail.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbYD1JUr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:20:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
