From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] jbd2: Add commit time into the commit block
Date: Sat, 15 Mar 2008 20:59:04 -0400
Message-ID: <1205629144-25994-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33229 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752334AbYCPA7H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2008 20:59:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Carlo Wood has demonstrated that it's possible to recover deleted
files from the journal.  Something that will make this easier is if we
can put the time of the commit into commit block.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/commit.c     |    3 +++
 include/linux/jbd2.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index e013978..7c5fbd5 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -112,6 +112,7 @@ static int journal_submit_commit_record(journal_t *journal,
 	struct buffer_head *bh;
 	int ret;
 	int barrier_done = 0;
+	struct timespec now = current_kernel_time();
 
 	if (is_journal_aborted(journal))
 		return 0;
@@ -126,6 +127,8 @@ static int journal_submit_commit_record(journal_t *journal,
 	tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
 	tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
 	tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
+	tmp->h_commit_sec = cpu_to_be32(now->tv_sec);
+	tmp->h_commit_nsec = cpu_to_be32(now->tv_nsec);
 
 	if (JBD2_HAS_COMPAT_FEATURE(journal,
 				    JBD2_FEATURE_COMPAT_CHECKSUM)) {
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 2cbf6fd..7cbeb2b 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -170,6 +170,8 @@ struct commit_header {
 	unsigned char   h_chksum_size;
 	unsigned char 	h_padding[2];
 	__be32 		h_chksum[JBD2_CHECKSUM_BYTES];
+	__be32		h_commit_sec;
+	__be32		h_commit_nsec;
 };
 
 /*
-- 
1.5.4.1.144.gdfee-dirty

