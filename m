From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] jbd2: don't wake kjournald unnecessarily
Date: Thu, 31 Jan 2013 12:53:06 -0500
Message-ID: <1359654788-6078-2-git-send-email-tytso@mit.edu>
References: <1359654788-6078-1-git-send-email-tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46396 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab3AaRxQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 12:53:16 -0500
In-Reply-To: <1359654788-6078-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

Don't send an extra wakeup to kjournald in the case where we
already have the proper target in j_commit_request, i.e. that
transaction has already been requested for commit.

commit deeeaf13 "jbd2: fix fsync() tid wraparound bug" changed
the logic leading to a wakeup, but it caused some extra wakeups
which were found to lead to a measurable performance regression.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
[tytso@mit.edu: reworked check to make it clearer]
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/journal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index dbf41f9..1a80e31 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -513,6 +513,10 @@ int __jbd2_log_space_left(journal_t *journal)
  */
 int __jbd2_log_start_commit(journal_t *journal, tid_t target)
 {
+	/* Return if the txn has already requested to be committed */
+	if (journal->j_commit_request == target)
+		return 0;
+
 	/*
 	 * The only transaction we can possibly wait upon is the
 	 * currently running transaction (if it exists).  Otherwise,
-- 
1.7.12.rc0.22.gcdd159b

