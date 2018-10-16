Return-Path: <SRS0=eFe4=M4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726541AbeJPRkC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 Oct 2018 13:40:02 -0400
Date: Tue, 16 Oct 2018 11:50:22 +0200
From: Jan Kara <jack@suse.cz>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jan Kara <jack@suse.cz>, "Theodore Y. Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: jbd2_clear_buffer_revoked_flags() takes a long time
Message-ID: <20181016095022.GD18918@quack2.suse.cz>
References: <d2e1ec1a-0d7d-1acb-6887-c55ac30e4a3a@intel.com>
 <20181010174934.GA19601@thunk.org>
 <20181011111223.GD9467@quack2.suse.cz>
 <a70df9c2-ef85-cc0a-4442-64c8c7b15ea5@intel.com>
 <478e7436-01c9-9501-f971-d8a8cf68dad9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478e7436-01c9-9501-f971-d8a8cf68dad9@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-10-18 11:49:45, Adrian Hunter wrote:
> On 11/10/18 3:38 PM, Adrian Hunter wrote:
> > On 11/10/18 2:12 PM, Jan Kara wrote:
> >> On Wed 10-10-18 13:49:34, Theodore Y. Ts'o wrote:
> >>> On Wed, Oct 10, 2018 at 04:43:27PM +0300, Adrian Hunter wrote:
> >>>> Hi
> >>>>
> >>>> I have a case on a v4.14 kernel where the EXT4 journal commit disables
> >>>> preemption for 30ms due to jbd2_clear_buffer_revoked_flags().  That in turn
> >>>> disables preemption on other CPUs as they come to spin waiting for the same
> >>>> lock.  The side-effect of that is that it periodically blocks high priority
> >>>> tasks from running.
> >>>>
> >>>> I see jbd2_clear_buffer_revoked_flags() iterating 32768 times calling
> >>>> __find_get_block().
> >>>>
> >>>> Is there any way to make jbd2_clear_buffer_revoked_flags() take less time,
> >>>> or move its work out from under write_lock(&journal->j_state_lock)?
> >>> Hmm.... I'd have to look a bit more carefully and then run some tests,
> >>> but I *think* we can drop the j_state_lock at the beginning of JBD2
> >>> commit phase 1, and then grab it again right before we set
> >>> commit_transaction->t_state to T_FLUSH.
> >>>
> >>> That should be safe because while the transaction state is T_LOCKED,
> >>> we can't start any new handles, so there can't be any new blocks added
> >>> to the revoke table.
> >>>
> >>> Can you give that a try and see whether that solves your priority
> >>> inversion problem?
> >> Agreed. Something like attached patch (compile-tested only)?
> > 
> > I have been testing a patch with the unlock/lock at slightly different
> > positions, and it definitely helps.  The incidence of my problem drops from
> > nearly every writeback, to a few an hour.  I haven't had time to find out
> > what is causing the remaining cases yet - it may not be related to EXT4.  I
> > should be able to test this patch tomorrow.
> 
> Thanks very much for the quick response and patch!
> 
> Tested-by: Adrian Hunter <adrian.hunter@intel.com>

Thanks. I've officially posted the patch.

> With more stress I also found move_expired_inodes()
> (wb_writeback->queue_io->move_expired_inodes) to take up to 16ms using
> 230,000 branches while under spin lock.  AFAICT we weren't hitting that in
> practice so I am not following it up at this stage.

Interesting. I actually have a patch simplifying that area as well sitting
in some branch in my tree. So I can dust it off if you are interested.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
