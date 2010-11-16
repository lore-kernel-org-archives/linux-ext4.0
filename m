From: yangsheng <sheng.yang@oracle.com>
Subject: [PATCH resend]  jbd2_stats_proc_init wrong place.
Date: Tue, 16 Nov 2010 15:31:44 +0800
Message-ID: <1289892704-27147-1-git-send-email-sheng.yang@oracle.com>
Cc: andreas.dilger@oracle.com, linux-fsdevel@vger.kernel.org,
	yangsheng <sheng.yang@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:36649 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0KPHc0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Nov 2010 02:32:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 The jbd2_stats_proc_init() was placed on wrong location in
 jbd2_journal_init_dev().  This may cause /proc/fs/jdb2/<dev>/*
 cannot be created when using external journal device.

 Reviewed-by: Andreas Dilger <andreas.dilger@oracle.com>

---
---
 fs/jbd2/journal.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index c590d15..f837ba9 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -899,6 +899,14 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
 
 	/* journal descriptor can store up to n blocks -bzzz */
 	journal->j_blocksize = blocksize;
+	journal->j_dev = bdev;
+	journal->j_fs_dev = fs_dev;
+	journal->j_blk_offset = start;
+	journal->j_maxlen = len;
+	bdevname(journal->j_dev, journal->j_devname);
+	p = journal->j_devname;
+	while ((p = strchr(p, '/')))
+		*p = '!';
 	jbd2_stats_proc_init(journal);
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
@@ -908,14 +916,6 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
 			__func__);
 		goto out_err;
 	}
-	journal->j_dev = bdev;
-	journal->j_fs_dev = fs_dev;
-	journal->j_blk_offset = start;
-	journal->j_maxlen = len;
-	bdevname(journal->j_dev, journal->j_devname);
-	p = journal->j_devname;
-	while ((p = strchr(p, '/')))
-		*p = '!';
 
 	bh = __getblk(journal->j_dev, start, journal->j_blocksize);
 	if (!bh) {
-- 
1.7.2.3

