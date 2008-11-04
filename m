From: akpm@linux-foundation.org
Subject: + jbd-improve-fsync-batching-update.patch added to -mm tree
Date: Tue, 04 Nov 2008 10:40:37 -0800
Message-ID: <200811041840.mA4IebcS027113@imap1.linux-foundation.org>
Cc: jbacik@redhat.com, adilger@sun.com, arjan@infradead.org,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbYKDSk4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 13:40:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     improve jbd fsync batching (update)
has been added to the -mm tree.  Its filename is
     jbd-improve-fsync-batching-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: improve jbd fsync batching (update)
From: Josef Bacik <jbacik@redhat.com>

On Mon, Nov 03, 2008 at 12:55:09PM -0800, Andrew Morton wrote:
> On Mon, 3 Nov 2008 15:24:43 -0500
> Josef Bacik <jbacik@redhat.com> wrote:
>
> > > please fix.
> >
> > I see you already pulled this into -mm, would you like me to repost with the
> > same changelog and the patch updated, or just reply to this with the updated
> > patch?  Thanks,
>
> Either works for me at this stage.  If it's a replacement then I'll turn
> it into an incremental so I can see what changed, which takes me about 2.15
> seconds.
>
> If it had been a large patch or if it had been under test in someone's
> tree for a while then a replacement patch would be unwelcome.  But for a
> small, fresh patch like this one it's no big deal either way.
>

Ok here is a replacement patch with the comments as requested, as well as a
comment for j_last_sync_writer.  Thank you,

Cc: Andreas Dilger <adilger@sun.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ric Wheeler <rwheeler@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c |   11 +++++++++++
 include/linux/jbd.h  |    8 ++++++++
 2 files changed, 19 insertions(+)

diff -puN fs/jbd/transaction.c~jbd-improve-fsync-batching-update fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-improve-fsync-batching-update
+++ a/fs/jbd/transaction.c
@@ -1401,6 +1401,17 @@ int journal_stop(handle_t *handle)
 	 * on IO anyway.  Speeds up many-threaded, many-dir operations
 	 * by 30x or more...
 	 *
+	 * We try and optimize the sleep time against what the underlying disk
+	 * can do, instead of having a static sleep time.  This is usefull for
+	 * the case where our storage is so fast that it is more optimal to go
+	 * ahead and force a flush and wait for the transaction to be committed
+	 * than it is to wait for an arbitrary amount of time for new writers to
+	 * join the transaction.  We acheive this by measuring how long it takes
+	 * to commit a transaction, and compare it with how long this
+	 * transaction has been running, and if run time < commit time then we
+	 * sleep for the delta and commit.  This greatly helps super fast disks
+	 * that would see slowdowns as more threads started doing fsyncs.
+	 *
 	 * But don't do this if this process was the most recent one to
 	 * perform a synchronous write.  We do this to detect the case where a
 	 * single process is doing a stream of sync writes.  No point in waiting
diff -puN include/linux/jbd.h~jbd-improve-fsync-batching-update include/linux/jbd.h
--- a/include/linux/jbd.h~jbd-improve-fsync-batching-update
+++ a/include/linux/jbd.h
@@ -803,8 +803,16 @@ struct journal_s
 	struct buffer_head	**j_wbuf;
 	int			j_wbufsize;
 
+	/*
+	 * this is the pid of the last person to run a synchronous operation
+	 * through the journal.
+	 */
 	pid_t			j_last_sync_writer;
 
+	/*
+	 * the average amount of time in nanoseconds it takes to commit a
+	 * transaction to the disk.  [j_state_lock]
+	 */
 	u64			j_average_commit_time;
 
 	/*
_

Patches currently in -mm which might be from jbacik@redhat.com are

jbd-improve-fsync-batching.patch
jbd-improve-fsync-batching-update.patch

