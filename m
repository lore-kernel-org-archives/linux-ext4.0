From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] 285: Fix file syncing
Date: Thu, 30 May 2013 14:45:38 +0200
Message-ID: <1369917939-22660-2-git-send-email-jack@suse.cz>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab3E3Mps (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 May 2013 08:45:48 -0400
In-Reply-To: <1369917939-22660-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The intention of tests 08 and 09 in test generic/285 is to sync the
whole file before checking for data and holes. However the helper is
called with nbytes argument set to 0 which results in not syncing
anything. Set nbytes properly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 src/seek_sanity_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index eec6903..7d5868b 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -229,7 +229,7 @@ static int test09(int fd, int testnum)
 	 * Sync out dirty pages from bufsz * 100, this will convert
 	 * the dirty page to writeback.
 	 */
-	ret = do_sync_dirty_pages(fd, bufsz * 100, 0);
+	ret = do_sync_dirty_pages(fd, bufsz * 100, filsz);
 	if (ret)
 		goto out;
 
@@ -269,7 +269,7 @@ static int test08(int fd, int testnum)
 		goto out;
 
 	/* Sync out all file */
-	ret = do_sync_dirty_pages(fd, 0, 0);
+	ret = do_sync_dirty_pages(fd, 0, filsz);
 	if (ret)
 		goto out;
 
-- 
1.8.1.4

