From: akpm@linux-foundation.org
Subject: - jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:52:07 -0700
Message-ID: <200804300552.m3U5q7ud030287@imap1.linux-foundation.org>
To: duaneg@dghda.com, adilger@sun.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758865AbYD3Fwo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 01:52:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd2: only create debugfs and stats entries if cache initialisation is successful
has been removed from the -mm tree.  Its filename was
     jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2: only create debugfs and stats entries if cache initialisation is successful
From: "Duane Griffin" <duaneg@dghda.com>

jbd2 debugfs and stats entries should only be created if cache initialisation
is successful.  At the moment they are being created unconditionally which
will leave them dangling if cache (and hence module) initialisation fails.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Acked-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/jbd2/journal.c~jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful
+++ a/fs/jbd2/journal.c
@@ -2319,10 +2319,12 @@ static int __init journal_init(void)
 	BUILD_BUG_ON(sizeof(struct journal_superblock_s) != 1024);
 
 	ret = journal_init_caches();
-	if (ret != 0)
+	if (ret == 0) {
+		jbd2_create_debugfs_entry();
+		jbd2_create_jbd_stats_proc_entry();
+	} else {
 		jbd2_journal_destroy_caches();
-	jbd2_create_debugfs_entry();
-	jbd2_create_jbd_stats_proc_entry();
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from duaneg@dghda.com are

origin.patch

