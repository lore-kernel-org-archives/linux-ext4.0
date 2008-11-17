From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [RFC PATCH 1/1] Allow ext4 to run without a journal, take 2.
Date: Mon, 17 Nov 2008 09:20:58 -0800
Message-ID: <1226942458.23804.10.camel@bobble.smo.corp.google.com>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
	 <1226431111.4444.41.camel@bobble.smo.corp.google.com>
	 <20081117000445.GA3436@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:44633 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYKQRVI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 12:21:08 -0500
In-Reply-To: <20081117000445.GA3436@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'll address the comments in code in a bit but wanted to reply now.

On Sun, 2008-11-16 at 18:04 -0600, Andreas Dilger wrote:
> On Nov 11, 2008  11:18 -0800, Frank Mayhar wrote:
> > +static inline int ext4_handle_valid(handle_t *handle)
> > +{
> > +	if (!handle)
> > +		return 0;
> My preference is to use "if (handle == NULL)", because handle is not a
> boolean.

That's actually my preference as well, but I was trying to match other
parts of the code.  I'll change it.

> > +	if (handle->h_transaction == NULL)
> > +		return 0;
> 
> Does this ever happen?  Ah, is this the case where the handle is pointing
> to the ext4_sb_info()?  I think I'd prefer to have a magic value here,
> so that it isn't possible to accidentally dereference a pointer that
> happens to have NULL data in it.

So some magic value that gets stuffed into the pointer?  Or just a magic
pointer value that gets stuffed into 'handle'?

> > +static inline int ext4_handle_dirty_metadata(handle_t *handle,
> > +				struct inode *inode, struct buffer_head *bh)
> > +{
> > +	int err = 0;
> > +
> > +	if (ext4_handle_valid(handle)) {
> > +		err = __ext4_journal_dirty_metadata(__func__, handle, bh);
> > +	} else {
> > +		err = __ext4_write_dirty_metadata(inode, bh);
> > +	}
> 
> You don't need to initialize "err = 0" here.

Good point.

> >  struct ext4_sb_info {
> > +	int *s_nojournal_flag;		/* Null to indicate "not a handle" */
> 
> I don't really see where and how this is used.

Yeah, this is pretty opaque, I'm getting similar comments from the
internal reviewer.  This is how I was distinguishing the "pointer to a
real handle" from the "pointer to ext4_sb_info".

> > @@ -97,6 +97,8 @@
> >  {
> 
> Please, in the future use "diff -up" so that it includes the function
> names in the patch context.  Without the function names it is difficult
> to know what is being changed by the patch.

Sorry, I usually do that but forgot in this case.

> > @@ -4657,7 +4659,7 @@
> > -	if (metadata) {
> > +	if (ext4_handle_valid(handle) && metadata) {
> 
> It is probably a tiny bit more efficient to check "metadata" first.

OK.

> > @@ -136,13 +136,16 @@
> > +	if (journal) {
> > +		if (is_journal_aborted(journal)) {
> > +			ext4_abort(sb, __func__,
> > +				   "Detected aborted journal");
> > +			return ERR_PTR(-EROFS);
> > +		}
> > +		return jbd2_journal_start(journal, nblocks);
> >  	}
> > +	current->journal_info = (handle_t *)EXT4_SB(sb);
> > +	return current->journal_info;
> 
> So, this appears to be the place where ext4_sb_info->s_nojournal_flag is
> actually used.  To make this more clear, it would be better to do actually
> reference this variable here so that it is easier for the reader to follow.
> 
> 	current->journal_info = &EXT4_SB(sb)->s_nojournal_flag;

Hmm.  Okay, I'll have to think about this a bit; I haven't had my coffee
yet.

> > @@ -588,7 +599,8 @@
> >  	}
> >  #endif
> >  	ext4_discard_preallocations(inode);
> > +	if (EXT4_SB(inode->i_sb)->s_journal)
> 
> I think this is the same thing as EXT4_JOURNAL(inode)?

Yeah, I noticed this after the patch went out.

> >  static void ext4_write_super(struct super_block *sb)
> >  {
> > +	if (EXT4_SB(sb)->s_journal) {
> > +		if (mutex_trylock(&sb->s_lock) != 0)
> > +			BUG();
> > +		sb->s_dirt = 0;
> > +	}
> > +	else
> > +		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
> 
> This should be "} else { ... }"
> 
> > +			/*
> > +			 * We don't want to clear needs_recovery flag when we failed
> > +			 * to flush the journal.
> > +			 */
> > +			if (jbd2_journal_flush(journal) < 0)
> > +				return;
> 
> This comment needs to be wrapped at 80 columns.
> 
> 
> I like this patch a lot better than the previous one.  It remains very
> readable, and isn't too intrusive to the code.

Okay, thanks, and thanks for the comments.  I'll make the indicated
changes and roll another patch today.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

