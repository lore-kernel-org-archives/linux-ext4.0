From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] jbd: fix assertion failure in journal_next_log_block
Date: Thu, 31 Jan 2008 16:52:26 -0500
Message-ID: <20080131215226.GC29679@unused.rdu.redhat.com>
References: <20080131161417.GA29679@unused.rdu.redhat.com> <20080131193543.GS23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760629AbYAaV57 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2008 16:57:59 -0500
Content-Disposition: inline
In-Reply-To: <20080131193543.GS23836@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2008 at 12:35:43PM -0700, Andreas Dilger wrote:
> On Jan 31, 2008  11:14 -0500, Josef Bacik wrote:
> [snip excellent analysis]
> > So you get into this situation where
> > t_nr_buffers (the actual number of buffers that are on the transaction) is
> > greater than the number of buffers accounted for via t_outstanding_credits.
> > This presents a problem since as we loop through writting buffers to the
> > journal, we decrement t_outstanding_credits, and if t_nr_buffers is more than
> > t_outstanding_credits then we end up with a negative number for
> > t_outstanding_credits
> > 
> > Signed-off-by: Josef Bacik <jbacik@redhat.com>
> 
> Do you know what kernel this problem was introduced in, or is this a
> long standing problem?  Presumably the same is needed for jbd2?
> 
> Once we have some decent amount of testing going on with ext4, I think
> it makes sense to merge the jbd2 changes back into jbd and return to
> a single code base, since there is nothing in the jbd2 code that ext3
> can't also work with (i.e. all of the changes are properly isolated
> with compatibility flags and such).
> 
> > @@ -1056,7 +1056,7 @@ static inline int jbd_space_needed(journal_t *journal)
> >  	int nblocks = journal->j_max_transaction_buffers;
> >  	if (journal->j_committing_transaction)
> >  		nblocks += journal->j_committing_transaction->
> > -					t_outstanding_credits;
> > +					t_nr_buffers;
> 
> (trivial) this can be moved back onto the previous line.
> 
> > @@ -1168,7 +1168,7 @@ static inline int jbd_space_needed(journal_t *journal)
> >  	int nblocks = journal->j_max_transaction_buffers;
> >  	if (journal->j_committing_transaction)
> >  		nblocks += journal->j_committing_transaction->
> > -					t_outstanding_credits;
> > +					t_nr_buffers;
> 
> Same...
>

The original issue was reported on RHEL4, so thats 2.6.9, and looking through
the old-bkcvs git tree I can't see where this was introduced, so it's probably
existed before that.  The same problem looks to exist in jbd2 though I haven't
tested it myself, I just went ahead and included the fixes.  Here is the updated
patch, thanks much for the comments.

Signed-off-by: Josef Bacik <jbacik@redhat.com>

 
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 31853eb..e385a5c 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -561,13 +561,6 @@ void journal_commit_transaction(journal_t *journal)
 			continue;
 		}
 
-		/*
-		 * start_this_handle() uses t_outstanding_credits to determine
-		 * the free space in the log, but this counter is changed
-		 * by journal_next_log_block() also.
-		 */
-		commit_transaction->t_outstanding_credits--;
-
 		/* Bump b_count to prevent truncate from stumbling over
                    the shadowed buffer!  @@@ This can go if we ever get
                    rid of the BJ_IO/BJ_Shadow pairing of buffers. */
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 4f302d2..c0f93f5 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -580,7 +580,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	stats.u.run.rs_logging = jiffies;
 	stats.u.run.rs_flushing = jbd2_time_diff(stats.u.run.rs_flushing,
 						 stats.u.run.rs_logging);
-	stats.u.run.rs_blocks = commit_transaction->t_outstanding_credits;
+	stats.u.run.rs_blocks = commit_transaction->t_nr_buffers;
 	stats.u.run.rs_blocks_logged = 0;
 
 	descriptor = NULL;
@@ -655,13 +655,6 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 			continue;
 		}
 
-		/*
-		 * start_this_handle() uses t_outstanding_credits to determine
-		 * the free space in the log, but this counter is changed
-		 * by jbd2_journal_next_log_block() also.
-		 */
-		commit_transaction->t_outstanding_credits--;
-
 		/* Bump b_count to prevent truncate from stumbling over
                    the shadowed buffer!  @@@ This can go if we ever get
                    rid of the BJ_IO/BJ_Shadow pairing of buffers. */
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index d9ecd13..eaeb3db 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -1055,8 +1055,7 @@ static inline int jbd_space_needed(journal_t *journal)
 {
 	int nblocks = journal->j_max_transaction_buffers;
 	if (journal->j_committing_transaction)
-		nblocks += journal->j_committing_transaction->
-					t_outstanding_credits;
+		nblocks += journal->j_committing_transaction->t_nr_buffers;
 	return nblocks;
 }
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 2cbf6fd..acf9d34 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1167,8 +1167,7 @@ static inline int jbd_space_needed(journal_t *journal)
 {
 	int nblocks = journal->j_max_transaction_buffers;
 	if (journal->j_committing_transaction)
-		nblocks += journal->j_committing_transaction->
-					t_outstanding_credits;
+		nblocks += journal->j_committing_transaction->t_nr_buffers;
 	return nblocks;
 }
 
