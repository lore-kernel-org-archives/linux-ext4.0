From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] jbd: Convert atomic_inc() to get_bh()
Date: Sat, 16 Oct 2010 17:11:02 +0900
Message-ID: <1287216662-4267-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48361 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab0JPILI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Oct 2010 04:11:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Convert atomic_inc(&bh->b_count) to get_bh(bh) for consistency.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/checkpoint.c |    4 ++--
 fs/jbd/commit.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 05a38b9..e4b87bc 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -221,7 +221,7 @@ restart:
 			goto restart;
 		}
 		if (buffer_locked(bh)) {
-			atomic_inc(&bh->b_count);
+			get_bh(bh);
 			spin_unlock(&journal->j_list_lock);
 			jbd_unlock_bh_state(bh);
 			wait_on_buffer(bh);
@@ -283,7 +283,7 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 	int ret = 0;
 
 	if (buffer_locked(bh)) {
-		atomic_inc(&bh->b_count);
+		get_bh(bh);
 		spin_unlock(&journal->j_list_lock);
 		jbd_unlock_bh_state(bh);
 		wait_on_buffer(bh);
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 95d8c11..1a9d033 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -611,7 +611,7 @@ void journal_commit_transaction(journal_t *journal)
 		/* Bump b_count to prevent truncate from stumbling over
                    the shadowed buffer!  @@@ This can go if we ever get
                    rid of the BJ_IO/BJ_Shadow pairing of buffers. */
-		atomic_inc(&jh2bh(jh)->b_count);
+		get_bh(jh2bh(jh));
 
 		/* Make a temporary IO buffer with which to write it out
                    (this will requeue both the metadata buffer and the
-- 
1.7.0.4

