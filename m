From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: completely ignore last-mount and last-write
 within fudge_time
Date: Sat, 28 Mar 2015 22:32:26 -0400
Message-ID: <20150329023226.GA19097@thunk.org>
References: <5509DCE4.1010706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38520 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbbC2Ccd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Mar 2015 22:32:33 -0400
Content-Disposition: inline
In-Reply-To: <5509DCE4.1010706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm a bit more partial to this method of fixing the issue.

What do folks think?

      	       	       	       	      	 - Ted
					 
commit f096708126412c0569e40cfbd5740729976bf12a
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Mar 28 21:39:54 2015 -0400

    e2fsck: use PROMPT_NONE for FUTURE_SB_LAST_*_FUDGED problems
    
    This allows us to print a message warning the user that there is
    something funny going on with their hardware clock (probably time zone
    issues caused by trying to be compatible with legacy OS's such as
    Windows), without triggering a full file system check.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 12cf836..f442a33 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -386,14 +386,14 @@ static struct e2fsck_problem problem_table[] = {
 	/* Last mount time is in the future (fudged) */
 	{ PR_0_FUTURE_SB_LAST_MOUNT_FUDGED,
 	  N_("@S last mount time is in the future.\n\t(by less than a day, "
-	     "probably due to the hardware clock being incorrectly set)  "),
-	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
+	     "probably due to the hardware clock being incorrectly set)\n"),
+	  PROMPT_NONE, PR_PREEN_OK | PR_NO_OK },
 
 	/* Last write time is in the future (fudged) */
 	{ PR_0_FUTURE_SB_LAST_WRITE_FUDGED,
 	  N_("@S last write time is in the future.\n\t(by less than a day, "
-	     "probably due to the hardware clock being incorrectly set).  "),
-	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
+	     "probably due to the hardware clock being incorrectly set)\n"),
+	  PROMPT_NONE, PR_PREEN_OK | PR_NO_OK },
 
 	/* Block group checksum (latch question) is invalid. */
 	{ PR_0_GDT_CSUM_LATCH,
