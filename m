Return-Path: <SRS0=hSPz=NR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388987AbeKGCrd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Nov 2018 21:47:33 -0500
Date: Tue, 6 Nov 2018 18:21:19 +0100
From: Jan Kara <jack@suse.cz>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] jbd2: Avoid long hold times of j_state_lock while
 committing a transaction
Message-ID: <20181106172119.GB19413@quack2.suse.cz>
References: <20181016094248.21359-1-jack@suse.cz>
 <20181106052051.GD6416@thunk.org>
 <20181106102230.GC25414@quack2.suse.cz>
 <20181106164759.GE6416@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106164759.GE6416@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 06-11-18 11:47:59, Theodore Y. Ts'o wrote:
> On Tue, Nov 06, 2018 at 11:22:30AM +0100, Jan Kara wrote:
> >> So the buffer is on BJ_Shadow list while the assertion in
> > jbd2_journal_dirty_metadata() expects it to be in BJ_Metadata list. This is
> > really weird as we have also checked that jh->b_transaction ==
> > handle->h_transaction so the transaction couldn't have passed to commit
> > phase... Oh, I see, the code in start_this_handle() got racy with the
> > removal of j_state_lock protection from journal_commit_transaction() so now
> > transaction can start even though there are handles outstanding! I'll think
> > about the best solution for this. Thanks for report!
> 
> Thanks for the analysis!  I finished the bisection last night and it
> was too late for me to dive into how this was going on.  I should have
> realized this before I had suggested the approach in the patch.
> 
> The original complaint which Andrian made was that the long hold times
> of j_state_lock at the beginning of the commit.  What he didn't
> mention was what the other "high priority tasks" were blocked on, but
> they were almost certainly start_this_handle.  And that's fundamental;
> when we are trying to at the beginning of the commit process is
> waiting for the outstanding handles to close; and so we can't let new
> handles start.

As Adrian mentioned, the problem is really with j_state_lock hold times,
not with waiting for outstanding handles as such (because that happens with
j_state_lock droppped). And the holding of j_state_lock while checking
for outstanding handles is not a real source of latency so we can keep
that. We just have to introduce new transaction state so that once we have
checked there are no outstanding handles and are going to drop
j_state_lock, we switch to this new state to prevent new reserved handles
from joining the transaction. I'll send a patch tomorrow...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
