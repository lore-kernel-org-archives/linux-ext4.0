From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Make non-journal fsync work properly. REPOST
Date: Mon, 14 Sep 2009 22:24:13 +0530
Message-ID: <20090914165413.GA4375@skywalker.linux.vnet.ibm.com>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
 <20090908050614.GA10477@mit.edu>
 <1252424465.17646.7.camel@bobble.smo.corp.google.com>
 <20090908220504.GS22901@mit.edu>
 <1252517664.18594.3.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:54579 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbZINQye (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Sep 2009 12:54:34 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp09.au.ibm.com (8.14.3/8.13.1) with ESMTP id n8EGnDKL024339
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 02:49:13 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8EGsa82417956
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 02:54:37 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8EGsaUr020517
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 02:54:36 +1000
Content-Disposition: inline
In-Reply-To: <1252517664.18594.3.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 09, 2009 at 10:34:24AM -0700, Frank Mayhar wrote:
> Teach ext4_write_inode() and ext4_do_update_inode() about non-journal
> mode:  If we're not using a journal, ext4_write_inode() now calls
> ext4_do_update_inode() (after getting the iloc via ext4_get_inode_loc())
> with a new "do_sync" parameter.  If that parameter is nonzero _and_ we're
> not using a journal, ext4_do_update_inode() calls sync_dirty_buffer()
> instead of ext4_handle_dirty_metadata().
> 
> This problem was found in power-fail testing, checking the amount of
> loss of files and blocks after a power failure when using fsync() and
> when not using fsync().  It turned out that using fsync() was actually
> worse than not doing so, possibly because it increased the likelihood
> that the inodes would remain unflushed and would therefore be lost at
> the power failure.
> 
> Signed-off-by: Frank Mayhar <fmayhar@google.com>
> 
>  fs/ext4/inode.c |   54 ++++++++++++++++++++++++++++++++++++++++--------------
>  1 files changed, 40 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d87f6a0..ef2e780 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4741,7 +4741,8 @@ static int ext4_inode_blocks_set(handle_t *handle,
>   */
>  static int ext4_do_update_inode(handle_t *handle,
>  				struct inode *inode,
> -				struct ext4_iloc *iloc)
> +				struct ext4_iloc *iloc,
> +				int do_sync)
>  {
>  	struct ext4_inode *raw_inode = ext4_raw_inode(iloc);
>  	struct ext4_inode_info *ei = EXT4_I(inode);
> @@ -4843,10 +4844,22 @@ static int ext4_do_update_inode(handle_t *handle,
>  		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
>  	}
> 
> -	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> -	rc = ext4_handle_dirty_metadata(handle, inode, bh);
> -	if (!err)
> -		err = rc;
> +	/*
> +	 * If we're not using a journal and we were called from
> +	 * ext4_write_inode() to sync the inode (making do_sync true),
> +	 * we can just use sync_dirty_buffer() directly to do our dirty
> +	 * work.  Testing s_journal here is a bit redundant but it's
> +	 * worth it to avoid potential future trouble.
> +	 */
> +	if (EXT4_SB(inode->i_sb)->s_journal == NULL && do_sync) {
> +		BUFFER_TRACE(bh, "call sync_dirty_buffer");
> +		sync_dirty_buffer(bh);
> +	} else {
> +		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> +		rc = ext4_handle_dirty_metadata(handle, inode, bh);
> +		if (!err)
> +			err = rc;
> +	}
>  	ei->i_state &= ~EXT4_STATE_NEW;
> 
>  out_brelse:
> @@ -4892,19 +4905,32 @@ out_brelse:
>   */
>  int ext4_write_inode(struct inode *inode, int wait)
>  {
> +	int err;
> +
>  	if (current->flags & PF_MEMALLOC)
>  		return 0;
> 
> -	if (ext4_journal_current_handle()) {
> -		jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
> -		dump_stack();
> -		return -EIO;
> -	}
> +	if (EXT4_SB(inode->i_sb)->s_journal) {
> +		if (ext4_journal_current_handle()) {
> +			jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
> +			dump_stack();
> +			return -EIO;
> +		}
> 
> -	if (!wait)
> -		return 0;
> +		if (!wait)
> +			return 0;
> +
> +		err = ext4_force_commit(inode->i_sb);
> +	} else {
> +		struct ext4_iloc iloc;
> 
> -	return ext4_force_commit(inode->i_sb);
> +		err = ext4_get_inode_loc(inode, &iloc);
> +		if (err)
> +			return err;
> +		err = ext4_do_update_inode(EXT4_NOJOURNAL_HANDLE,
> +					   inode, &iloc, wait);
> +	}
> +	return err;
>  }


Why not just do 

err = ext4_get_inode_loc(inode, &iloc);                                                                                   
if (err)
	return err;
if (wait)
   sync_dirty_buffer(iloc.bh);


because when we updated inode we would have called ext4_mark_inode_dirty which
internally does ext4_mark_iloc_dirty -> ext4_do_update_inode

May be we also want to check the error from sync_dirty_buffer

 sync_dirty_buffer(bh);
 if (buffer_req(bh) && !buffer_uptodate(bh)) {
      ext4_error(inode->i_sb, __func__,
		  "IO error syncing inode, "
			  "inode=%lu, block=%llu",
			  inode->i_ino,
			  (unsigned long long) bh->b_blocknr);
       err = -EIO;
 }


> 
>  /*
> @@ -5198,7 +5224,7 @@ int ext4_mark_iloc_dirty(handle_t *handle,
>  	get_bh(iloc->bh);
> 
>  	/* ext4_do_update_inode() does jbd2_journal_dirty_metadata */
> -	err = ext4_do_update_inode(handle, inode, iloc);
> +	err = ext4_do_update_inode(handle, inode, iloc, 0);
>  	put_bh(iloc->bh);
>  	return err;
>  }
> 

-aneesh
