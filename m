From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] jbd2: don't wake kjournald unnecessarily
Date: Tue, 18 Dec 2012 20:59:54 -0600
Message-ID: <50D12DAA.9050700@redhat.com>
References: <50D0A1FD.7040203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Wysochanski <dwysocha@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab2LSDB2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Dec 2012 22:01:28 -0500
In-Reply-To: <50D0A1FD.7040203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't send an extra wakeup to kjournald in the case where we
already have the proper target in j_commit_request, i.e. that
transaction has already been requested for commit.

commit deeeaf13 "jbd2: fix fsync() tid wraparound bug" changed
the logic leading to a wakeup, but it caused some extra wakeups
which were found to lead to a measurable performance regression.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index dbf41f9..89970d5 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -518,7 +518,8 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t target)
 	 * currently running transaction (if it exists).  Otherwise,
 	 * the target tid must be an old one.
 	 */
-	if (journal->j_running_transaction &&
+	if (journal->j_commit_request != target &&
+	    journal->j_running_transaction &&
 	    journal->j_running_transaction->t_tid == target) {
 		/*
 		 * We want a new commit: OK, mark the request and wakeup the
