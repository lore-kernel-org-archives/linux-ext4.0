From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix oops in jbd2_journal_remove_journal_head()
Date: Mon, 6 Jun 2011 10:16:30 -0400
Message-ID: <20110606141630.GK7180@thunk.org>
References: <1306768378-27748-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50437 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236Ab1FFOQj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 10:16:39 -0400
Content-Disposition: inline
In-Reply-To: <1306768378-27748-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 30, 2011 at 05:12:58PM +0200, Jan Kara wrote:
>  /*
> - * For the unlocked version of this call, also make sure that any
> - * hanging journal_head is cleaned up if necessary.
> + * For the unlocked version of this call, also drop buffer_head reference.
>   *
>   * __jbd2_journal_refile_buffer is usually called as part of a single locked
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Doesn't this paragraph refer to jbd2_journal_refile_buffer(), not
__jbd2_journal_refile_buffer()?  Or am I missing something?

>  void jbd2_journal_refile_buffer(journal_t *journal, struct journal_head *jh)
>  {
>  	struct buffer_head *bh = jh2bh(jh);
>  
> +	/* Get reference so that buffer cannot be freed before we unlock it */
> +	get_bh(bh);

OK, so we're adding a get_bh(bh) call to jbd2_journal_refile_buffer(),
which we're not freeing later in the function.  So this means every
single place where we call jbd2_journal_refile_buffer(), we'd better
add put_bh(bh) or bhrelse(bh) call, right?

So in fs/jbd2/commit.c, line 418, in jbd2_journal_commit_transaction(),
I see a call to jbd2_journal_refile_buffer(), which the patch doesn't
seem to adjust.  Looks like this could cause a buffer leak?

In your testing, have you checked to the slab cache to make sure there
isn't any memory leakage going on with buffer heads?

      	  	 	       	       - Ted
