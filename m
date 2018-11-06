Return-Path: <SRS0=hSPz=NR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44622 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389227AbeKGCOJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Nov 2018 21:14:09 -0500
Date: Tue, 6 Nov 2018 11:47:59 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] jbd2: Avoid long hold times of j_state_lock while
 committing a transaction
Message-ID: <20181106164759.GE6416@thunk.org>
References: <20181016094248.21359-1-jack@suse.cz>
 <20181106052051.GD6416@thunk.org>
 <20181106102230.GC25414@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106102230.GC25414@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 06, 2018 at 11:22:30AM +0100, Jan Kara wrote:
>> So the buffer is on BJ_Shadow list while the assertion in
> jbd2_journal_dirty_metadata() expects it to be in BJ_Metadata list. This is
> really weird as we have also checked that jh->b_transaction ==
> handle->h_transaction so the transaction couldn't have passed to commit
> phase... Oh, I see, the code in start_this_handle() got racy with the
> removal of j_state_lock protection from journal_commit_transaction() so now
> transaction can start even though there are handles outstanding! I'll think
> about the best solution for this. Thanks for report!

Thanks for the analysis!  I finished the bisection last night and it
was too late for me to dive into how this was going on.  I should have
realized this before I had suggested the approach in the patch.

The original complaint which Andrian made was that the long hold times
of j_state_lock at the beginning of the commit.  What he didn't
mention was what the other "high priority tasks" were blocked on, but
they were almost certainly start_this_handle.  And that's fundamental;
when we are trying to at the beginning of the commit process is
waiting for the outstanding handles to close; and so we can't let new
handles start.

What we can do is to try to decrease the handle hold times.  This is
why we track the handle type and we have the jbd2_handle_stats
tracepoint.  If we can find that handles of a particular type and a
particular line number are the ones which are taking more time than
other handles, we can try to make them run faster; for example, by
pre-reading blocks aren't in the buffer cache before starting the
handle.

The other thing which we can probably do is to for truncate handles,
if we notice that current_transaction->t_state == T_LOCKED, we can
suspend the truncation activity and close the handle, and then resume
it (which will block until a new transaction is ready to be started).

   	       	     	     	 	     - Ted
