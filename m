From: Tao Ma <tm@tao.ma>
Subject: [PATCH] jbd/jbd2: remove obsolete summarise_journal_usage.
Date: Thu,  5 May 2011 23:54:19 +0800
Message-ID: <1304610859-480-1-git-send-email-tm@tao.ma>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:36026 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751913Ab1EEPyg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2011 11:54:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

summarise_journal_usage seems to be obsolete for a long time,
so remove it.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/jbd/commit.c  |    6 ------
 fs/jbd2/commit.c |    6 ------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 69b1804..9cbf9e4 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -302,12 +302,6 @@ void journal_commit_transaction(journal_t *journal)
 	 * all outstanding updates to complete.
 	 */
 
-#ifdef COMMIT_STATS
-	spin_lock(&journal->j_list_lock);
-	summarise_journal_usage(journal);
-	spin_unlock(&journal->j_list_lock);
-#endif
-
 	/* Do we need to erase the effects of a prior journal_flush? */
 	if (journal->j_flags & JFS_FLUSHED) {
 		jbd_debug(3, "super block updated\n");
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 6e28000..29148a8 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -338,12 +338,6 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * all outstanding updates to complete.
 	 */
 
-#ifdef COMMIT_STATS
-	spin_lock(&journal->j_list_lock);
-	summarise_journal_usage(journal);
-	spin_unlock(&journal->j_list_lock);
-#endif
