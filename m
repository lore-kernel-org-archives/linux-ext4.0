From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] JBD:need hold j_state_lock to updates to transaction
	t_state to T_COMMIT
Date: Mon, 12 May 2008 11:34:27 +0200
Message-ID: <20080512093427.GA15856@duck.suse.cz>
References: <1209166706.6040.20.camel@localhost.localdomain> <20080428122626.GC17054@duck.suse.cz> <1209402694.23575.5.camel@badari-desktop> <20080428180932.GI17054@duck.suse.cz> <1209409764.11872.6.camel@localhost.localdomain> <20080429124321.GD1987@duck.suse.cz> <1209654981.27240.19.camel@badari-desktop> <20080505170636.GK25722@duck.suse.cz> <1210372072.3639.52.camel@localhost.localdomain> <1210372783.3639.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47307 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756777AbYELJe2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 05:34:28 -0400
Content-Disposition: inline
In-Reply-To: <1210372783.3639.63.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 09-05-08 15:39:43, Mingming Cao wrote:
> Updating the current transaction's t_state is being protected by j_state_lock.
> We need to do the same when updating the t_state to T_COMMIT.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
  Thanks for the fix. You can add
Acked-by: Jan Kara <jack@suse.cz>
(and also to the JBD2 patch)

										Honza
> ---
>  fs/jbd/commit.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6.26-rc1/fs/jbd/commit.c
> ===================================================================
> --- linux-2.6.26-rc1.orig/fs/jbd/commit.c	2008-05-09 14:46:25.000000000 -0700
> +++ linux-2.6.26-rc1/fs/jbd/commit.c	2008-05-09 15:11:00.000000000 -0700
> @@ -478,7 +478,9 @@ void journal_commit_transaction(journal_
>  	 * transaction!  Now comes the tricky part: we need to write out
>  	 * metadata.  Loop over the transaction's entire buffer list:
>  	 */
> +	spin_lock(&journal->j_state_lock);
>  	commit_transaction->t_state = T_COMMIT;
> +	spin_unlock(&journal->j_state_lock);
>  
>  	J_ASSERT(commit_transaction->t_nr_buffers <=
>  		 commit_transaction->t_outstanding_credits);
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
