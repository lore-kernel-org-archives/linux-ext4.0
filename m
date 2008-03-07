From: akpm@linux-foundation.org
Subject: + jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:57:21 -0800
Message-ID: <200803070857.m278vLQM014112@imap1.linux-foundation.org>
Cc: duaneg@dghda.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403AbYCGI5Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2008 03:57:25 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd2: only create debugfs and stats entries if cache initialisation is successful
has been added to the -mm tree.  Its filename is
     jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2: only create debugfs and stats entries if cache initialisation is successful
From: "Duane Griffin" <duaneg@dghda.com>

jbd2 debugfs and stats entries should only be created if cache initialisation
is successful.  At the moment they are being created unconditionally which
will leave them dangling if cache (and hence module) initialisation fails.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/jbd2/journal.c~jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful
+++ a/fs/jbd2/journal.c
@@ -2321,10 +2321,12 @@ static int __init journal_init(void)
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

jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch
jbd2-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd2-replace-potentially-false-assertion-with-if-block.patch
jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch

