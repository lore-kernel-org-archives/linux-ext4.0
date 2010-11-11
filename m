From: yangsheng <sheng.yang@oracle.com>
Subject: [PATCH]  V2 jbd2_stats_proc_init wrong place.
Date: Fri, 12 Nov 2010 05:23:18 +0800
Message-ID: <1289510598-15315-1-git-send-email-sheng.yang__1079.0477660068$1289609507$gmane$org@oracle.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: yangsheng <sheng.yang@oracle.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:18873 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab0KMAvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Nov 2010 19:51:40 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The jbd2_stats_proc_init() was placed on wrong location in
jbd2_journal_init_dev().  This may cause /proc/fs/jdb2/<dev>/*
cannot be created when using external journal device.
---
fs/jbd2/journal.c |   19 ++++++++++---------
1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 13b0a92..a435710 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -897,9 +897,18 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
	if (!journal)
		return NULL;

+	journal->j_dev = bdev;
+	journal->j_fs_dev = fs_dev;
+	journal->j_blk_offset = start;
+	journal->j_maxlen = len;
+	bdevname(journal->j_dev, journal->j_devname);
+	p = journal->j_devname;
+	while ((p = strchr(p, '/')))
+		*p = '!';
+	jbd2_stats_proc_init(journal);
+
	/* journal descriptor can store up to n blocks -bzzz */
	journal->j_blocksize = blocksize;
-	jbd2_stats_proc_init(journal);
	n = journal->j_blocksize / sizeof(journal_block_tag_t);
	journal->j_wbufsize = n;
	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
@@ -908,14 +917,6 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
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

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
