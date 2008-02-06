From: akpm@linux-foundation.org
Subject: [patch 248/260] BKL-removal: remove incorrect comment refering to lock_kernel() from jbd/jbd2
Date: Wed, 06 Feb 2008 01:40:11 -0800
Message-ID: <200802060939.m169drRs004779@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, ak@suse.de, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757945AbYBFJtn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 04:49:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andi Kleen <ak@suse.de>

None of the callers of this function does actually take the BKL as far as I
can see.  So remove the comment refering to the BKL.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: <linux-ext4@vger.kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/recovery.c  |    2 +-
 fs/jbd2/recovery.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/jbd/recovery.c~bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2 fs/jbd/recovery.c
--- a/fs/jbd/recovery.c~bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2
+++ a/fs/jbd/recovery.c
@@ -354,7 +354,7 @@ static int do_one_pass(journal_t *journa
 		struct buffer_head *	obh;
 		struct buffer_head *	nbh;
 
-		cond_resched();		/* We're under lock_kernel() */
+		cond_resched();
 
 		/* If we already know where to stop the log traversal,
 		 * check right now that we haven't gone past the end of
diff -puN fs/jbd2/recovery.c~bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2 fs/jbd2/recovery.c
--- a/fs/jbd2/recovery.c~bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2
+++ a/fs/jbd2/recovery.c
@@ -397,7 +397,7 @@ static int do_one_pass(journal_t *journa
 		struct buffer_head *	obh;
 		struct buffer_head *	nbh;
 
-		cond_resched();		/* We're under lock_kernel() */
+		cond_resched();
 
 		/* If we already know where to stop the log traversal,
 		 * check right now that we haven't gone past the end of
_
