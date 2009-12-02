From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] jbd2: Add ENOMEM checking in and for jbd2_journal_write_metadata_buffer()
Date: Tue,  1 Dec 2009 20:14:10 -0500
Message-ID: <1259716451-26901-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43724 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbZLBBOH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Dec 2009 20:14:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OOM happens.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/commit.c  |    4 ++++
 fs/jbd2/journal.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index d4cfd6d..8896c1d 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -636,6 +636,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		JBUFFER_TRACE(jh, "ph3: write metadata");
 		flags = jbd2_journal_write_metadata_buffer(commit_transaction,
 						      jh, &new_jh, blocknr);
+		if (flags < 0) {
+			jbd2_journal_abort(journal, flags);
+			continue;
+		}
 		set_bit(BH_JWrite, &jh2bh(new_jh)->b_state);
 		wbuf[bufs++] = jh2bh(new_jh);
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index af60d98..3f473fa 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -358,6 +358,10 @@ repeat:
 
 		jbd_unlock_bh_state(bh_in);
 		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
+		if (!tmp) {
+			jbd2_journal_put_journal_head(new_jh);
+			return -ENOMEM;
+		}
 		jbd_lock_bh_state(bh_in);
 		if (jh_in->b_frozen_data) {
 			jbd2_free(tmp, bh_in->b_size);
-- 
1.6.5.216.g5288a.dirty

