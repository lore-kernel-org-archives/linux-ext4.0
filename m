From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] ext4: fix the deadlock in mpage_da_map_and_submit()
Date: Thu, 13 Oct 2011 16:13:18 +0900
Message-ID: <4E968F8E.5070802@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50397 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1JMHOL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Oct 2011 03:14:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext4_jbd2_file_inode() in mpage_da_map_and_submit() fails due to journal
abort, this function returns to caller without unlocking the page.
It leads to the deadlock, and the patch fixes this issue by calling
mpage_da_submit_io().

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/inode.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 986e238..cd3ccc0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1475,9 +1475,11 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 
 	if (ext4_should_order_data(mpd->inode)) {
 		err = ext4_jbd2_file_inode(handle, mpd->inode);
-		if (err)
+		if (err) {
 			/* This only happens if the journal is aborted */
-			return;
+			mpd->retval = err;
+			goto submit_io;
+		}
 	}
 
 	/*
@@ -2174,11 +2176,12 @@ retry:
 			ret = 0;
 		} else if (ret == MPAGE_DA_EXTENT_TAIL) {
 			/*
-			 * got one extent now try with
-			 * rest of the pages
+			 * Got one extent now try with rest of the pages.
+			 * If mpd.retval is set -EIO, journal is aborted.
+			 * So we don't need to write any more.
 			 */
 			pages_written += mpd.pages_written;
-			ret = 0;
+			ret = mpd.retval;
 			io_done = 1;
 		} else if (wbc->nr_to_write)
 			/*
