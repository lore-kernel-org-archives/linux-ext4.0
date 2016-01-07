From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] jbd2: Save some atomic ops in __JI_COMMIT_RUNNING handling
Date: Thu,  7 Jan 2016 15:41:55 +0100
Message-ID: <1452177715-9671-5-git-send-email-jack@suse.cz>
References: <1452177715-9671-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbcAGOlv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jan 2016 09:41:51 -0500
In-Reply-To: <1452177715-9671-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we used atomic bit operations to manipulate
__JI_COMMIT_RUNNING bit. However this is unnecessary as i_flags are
always written and read under j_list_lock. So just change the operations
to standard bit operations.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/commit.c  | 12 ++++++------
 fs/jbd2/journal.c |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index ae832cd44dd8..517f2de784cf 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -220,7 +220,7 @@ static int journal_submit_data_buffers(journal_t *journal,
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
 		mapping = jinode->i_vfs_inode->i_mapping;
-		set_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
+		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
 		/*
 		 * submit the inode data buffers. We use writepage
@@ -234,8 +234,8 @@ static int journal_submit_data_buffers(journal_t *journal,
 			ret = err;
 		spin_lock(&journal->j_list_lock);
 		J_ASSERT(jinode->i_transaction == commit_transaction);
-		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
-		smp_mb__after_atomic();
+		jinode->i_flags &= ~JI_COMMIT_RUNNING;
+		smp_mb();
 		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
 	}
 	spin_unlock(&journal->j_list_lock);
@@ -256,7 +256,7 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
-		set_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
+		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
 		err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
 		if (err) {
@@ -272,8 +272,8 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 				ret = err;
 		}
 		spin_lock(&journal->j_list_lock);
-		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
-		smp_mb__after_atomic();
+		jinode->i_flags &= ~JI_COMMIT_RUNNING;
+		smp_mb();
 		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
 	}
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index defa962a8e15..7bf1683e81af 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2587,7 +2587,7 @@ void jbd2_journal_release_jbd_inode(journal_t *journal,
 restart:
 	spin_lock(&journal->j_list_lock);
 	/* Is commit writing out inode - we have to wait */
-	if (test_bit(__JI_COMMIT_RUNNING, &jinode->i_flags)) {
+	if (jinode->i_flags & JI_COMMIT_RUNNING) {
 		wait_queue_head_t *wq;
 		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
 		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
-- 
2.6.2

