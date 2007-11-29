From: akpm@linux-foundation.org
Subject: [patch 5/8] ext4: Fix oops with jbd-stats-through-procfs and external journal
Date: Thu, 29 Nov 2007 12:52:51 -0800
Message-ID: <200711292052.lATKqpbB006837@imap1.linux-foundation.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, sandeen@redhat.com
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38396 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760390AbXK2UyL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2007 15:54:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

When using an external device for the journal, jbd2_stats_proc_init() wants
to use journal->j_dev in its call to bdevname() but it's not assigned yet,
resulting in an oops.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jbd2/journal.c~ext4-fix-oops-with-jbd-stats-through-procfs-and-external fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~ext4-fix-oops-with-jbd-stats-through-procfs-and-external
+++ a/fs/jbd2/journal.c
@@ -1035,11 +1035,11 @@ journal_t * jbd2_journal_init_dev(struct
 		journal = NULL;
 		goto out;
 	}
-	jbd2_stats_proc_init(journal);
 	journal->j_dev = bdev;
 	journal->j_fs_dev = fs_dev;
 	journal->j_blk_offset = start;
 	journal->j_maxlen = len;
+	jbd2_stats_proc_init(journal);
 
 	bh = __getblk(journal->j_dev, start, journal->j_blocksize);
 	J_ASSERT(bh != NULL);
_
