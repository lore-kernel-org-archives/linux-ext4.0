From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/3] ext4: Try to initialize all groups we can in case of failure on ppc64
Date: Mon,  1 Jun 2015 09:55:00 +0200
Message-ID: <1433145301-14605-2-git-send-email-lczerner@redhat.com>
References: <1433145301-14605-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbbFAHzK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Jun 2015 03:55:10 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id A87A1B82A7
	for <linux-ext4@vger.kernel.org>; Mon,  1 Jun 2015 07:55:10 +0000 (UTC)
In-Reply-To: <1433145301-14605-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently on the machines with page size > block size when initializing
block group buddy cache we initialize it for all the block group bitmaps
in the page. However in the case of read error, checksum error, or if
a single bitmap is in any way corrupted we would fail to initialize all
of the bitmaps. This is problematic because we will not have access to
the other allocation groups even though those might be perfectly fine
and usable.

Fix this by reading all the bitmaps instead of error out on the first
problem and simply skip the bitmaps which were either not read properly,
or are not valid.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8d1e602..5677a03 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -882,10 +882,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
 	/* wait for I/O completion */
 	for (i = 0, group = first_group; i < groups_per_page; i++, group++) {
-		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i])) {
+		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i]))
 			err = -EIO;
-			goto out;
-		}
 	}
 
 	first_block = page->index * blocks_per_page;
@@ -898,6 +896,12 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			/* skip initialized uptodate buddy */
 			continue;
 
+		if (!buffer_verified(bh[group - first_group]))
+			/* Skip faulty bitmaps */
+			continue;
+		else
+			err = 0;
+
 		/*
 		 * data carry information regarding this
 		 * particular group in the format specified
-- 
1.8.3.1

