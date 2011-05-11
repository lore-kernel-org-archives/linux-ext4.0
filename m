From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] jbd2: Pass extra bool parameter in journal
 routines to specify if its ok to fail the journal transaction allocation.
Date: Wed, 11 May 2011 17:54:47 +0200
Message-ID: <20110511155447.GH5057@quack.suse.cz>
References: <BANLkTinNUxt_Bj0JErLVDbh=73JHzzS9=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab1EKPyt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2011 11:54:49 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinNUxt_Bj0JErLVDbh=73JHzzS9=w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  sorry I got to your patches with a delay. One general note - please do
not attach patches. It is enough to have them in the email...

On Sun 24-04-11 17:10:41, Manish Katiyar wrote:
> Pass extra bool parameter in journal routines to specify if its ok to
> fail the journal transaction allocation. If 'true' is passed
> transaction allocation is done through GFP_KERNEL  and ENOMEM is
> returned else GFP_NOFS is used.
  Please, do not mix error handling with gfp masks. Instead just rename
jbd2__journal_start() to jbd2_journal_start() and change gfp_mask parameter
to "bool errok". Use GFP_NOFS gfp mask for start_this_handle(). Noone
uses jbd2__journal_start() and it was mainly added to make it possible to
specify that start_this_handle() can fail but IMHO it's a hack.

Also your patch series should be bisectable - that means it must compile
and run after any of the patches. So you cannot really change
jbd2_journal_start() prototype without changing all the filesystems using
it. In this case, just include in this patch a simple change for ext4 and
ocfs2 to pass 'false' in the additional argument.

								Honza

> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/jbd2/transaction.c |   12 +++++++-----
>  include/linux/jbd2.h  |    4 ++--
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 05fa77a..b02d6a4 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -349,9 +349,10 @@ handle_t *jbd2__journal_start(journal_t *journal,
> int nblocks, int gfp_mask)
>  EXPORT_SYMBOL(jbd2__journal_start);
> 
> 
> -handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
> +handle_t *jbd2_journal_start(journal_t *journal, int nblocks, bool errok)
>  {
> -	return jbd2__journal_start(journal, nblocks, GFP_NOFS);
> +	return jbd2__journal_start(journal, nblocks,
> +				   errok ? GFP_KERNEL : GFP_NOFS);
>  }
>  EXPORT_SYMBOL(jbd2_journal_start);
> 
> @@ -483,9 +484,10 @@ int jbd2__journal_restart(handle_t *handle, int
> nblocks, int gfp_mask)
>  EXPORT_SYMBOL(jbd2__journal_restart);
> 
> 
> -int jbd2_journal_restart(handle_t *handle, int nblocks)
> +int jbd2_journal_restart(handle_t *handle, int nblocks, bool errok)
>  {
> -	return jbd2__journal_restart(handle, nblocks, GFP_NOFS);
> +	return jbd2__journal_restart(handle, nblocks,
> +				     errok ? GFP_KERNEL : GFP_NOFS);
>  }
>  EXPORT_SYMBOL(jbd2_journal_restart);
> 
> @@ -1436,7 +1438,7 @@ int jbd2_journal_force_commit(journal_t *journal)
>  	handle_t *handle;
>  	int ret;
> 
> -	handle = jbd2_journal_start(journal, 1);
> +	handle = jbd2_journal_start(journal, 1, false);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
>  	} else {
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index a32dcae..a64aced 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1103,9 +1103,9 @@ static inline handle_t *journal_current_handle(void)
>   * Register buffer modifications against the current transaction.
>   */
> 
> -extern handle_t *jbd2_journal_start(journal_t *, int nblocks);
> +extern handle_t *jbd2_journal_start(journal_t *, int nblocks, bool errok);
>  extern handle_t *jbd2__journal_start(journal_t *, int nblocks, int gfp_mask);
> -extern int	 jbd2_journal_restart(handle_t *, int nblocks);
> +extern int	 jbd2_journal_restart(handle_t *, int nblocks, bool errok);
>  extern int	 jbd2__journal_restart(handle_t *, int nblocks, int gfp_mask);
>  extern int	 jbd2_journal_extend (handle_t *, int nblocks);
>  extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
> -- 
> 1.7.1
> 
> 
> -- 
> Thanks -
> Manish

> From c9edbd8d1da02ada2615acec3e3083b4669f6d9e Mon Sep 17 00:00:00 2001
> From: Manish Katiyar <mkatiyar@gmail.com>
> Date: Sun, 24 Apr 2011 00:14:54 -0700
> Subject: [PATCH 1/5] Pass extra bool parameter in journal routines to specify if its ok to fail the journal transaction allocation. If 'true' is passed transaction allocation is done through GFP_KERNEL else GFP_NOFS is used.
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/jbd2/transaction.c |   12 +++++++-----
>  include/linux/jbd2.h  |    4 ++--
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 05fa77a..b02d6a4 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -349,9 +349,10 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
>  EXPORT_SYMBOL(jbd2__journal_start);
>  
>  
> -handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
> +handle_t *jbd2_journal_start(journal_t *journal, int nblocks, bool errok)
>  {
> -	return jbd2__journal_start(journal, nblocks, GFP_NOFS);
> +	return jbd2__journal_start(journal, nblocks,
> +				   errok ? GFP_KERNEL : GFP_NOFS);
>  }
>  EXPORT_SYMBOL(jbd2_journal_start);
>  
> @@ -483,9 +484,10 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mask)
>  EXPORT_SYMBOL(jbd2__journal_restart);
>  
>  
> -int jbd2_journal_restart(handle_t *handle, int nblocks)
> +int jbd2_journal_restart(handle_t *handle, int nblocks, bool errok)
>  {
> -	return jbd2__journal_restart(handle, nblocks, GFP_NOFS);
> +	return jbd2__journal_restart(handle, nblocks,
> +				     errok ? GFP_KERNEL : GFP_NOFS);
>  }
>  EXPORT_SYMBOL(jbd2_journal_restart);
>  
> @@ -1436,7 +1438,7 @@ int jbd2_journal_force_commit(journal_t *journal)
>  	handle_t *handle;
>  	int ret;
>  
> -	handle = jbd2_journal_start(journal, 1);
> +	handle = jbd2_journal_start(journal, 1, false);
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
>  	} else {
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index a32dcae..a64aced 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1103,9 +1103,9 @@ static inline handle_t *journal_current_handle(void)
>   * Register buffer modifications against the current transaction.
>   */
>  
> -extern handle_t *jbd2_journal_start(journal_t *, int nblocks);
> +extern handle_t *jbd2_journal_start(journal_t *, int nblocks, bool errok);
>  extern handle_t *jbd2__journal_start(journal_t *, int nblocks, int gfp_mask);
> -extern int	 jbd2_journal_restart(handle_t *, int nblocks);
> +extern int	 jbd2_journal_restart(handle_t *, int nblocks, bool errok);
>  extern int	 jbd2__journal_restart(handle_t *, int nblocks, int gfp_mask);
>  extern int	 jbd2_journal_extend (handle_t *, int nblocks);
>  extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
> -- 
> 1.7.1
> 

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
