From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Fri, 19 Dec 2008 01:27:52 +0100
Message-ID: <20081219002752.GE8424@duck.suse.cz>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081218231707.GB20092@atrey.karlin.mff.cuni.cz> <494ADEB3.8010109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59245 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751165AbYLSA1z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Dec 2008 19:27:55 -0500
Content-Disposition: inline
In-Reply-To: <494ADEB3.8010109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-12-08 17:37:23, Eric Sandeen wrote:
> Jan Kara wrote:
> >   Hello,
> > 
> >   I'm sorry I'm replying late but I got time to react to this only now...
> > 
> 
> <snip>
> 
> >> I tried this and it too fixes the problem.  FWIW I agree it
> >> looks better...
> >   Well, shouldn't we rather fix what journal_start_commit() returns?
> > The interface which returns 1 when a transaction is already committing or
> > a transaction commit has just been started but 0 when we race with
> > somebody staring the commit is fairly unusable. Moreover
> > ext3_force_commit() will unnecessarily create new sync transaction and
> > commit it if there's no transaction running which is quite expensive
> > (even merging empty sync handle is not for free because of sync
> > transaction batching). But this is minor problem since we probably
> > don't care too much about sync() performance - BTW this is probably a
> > cause for bug 12224, isn't it?
> 
> Yep, it is!  :)
> 
> >   BTW: ocfs2 would need fixing as well if done your way since it's
> > sync_fs function has been copied over from ext3.
> >   To summarized I'd rather see a patch like below (untested) going in
> > and your patch reverted... Opinions? I can cookup a JBD2 version of
> > the patch in case we agree to go this way.
> 
> Thanks, I'll look that over.
  Thanks.

> In looking at what we have today, I wonder if we can make things smarter
> so that we don't commit empty transactions in any case?
  Probably it does not make sence to commit such transactions and we might
save some time in sync paths if we do so. So yes, I think skipping empty
transaction commit might be worthwhile and it shouldn't be hard to do
either. But I'd give it serious testing just in case some unexpectedly
relies on this behaviour - wouldn't this interfere e.g. with sync
transaction batching autotuning code? Untested patch below...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From 3e1a8dc6a64fdce5c99d7edca0a2812178f7463c Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 19 Dec 2008 01:20:47 +0100
Subject: [PATCH] jbd2: Skip commit of a transaction without any buffers

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/commit.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index ebc667b..798e021 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -401,6 +401,21 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	J_ASSERT (commit_transaction->t_outstanding_credits <=
 			journal->j_max_transaction_buffers);
 
+	/* Skip commit of a transaction without any buffers */
+	spin_lock(&journal->j_list_lock);
+	if (commit_transaction->t_reserved_list == NULL &&
+	    commit_transaction->t_buffers == NULL &&
+	    commit_transaction->t_forget == NULL &&
+	    list_empty(commit_transaction->t_inode_list)) {
+		BUG_ON(commit_transaction->t_checkpoint_list);
+		BUG_ON(commit_transaction->t_checkpoint_io_list);
+		BUG_ON(commit_transaction->t_iobuf_list);
+		BUG_ON(commit_transaction->t_shadow_list);
+		BUG_ON(commit_transaction->t_log_list);
+		goto out_committed;
+	}
+	spin_unlock(&journal->j_list_lock);
+
 	/*
 	 * First thing we are allowed to do is to discard any remaining
 	 * BJ_Reserved buffers.  Note, it is _not_ permissible to assume
@@ -934,6 +949,7 @@ restart_loop:
 
 	/* Done with this transaction! */
 
+out_committed:
 	jbd_debug(3, "JBD: commit phase 7\n");
 
 	J_ASSERT(commit_transaction->t_state == T_COMMIT);
-- 
1.6.0.2

