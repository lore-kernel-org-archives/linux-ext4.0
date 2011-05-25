From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] jbd2 : Fix journal start by passing a parameter to
 specify if the caller can deal with ENOMEM
Date: Wed, 25 May 2011 09:44:57 +0200
Message-ID: <20110525074457.GA4427@quack.suse.cz>
References: <4DDCAF18.8030809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, jack@suse.cz, linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab1EYHo7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 03:44:59 -0400
Content-Disposition: inline
In-Reply-To: <4DDCAF18.8030809@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 25-05-11 00:26:16, Manish Katiyar wrote:
> Pass extra bool parameter in journal routines to specify if its ok to
> fail in the journal start. Passing true means caller is
> ok with journal start failures and can handle ENOMEM. Update ocfs2 and ext4
> routines to pass false for the updated journal interface by default to
> retain the existing behavior.
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> Acked-by: Jan Kara <jack@suse.cz>
...
> @@ -318,7 +320,7 @@ static handle_t *new_handle(int nblocks)
>   *
>   * Return a pointer to a newly allocated handle, or NULL on failure
>   */
> -handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
> +handle_t *jbd2_journal_start(journal_t *journal, int nblocks, bool errok)
>  {
>  	handle_t *handle = journal_current_handle();
>  	int err;
> @@ -338,7 +340,7 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
> 
>  	current->journal_info = handle;
> 
> -	err = start_this_handle(journal, handle, gfp_mask);
> +	err = start_this_handle(journal, handle, GFP_NOFS);
>  	if (err < 0) {
>  		jbd2_free_handle(handle);
>  		current->journal_info = NULL;
  This patch is OK as such but as I wrote in a reply to a later patch in
the series, you also need to pass 'errok' to start_this_handle() instead of
gfp_mask as well. Then in start_this_handle() you can use 'errok' to decide
whether we should retry the allocation or not instead of gfp_mask. And just
call kzalloc in start_this_handle() with GFP_NOFS... Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
