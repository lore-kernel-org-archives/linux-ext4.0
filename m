From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH] ext4: Make non-journal fsync work properly. REPOST
Date: Mon, 14 Sep 2009 10:43:22 -0700
Message-ID: <1252950202.17515.11.camel@bobble.smo.corp.google.com>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
	 <20090908050614.GA10477@mit.edu>
	 <1252424465.17646.7.camel@bobble.smo.corp.google.com>
	 <20090908220504.GS22901@mit.edu>
	 <1252517664.18594.3.camel@bobble.smo.corp.google.com>
	 <20090914165413.GA4375@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:38878 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZINRna (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Sep 2009 13:43:30 -0400
In-Reply-To: <20090914165413.GA4375@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-09-14 at 22:24 +0530, Aneesh Kumar K.V wrote:
> On Wed, Sep 09, 2009 at 10:34:24AM -0700, Frank Mayhar wrote:
> > Teach ext4_write_inode() and ext4_do_update_inode() about non-journal
> > mode:  If we're not using a journal, ext4_write_inode() now calls
> > ext4_do_update_inode() (after getting the iloc via ext4_get_inode_loc())
> > with a new "do_sync" parameter.  If that parameter is nonzero _and_ we're
> > not using a journal, ext4_do_update_inode() calls sync_dirty_buffer()
> > instead of ext4_handle_dirty_metadata().
> > 
> > This problem was found in power-fail testing, checking the amount of
> > loss of files and blocks after a power failure when using fsync() and
> > when not using fsync().  It turned out that using fsync() was actually
> > worse than not doing so, possibly because it increased the likelihood
> > that the inodes would remain unflushed and would therefore be lost at
> > the power failure.
> > 
> > Signed-off-by: Frank Mayhar <fmayhar@google.com>
> > 
> >  fs/ext4/inode.c |   54 ++++++++++++++++++++++++++++++++++++++++--------------
> >  1 files changed, 40 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index d87f6a0..ef2e780 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -4741,7 +4741,8 @@ static int ext4_inode_blocks_set(handle_t *handle,
> >   */
> >  static int ext4_do_update_inode(handle_t *handle,
> >  				struct inode *inode,
> > -				struct ext4_iloc *iloc)
> > +				struct ext4_iloc *iloc,
> > +				int do_sync)
> >  {
> >  	struct ext4_inode *raw_inode = ext4_raw_inode(iloc);
> >  	struct ext4_inode_info *ei = EXT4_I(inode);
> > @@ -4843,10 +4844,22 @@ static int ext4_do_update_inode(handle_t *handle,
> >  		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
> >  	}
> > 
> > -	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> > -	rc = ext4_handle_dirty_metadata(handle, inode, bh);
> > -	if (!err)
> > -		err = rc;
> > +	/*
> > +	 * If we're not using a journal and we were called from
> > +	 * ext4_write_inode() to sync the inode (making do_sync true),
> > +	 * we can just use sync_dirty_buffer() directly to do our dirty
> > +	 * work.  Testing s_journal here is a bit redundant but it's
> > +	 * worth it to avoid potential future trouble.
> > +	 */
> > +	if (EXT4_SB(inode->i_sb)->s_journal == NULL && do_sync) {
> > +		BUFFER_TRACE(bh, "call sync_dirty_buffer");
> > +		sync_dirty_buffer(bh);
> > +	} else {
> > +		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> > +		rc = ext4_handle_dirty_metadata(handle, inode, bh);
> > +		if (!err)
> > +			err = rc;
> > +	}
> >  	ei->i_state &= ~EXT4_STATE_NEW;
> > 
> >  out_brelse:
> > @@ -4892,19 +4905,32 @@ out_brelse:
> >   */
> >  int ext4_write_inode(struct inode *inode, int wait)
> >  {
> > +	int err;
> > +
> >  	if (current->flags & PF_MEMALLOC)
> >  		return 0;
> > 
> > -	if (ext4_journal_current_handle()) {
> > -		jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
> > -		dump_stack();
> > -		return -EIO;
> > -	}
> > +	if (EXT4_SB(inode->i_sb)->s_journal) {
> > +		if (ext4_journal_current_handle()) {
> > +			jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
> > +			dump_stack();
> > +			return -EIO;
> > +		}
> > 
> > -	if (!wait)
> > -		return 0;
> > +		if (!wait)
> > +			return 0;
> > +
> > +		err = ext4_force_commit(inode->i_sb);
> > +	} else {
> > +		struct ext4_iloc iloc;
> > 
> > -	return ext4_force_commit(inode->i_sb);
> > +		err = ext4_get_inode_loc(inode, &iloc);
> > +		if (err)
> > +			return err;
> > +		err = ext4_do_update_inode(EXT4_NOJOURNAL_HANDLE,
> > +					   inode, &iloc, wait);
> > +	}
> > +	return err;
> >  }
> 
> 
> Why not just do 
> 
> err = ext4_get_inode_loc(inode, &iloc);                                                                                   
> if (err)
> 	return err;
> if (wait)
>    sync_dirty_buffer(iloc.bh);
> 
> 
> because when we updated inode we would have called ext4_mark_inode_dirty which
> internally does ext4_mark_iloc_dirty -> ext4_do_update_inode

Hmm.  Yeah, you're right.  I was thinking that the inode could be
dirtied without calling do_update_inode() but that's apparently not the
case.

Another version of the patch will be forthcoming shortly.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

