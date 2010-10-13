From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] jbd: Check return value of __getblk()
Date: Wed, 13 Oct 2010 17:17:18 +0900
Message-ID: <1286957838-5579-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36991 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab0JMIR0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Oct 2010 04:17:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fail journal creation if __getblk() returns NULL.  unlikely() is
added because it is called in a loop and we've been OK without
the check until now.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/journal.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 7fee247..3290fe9 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -950,6 +950,8 @@ int journal_create(journal_t *journal)
 		if (err)
 			return err;
 		bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+		if (unlikely(!bh))
+			return -ENOMEM;
 		lock_buffer(bh);
 		memset (bh->b_data, 0, journal->j_blocksize);
 		BUFFER_TRACE(bh, "marking dirty");
-- 
1.7.0.4

