From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] jbd2: Call the commit callback before the transaction
 could get dropped
Date: Mon, 27 Oct 2008 21:41:36 -0500
Message-ID: <49067BE0.8090904@redhat.com>
References: <1224612181.19719.20.camel@paris-laptop> <20081027181928.GB23111@mit.edu> <49064027.9010509@redhat.com> <20081027232843.GA9797@mit.edu> <49065805.1080303@redhat.com> <20081028015228.GA8320@mit.edu> <20081028022838.GA8869@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35145 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYJ1CmA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Oct 2008 22:42:00 -0400
In-Reply-To: <20081028022838.GA8869@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> This is what I plan to send to Linus to fix the problem.
> 
> commit 6fecbc3c7d27800e90a5f5fbca2fb2847e2c2854
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Mon Oct 27 22:11:39 2008 -0400
> 
>     jbd2: Call the commit callback before the transaction could get dropped
>     
>     The transaction can potentially get dropped if there are no buffers
>     that need to be written.  Make sure we call the commit callback before
>     potentially deciding to drop the transaction.  Also avoid
>     dereferencing the commit_transaction pointer in the marker for the
>     same reason.
>     
>     This patch fixes the bug reported by Eric Paris at:
>     http://bugzilla.kernel.org/show_bug.cgi?id=11838
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Acked-by: Eric Sandeen <sandeen@redhat.com>

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

