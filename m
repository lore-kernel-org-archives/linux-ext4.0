From: Andrew Perepechko <anserper@ya.ru>
Subject: [PATCH] ext4: remove an unneeded check in ext4_releasepage
Date: Mon,  2 Jul 2012 22:18:37 +0400
Message-ID: <1341253117-18679-1-git-send-email-anserper@ya.ru>
Cc: Andrew Perepechko <andrew_perepechko@xyratex.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward9.mail.yandex.net ([77.88.61.48]:48191 "EHLO
	forward9.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab2GBSZK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jul 2012 14:25:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andrew Perepechko <andrew_perepechko@xyratex.com>

The page_has_buffers() checks in ext3/4_releasepage are not
needed, since ->releasepage() is only called if
page_has_private() is positive.

Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>
---
 fs/ext3/inode.c |    2 --
 fs/ext4/inode.c |    2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 9a4a5c4..ee5ef30 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1841,8 +1841,6 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
 
 	trace_ext3_releasepage(page);
 	WARN_ON(PageChecked(page));
-	if (!page_has_buffers(page))
-		return 0;
 	return journal_try_to_free_buffers(journal, page, wait);
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 02bc8cb..bfad0a8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2796,8 +2796,6 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
 	trace_ext4_releasepage(page);
 
 	WARN_ON(PageChecked(page));
-	if (!page_has_buffers(page))
-		return 0;
 	if (journal)
 		return jbd2_journal_try_to_free_buffers(journal, page, wait);
 	else
-- 
1.7.9.5

