From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH RFC] jbd: don't wake kjournald unnecessarily
Date: Tue, 18 Dec 2012 11:03:57 -0600
Message-ID: <50D0A1FD.7040203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Wysochanski <dwysocha@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab2LRREk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Dec 2012 12:04:40 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit d9b0193 jbd: fix fsync() tid wraparound bug
changed the logic for whether __log_start_commit() should wake up
kjournald.

After backporting this to RHEL6, I had a report of a performance regression
on a large benchmark, and it was narrowed down to the change above.

I did a little investigation of jbd behavior while running xfstest
013, which just does a large fsstress run, and found that we were
waking up kjournald more often than before; specifically,
in the case where

	target == j_commit_request == journal->j_running_transaction

It seems to me that the wakeup is not needed if we already have
the right target on the commit request, so I tested with the
additional condition added in the patch below; this brought
performance back up to prior levels.

I also tested it with tid_t defined to a u8, to get frequent wraps.
If I back out the wraparound patch, it will easily provoke
the original ASSERT that prompted the prior commit.  With
the commit in place and the patch below, I survived running
fsstress for 10 hours without problems even with a frequently-wrapping
tid_t.

A couple questions remain:

With a u8 tid_t, the "else" clause from commit d9b0193 fires
frequently; I really think the underlying problem is that tid_geq()
etc does not properly handle wraparounds - if, say, target is 255
and j_commit_request is 0, we don't know if j_commit_request
is 255 tids behind, or 1 tid ahead.  I have to think about that
some more, unless it's obvious to someone else.

FWIW, some people have indeed seen that else clause fire upstream,
both in the case where j_commit_request is > 2^31 and the 
target is 0.

https://bugzilla.kernel.org/show_bug.cgi?id=46031
http://forums.debian.net/viewtopic.php?f=5&t=80741

Anyway, I think this patch helps on the "don't send extra wakeups"
side of things.  Does anyone see a problem with it?

If it looks ok, I'll send the same for jbd2.

Thanks,
-Eric

=============
[PATCH] jbd: don't wake kjournald unnecessarily

Don't send an extra wakeup to kjournald in the case where we
already have the proper target in j_commit_request, i.e. that
commit has already been requested for commit.

commit d9b0193 "jbd: fix fsync() tid wraparound bug" changed
the logic leading to a wakeup, but it caused some extra wakeups
which were found to lead to a measurable performance regression.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index a286233..81cc7ea 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -446,7 +446,8 @@ int __log_start_commit(journal_t *journal, tid_t target)
 	 * currently running transaction (if it exists).  Otherwise,
 	 * the target tid must be an old one.
 	 */
-	if (journal->j_running_transaction &&
+	if (journal->j_commit_request != target &&
+	    journal->j_running_transaction &&
 	    journal->j_running_transaction->t_tid == target) {
 		/*
 		 * We want a new commit: OK, mark the request and wakeup the
