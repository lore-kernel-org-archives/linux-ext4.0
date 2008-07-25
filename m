From: akpm@linux-foundation.org
Subject: [patch 072/283] jbd: unexport journal_update_superblock
Date: Fri, 25 Jul 2008 00:02:04 -0700
Message-ID: <200807250702.m6P724ae028488@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, bunk@kernel.org,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbYGYHCN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 03:02:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Adrian Bunk <bunk@kernel.org>

Remove the unused EXPORT_SYMBOL(journal_update_superblock).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/jbd/journal.c~jbd-unexport-journal_update_superblock fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-unexport-journal_update_superblock
+++ a/fs/jbd/journal.c
@@ -68,7 +68,6 @@ EXPORT_SYMBOL(journal_set_features);
 EXPORT_SYMBOL(journal_create);
 EXPORT_SYMBOL(journal_load);
 EXPORT_SYMBOL(journal_destroy);
-EXPORT_SYMBOL(journal_update_superblock);
 EXPORT_SYMBOL(journal_abort);
 EXPORT_SYMBOL(journal_errno);
 EXPORT_SYMBOL(journal_ack_err);
_
