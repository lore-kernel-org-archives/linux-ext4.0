From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] jbd2: preserve original nofs flag during journal
 restart
Date: Thu, 18 May 2017 11:39:39 +0200
Message-ID: <20170518093939.GD9084@quack2.suse.cz>
References: <20170517152432.GA20660@dhcp22.suse.cz>
 <20170517161629.15170-1-tahsin@google.com>
 <20170518091253.GE25462@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tahsin Erdogan <tahsin@google.com>, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40115 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752689AbdERJjm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 May 2017 05:39:42 -0400
Content-Disposition: inline
In-Reply-To: <20170518091253.GE25462@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-05-17 11:12:53, Michal Hocko wrote:
> On Wed 17-05-17 09:16:29, Tahsin Erdogan wrote:
> [...]
> > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > index 9ee4832b6f8b..05c0323493fb 100644
> > --- a/fs/jbd2/transaction.c
> > +++ b/fs/jbd2/transaction.c
> > @@ -680,6 +680,8 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
> > 
> >  	rwsem_release(&journal->j_trans_commit_map, 1, _THIS_IP_);
> >  	handle->h_buffer_credits = nblocks;
> > +	/* Restore original nofs flag as jbd2_journal_stop() would do. */
> 
> I was thinking something more specific like
> 	/*
> 	 * Restore the original nofs context because the journal restart
> 	 * is basically the same thing as journal stop and start.
> 	 * start_this_handle will start a new nofs context.
> 	 */

Yeah, this is much better. Tahsin, please use Michal's version. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
