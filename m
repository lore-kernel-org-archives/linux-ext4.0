From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3 can fail badly when device stops accepting BIO_RW_BARRIER requests.
Date: Thu, 7 Feb 2008 11:58:54 +0100
Message-ID: <20080207105853.GC26403@atrey.karlin.mff.cuni.cz>
References: <18346.24466.83745.944149@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39257 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156AbYBGK6z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2008 05:58:55 -0500
Content-Disposition: inline
In-Reply-To: <18346.24466.83745.944149@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Neil,

> Some devices - notably dm and md - can change their behaviour in
> response to BIO_RW_BARRIER requests.  They might start out accepting
> such requests but on reconfiguration, they find out that they cannot
> any more.
> 
> ext3 (and other filesystems) deal with this by always testing if
> BIO_RW_BARRIER requests fail with EOPNOTSUPP, and retrying the write
> requests without the barrier (probably after waiting for any pending
> writes to complete).
> 
> However there is a bug in the handling for this for ext3.
> 
> When ext3 (jbd actually) decides to submit a BIO_RW_BARRIER request,
> it sets the buffer_ordered flag on the buffer head.
> If the request completes successfully, the flag STAYS SET.
  Yes, I've recently noted this as well :) 

> Other code might then write the same buffer_head after the device has
> been reconfigured to not accept barriers.  This write will then fail,
> but the "other code" is not ready to handle EOPNOTSUPP errors and the
> error will be treated as fatal.
> 
> This can be seen without having to reconfigure a device at exactly the
> wrong time by putting:
> 
> 		if (buffer_ordered(bh))
> 			printk("OH DEAR, and ordered buffer\n");
> 
> 
> in the while loop in "commit phase 5" of journal_commit_transaction.
> 
> If it ever prints the "OH DEAR ..." message (as it does sometimes for
> me), then that request could (in different circumstances) have failed
> with EOPNOTSUPP, but that isn't tested for.
> 
> My proposed fix is to clear the buffer_ordered flag after it has been
> used, as in the following patch.
  Yes. Actually, I think there's another bug in there as well - at least
I have bugreport where we obviously miss that writing ordered buffer
failed (I see completion function of the buffer return with eopnotsupp
bit set but barriers aren't disabled). I think someone starts writing
out the buffer before we call sync_dirty_buffer(bh) but I'm not completely
sure who can do this when we just do set_buffer_dirty(bh)... Anyway
before I check that it is indeed happening what I think is happening,
your fix is fine :).
  You can add: Acked-by: Jan Kara <jack@suse.cz>

> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> diff .prev/fs/jbd/commit.c ./fs/jbd/commit.c
> --- .prev/fs/jbd/commit.c	2008-02-07 10:01:57.000000000 +1100
> +++ ./fs/jbd/commit.c	2008-02-07 10:04:58.000000000 +1100
> @@ -131,6 +131,8 @@ static int journal_write_commit_record(j
>  		barrier_done = 1;
>  	}
>  	ret = sync_dirty_buffer(bh);
> +	if (barrier_done)
> +		clear_buffer_ordered(bh);
>  	/* is it possible for another commit to fail at roughly
>  	 * the same time as this one?  If so, we don't want to
>  	 * trust the barrier flag in the super, but instead want
> @@ -148,7 +150,6 @@ static int journal_write_commit_record(j
>  		spin_unlock(&journal->j_state_lock);
>  
>  		/* And try again, without the barrier */
> -		clear_buffer_ordered(bh);
>  		set_buffer_uptodate(bh);
>  		set_buffer_dirty(bh);
>  		ret = sync_dirty_buffer(bh);


								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
