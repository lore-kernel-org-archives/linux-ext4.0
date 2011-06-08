From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Fix oops in jbd2_journal_remove_journal_head()
Date: Wed, 8 Jun 2011 21:31:42 +0200
Message-ID: <20110608193142.GH5361@quack.suse.cz>
References: <1306768378-27748-1-git-send-email-jack@suse.cz>
 <20110606141630.GK7180@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab1FHTbp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2011 15:31:45 -0400
Content-Disposition: inline
In-Reply-To: <20110606141630.GK7180@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 06-06-11 10:16:30, Ted Tso wrote:
> On Mon, May 30, 2011 at 05:12:58PM +0200, Jan Kara wrote:
> >  /*
> > - * For the unlocked version of this call, also make sure that any
> > - * hanging journal_head is cleaned up if necessary.
> > + * For the unlocked version of this call, also drop buffer_head reference.
> >   *
> >   * __jbd2_journal_refile_buffer is usually called as part of a single locked
>      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Doesn't this paragraph refer to jbd2_journal_refile_buffer(), not
> __jbd2_journal_refile_buffer()?  Or am I missing something?
  Hmm, the comment seems to be wrong. The comment about buffer_head
reference does not apply anymore. I'll fix that.

> >  void jbd2_journal_refile_buffer(journal_t *journal, struct journal_head *jh)
> >  {
> >  	struct buffer_head *bh = jh2bh(jh);
> >  
> > +	/* Get reference so that buffer cannot be freed before we unlock it */
> > +	get_bh(bh);
> 
> OK, so we're adding a get_bh(bh) call to jbd2_journal_refile_buffer(),
> which we're not freeing later in the function.  So this means every
> single place where we call jbd2_journal_refile_buffer(), we'd better
> add put_bh(bh) or bhrelse(bh) call, right?
Well, we are adding get_bh() but we are now also using
jbd2_journal_put_journal_head() instead of
jbd2_journal_remove_journal_head() and the former call does additional
__brelse().

Probably a better way to look at this is that
jbd2_journal_remove_journal_head() now gets a reference and puts it at the
end of that function. jbd2_journal_put_journal_head() cares about releasing
bh reference held by journal_head. So the logic ends up being simpler than
it used to be.

> So in fs/jbd2/commit.c, line 418, in jbd2_journal_commit_transaction(),
> I see a call to jbd2_journal_refile_buffer(), which the patch doesn't
> seem to adjust.  Looks like this could cause a buffer leak?
> 
> In your testing, have you checked to the slab cache to make sure there
> isn't any memory leakage going on with buffer heads?
  Not really - I now ran fsxlinux and fsstress and both the number of
buffer_head and journal_head slabs seem to be under control.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
