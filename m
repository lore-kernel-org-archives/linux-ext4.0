From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4 can fail badly when device stops accepting
	BIO_RW_BARRIER requests.
Date: Thu, 07 Feb 2008 16:22:37 -0800
Message-ID: <1202430157.3840.14.camel@localhost.localdomain>
References: <18346.24466.83745.944149@notabene.brown>
	 <1202358321.6497.5.camel@norville.austin.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Neil Brown <neilb@suse.de>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48890 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761402AbYBHAWk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2008 19:22:40 -0500
In-Reply-To: <1202358321.6497.5.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-02-06 at 22:25 -0600, Dave Kleikamp wrote:
> Duplicating Neil Brown's jbd patch for jbd2.  I guess this can go
> through the ext4 queue rather than straight into -mm.
> 
Checked-in.

Thanks Shaggy and Neil.

Mingming

> Neil's text:
> 
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
> 
> Other code might then write the same buffer_head after the device has
> been reconfigured to not accept barriers.  This write will then fail,
> but the "other code" is not ready to handle EOPNOTSUPP errors and the
> error will be treated as fatal.
> 
> This can be seen without having to reconfigure a device at exactly the
> wrong time by putting:
> 
>                 if (buffer_ordered(bh))
>                         printk("OH DEAR, and ordered buffer\n");
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
> 
> Thanks,
> NeilBrown
> 
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> 
> diff -Nurp linux-2.6.24-mm1/fs/jbd2/commit.c linux/fs/jbd2/commit.c
> --- linux-2.6.24-mm1/fs/jbd2/commit.c	2008-02-04 09:08:44.000000000 -0600
> +++ linux/fs/jbd2/commit.c	2008-02-06 22:11:14.000000000 -0600
> @@ -148,6 +148,8 @@ static int journal_submit_commit_record(
>  		barrier_done = 1;
>  	}
>  	ret = submit_bh(WRITE, bh);
> +	if (barrier_done)
> +		clear_buffer_ordered(bh);
> 
>  	/* is it possible for another commit to fail at roughly
>  	 * the same time as this one?  If so, we don't want to
> @@ -166,7 +168,6 @@ static int journal_submit_commit_record(
>  		spin_unlock(&journal->j_state_lock);
> 
>  		/* And try again, without the barrier */
> -		clear_buffer_ordered(bh);
>  		set_buffer_uptodate(bh);
>  		set_buffer_dirty(bh);
>  		ret = submit_bh(WRITE, bh);
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
