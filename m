From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: general protection fault:  from release_blocks_on_commit
Date: Mon, 27 Oct 2008 21:15:32 -0500
Message-ID: <490675C4.3040208@redhat.com>
References: <1224612181.19719.20.camel@paris-laptop> <20081027181928.GB23111@mit.edu> <49064027.9010509@redhat.com> <20081027232843.GA9797@mit.edu> <49065805.1080303@redhat.com> <20081028015228.GA8320@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47601 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYJ1CQK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Oct 2008 22:16:10 -0400
In-Reply-To: <20081028015228.GA8320@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> I looked at this some more, and at least in theory it could happen
> that we could not have any buffers that need to be checkpointed (so
> t_checkpoint_list and t_checkpoint_io_list are NULL), but there are
> still blocks to be released (or some other users of the jbd2 layer
> still wants to have the callback be called).  So I'm currently testing
> this patch (see below).
> 
> 							- Ted

Looks reasonable to me from a correctness perspective, anyway, as long
as holding the j_list_lock over that callback is ok.

It does fix the oops-on-reboot that I could reproduce.

-Eric


> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 8b119e1..ebc667b 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -974,6 +974,9 @@ restart_loop:
>  	journal->j_committing_transaction = NULL;
>  	spin_unlock(&journal->j_state_lock);
>  
> +	if (journal->j_commit_callback)
> +		journal->j_commit_callback(journal, commit_transaction);
> +
>  	if (commit_transaction->t_checkpoint_list == NULL &&
>  	    commit_transaction->t_checkpoint_io_list == NULL) {
>  		__jbd2_journal_drop_transaction(journal, commit_transaction);
> @@ -995,11 +998,8 @@ restart_loop:
>  	}
>  	spin_unlock(&journal->j_list_lock);
>  
> -	if (journal->j_commit_callback)
> -		journal->j_commit_callback(journal, commit_transaction);
> -
>  	trace_mark(jbd2_end_commit, "dev %s transaction %d head %d",
> -		   journal->j_devname, commit_transaction->t_tid,
> +		   journal->j_devname, journal->j_commit_sequence,
>  		   journal->j_tail_sequence);
>  	jbd_debug(1, "JBD: commit %d complete, head %d\n",
>  		  journal->j_commit_sequence, journal->j_tail_sequence);

