From: akpm@linux-foundation.org
Subject: [patch 1/1] fs/jbd2/journal.c: kmalloc + memset conversion to kzalloc
Date: Tue, 14 Aug 2007 12:41:13 -0700
Message-ID: <200708141941.l7EJfDKN017721@imap1.linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	m.kozlowski@tuxland.pl
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935088AbXHNTlv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2007 15:41:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/jbd2/journal.c | 66771 -> 66719 (-52 bytes)
 fs/jbd2/journal.o | 199193 -> 199049 (-144 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/jbd2/journal.c~fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc
+++ a/fs/jbd2/journal.c
@@ -929,17 +929,16 @@ static void journal_init_stats(journal_t
 {
 	int size;
 
-	if (proc_jbd2_stats == NULL)
+	if (!proc_jbd2_stats)
 		return;
 
 	journal->j_history_max = 100;
 	size = sizeof(struct transaction_stats_s) * journal->j_history_max;
-	journal->j_history = kmalloc(size, GFP_KERNEL);
-	if (journal->j_history == NULL) {
+	journal->j_history = kzalloc(size, GFP_KERNEL);
+	if (!journal->j_history) {
 		journal->j_history_max = 0;
 		return;
 	}
-	memset(journal->j_history, 0, size);
 	spin_lock_init(&journal->j_history_lock);
 }
 
_
