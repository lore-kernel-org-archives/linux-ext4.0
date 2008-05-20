From: Theodore Tso <tytso@MIT.EDU>
Subject: [PATCH, RFC] ext4: Fix use of write barrier in commit logic
Date: Mon, 19 May 2008 22:51:12 -0400
Message-ID: <20080520025112.GN15035@mit.edu>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <87ej7zcrqv.fsf@basil.nowhere.org> <200805190926.41970.chris.mason@oracle.com> <20080519144654.GC15035@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63952 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755057AbYETCxZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2008 22:53:25 -0400
Content-Disposition: inline
In-Reply-To: <20080519144654.GC15035@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 19, 2008 at 10:46:54AM -0400, Theodore Tso wrote:
> Funny thing, I was looking in this over the weekend.  It currently
> avoids barriers entirely if journal_async_commit is enabled (which is
> not the default); if enabled, it effectively forces barrier=0.  This
> is IMHO a bug.
> 
> I'm working on a patch where "barrier=1" will use a barrier before and
> after, and "barrier=1,journal_async_commit" will use a barrier after.

And here it is.... 

Comments, please.  And Eric, if you have a chance to benchmark this to
see how this patch works out, comparing "barrier=0, "barrier=1", and
"barrier=1,journal_async_commit", as we had discussed earlier on the
ext4, I'd be very much obliged.

As I mentioned earlier, adding blkdev_issue_flush() to ext[34]/fsync.c
is I believe not necessary.  We should be doing the right thing in the
commit.c file.  In the future, if we want some extra bonus points, in
the case where writes have taken place to the inode, but no metadata
operations have taken place (the common case when a database is
writing to a pre-existing tablespace), it would be nice if fsync()
could notice this case, force out the datablocks the old-fashioned way
without forcing an journal commit, and then calling
blkdev_issue_flush().  That should give us some nice performance wins
for database workloads; unfortunately it probably won't do us any good
on mailserver workloads.

Regards,

						- Ted

>From ce99d82266d003e9b2284a1f46bd6f0e3a87c066 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Mon, 19 May 2008 22:40:52 -0400
Subject: [PATCH] ext4: Fix use of write barrier in commit logic

We were previously using set_buffer_ordered() and then calling
submit_bh() to write the commit block, which resulted in this flush
behavior:

write log blocks
blkdev_issue_flush()	// flush #1
write commit block
blkdev_issue_flush()	// flush #2
write metadata blocks

And if the journal_async_commit mount option was used, the commit was
written without using set_buffer_ordered(), which resulted in no
flushes happening at all.

Change the commit code to use blkdev_issue_flush() explicitly, and to
omit flush #1 if journal_async_commit is enabled, but to always
perform the second flush if write barriers are enabled.

This change should hopefully reduce the overhead of using write
barriers when an ext4 filesystem is mounted using
"barrier=1,journal_async_commit", while still maintaining filesystem
safety.  If this works out, we should probably make this the default
mode for ext4.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/commit.c |   44 +++++++++++++++++---------------------------
 1 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 3041d75..3fe5be5 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -22,6 +22,7 @@
 #include <linux/pagemap.h>
 #include <linux/jiffies.h>
 #include <linux/crc32.h>
+#include <linux/blkdev.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -111,7 +112,6 @@ static int journal_submit_commit_record(journal_t *journal,
 	struct commit_header *tmp;
 	struct buffer_head *bh;
 	int ret;
-	int barrier_done = 0;
 	struct timespec now = current_kernel_time();
 
 	if (is_journal_aborted(journal))
@@ -147,34 +147,24 @@ static int journal_submit_commit_record(journal_t *journal,
 	if (journal->j_flags & JBD2_BARRIER &&
 		!JBD2_HAS_INCOMPAT_FEATURE(journal,
 					 JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
-		set_buffer_ordered(bh);
-		barrier_done = 1;
+		ret = blkdev_issue_flush(bh->b_bdev, NULL);
+		if (ret == -EOPNOTSUPP) {
+			char b[BDEVNAME_SIZE];
+
+			printk(KERN_WARNING
+			       "JBD: barrier-based sync failed on %s - "
+			       "disabling barriers\n",
+			       bdevname(journal->j_dev, b));
+			spin_lock(&journal->j_state_lock);
+			journal->j_flags &= ~JBD2_BARRIER;
+			spin_unlock(&journal->j_state_lock);
+		}
 	}
 	ret = submit_bh(WRITE, bh);
-	if (barrier_done)
-		clear_buffer_ordered(bh);
 
-	/* is it possible for another commit to fail at roughly
-	 * the same time as this one?  If so, we don't want to
-	 * trust the barrier flag in the super, but instead want
-	 * to remember if we sent a barrier request
-	 */
-	if (ret == -EOPNOTSUPP && barrier_done) {
-		char b[BDEVNAME_SIZE];
