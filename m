From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5] ocfs2: Update ocfs2 routines to use the updated
 journal routines to specify gfp_mask for transaction allocation.
Date: Wed, 11 May 2011 17:56:15 +0200
Message-ID: <20110511155615.GI5057@quack.suse.cz>
References: <BANLkTi=H5zs9KnrUtXd=Q4uz3rTFGzfqhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Manish Katiyar <manish.katiyar@in.ibm.com>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197Ab1EKP4R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2011 11:56:17 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi=H5zs9KnrUtXd=Q4uz3rTFGzfqhg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 24-04-11 17:15:35, Manish Katiyar wrote:
> Update ocfs2 routines to use the updated journal routines passing an
> extra parameter to specify whether transaction allocation can fail or
> not.
  This should be included in the first patch. Also I don't think there's a
need for special helpers since they are called from one / two sites anyway.

								Honza 
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ocfs2/journal.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index b141a44..51c60be 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -338,6 +338,16 @@ finally:
>  	return status;
>  }
> 
> +static handle_t *ocfs2_journal_start(journal_t *journal, int blocks)
> +{
> +	return jbd2_journal_start(journal, blocks, false);
> +}
> +
> +static int ocfs2_journal_restart(handle_t *handle, int blocks)
> +{
> +	return jbd2_journal_restart(handle, blocks, false);
> +}
> +
>  handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
>  {
>  	journal_t *journal = osb->journal->j_journal;
> @@ -353,11 +363,11 @@ handle_t *ocfs2_start_trans(struct ocfs2_super
> *osb, int max_buffs)
> 
>  	/* Nested transaction? Just return the handle... */
>  	if (journal_current_handle())
> -		return jbd2_journal_start(journal, max_buffs);
> +		return ocfs2_journal_start(journal, max_buffs);
> 
>  	down_read(&osb->journal->j_trans_barrier);
> 
> -	handle = jbd2_journal_start(journal, max_buffs);
> +	handle = ocfs2_journal_start(journal, max_buffs);
>  	if (IS_ERR(handle)) {
>  		up_read(&osb->journal->j_trans_barrier);
> 
> @@ -437,7 +447,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
> 
>  	if (status > 0) {
>  		trace_ocfs2_extend_trans_restart(old_nblocks + nblocks);
> -		status = jbd2_journal_restart(handle,
> +		status = ocfs2_journal_restart(handle,
>  					      old_nblocks + nblocks);
>  		if (status < 0) {
>  			mlog_errno(status);
> -- 
> 1.7.1
> 
> 
> -- 
> Thanks -
> Manish

> From bb95830b270fce043b5b901d53d391189ee96878 Mon Sep 17 00:00:00 2001
> From: Manish Katiyar <mkatiyar@gmail.com>
> Date: Sun, 24 Apr 2011 00:27:31 -0700
> Subject: [PATCH 3/5] Update ocfs routines to use the updated journal routines passing an extra parameter to specify whether transaction allocation can fail or not.
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ocfs2/journal.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index b141a44..51c60be 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -338,6 +338,16 @@ finally:
>  	return status;
>  }
>  
> +static handle_t *ocfs2_journal_start(journal_t *journal, int blocks)
> +{
> +	return jbd2_journal_start(journal, blocks, false);
> +}
> +
> +static int ocfs2_journal_restart(handle_t *handle, int blocks)
> +{
> +	return jbd2_journal_restart(handle, blocks, false);
> +}
> +
>  handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
>  {
>  	journal_t *journal = osb->journal->j_journal;
> @@ -353,11 +363,11 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
>  
>  	/* Nested transaction? Just return the handle... */
>  	if (journal_current_handle())
> -		return jbd2_journal_start(journal, max_buffs);
> +		return ocfs2_journal_start(journal, max_buffs);
>  
>  	down_read(&osb->journal->j_trans_barrier);
>  
> -	handle = jbd2_journal_start(journal, max_buffs);
> +	handle = ocfs2_journal_start(journal, max_buffs);
>  	if (IS_ERR(handle)) {
>  		up_read(&osb->journal->j_trans_barrier);
>  
> @@ -437,7 +447,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
>  
>  	if (status > 0) {
>  		trace_ocfs2_extend_trans_restart(old_nblocks + nblocks);
> -		status = jbd2_journal_restart(handle,
> +		status = ocfs2_journal_restart(handle,
>  					      old_nblocks + nblocks);
>  		if (status < 0) {
>  			mlog_errno(status);
> -- 
> 1.7.1
> 

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
