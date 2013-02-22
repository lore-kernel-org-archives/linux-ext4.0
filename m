From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix overhead calculation in bigalloc filesystem
 (Re: ... )
Date: Fri, 22 Feb 2013 21:18:12 +0800
Message-ID: <20130222131811.GA22069@gmail.com>
References: <1361433665-16880-1-git-send-email-lczerner@redhat.com>
 <20130221121545.GA30821@gmail.com>
 <alpine.LFD.2.00.1302211335390.19354@localhost>
 <alpine.LFD.2.00.1302211346240.19354@localhost>
 <alpine.LFD.2.00.1302211351090.19354@localhost>
 <20130221134943.GA3818@gmail.com>
 <alpine.LFD.2.00.1302211553060.14141@localhost>
 <20130222030327.GB3421@gmail.com>
 <20130222040544.GA13667@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54576 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab3BVNDW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2013 08:03:22 -0500
Received: by mail-pb0-f41.google.com with SMTP id um15so403109pbc.14
        for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2013 05:03:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130222040544.GA13667@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2013 at 11:05:44PM -0500, Theodore Ts'o wrote:
> On Fri, Feb 22, 2013 at 11:03:27AM +0800, Zheng Liu wrote:
> > 
> > I agree with you that we should forbid user to use bigalloc feature with
> > block size = 1k or 2k because I guess no one really use it, at least in
> > Taobao we always use bigalloc feature with block size = 4k.
> 
> The main reason why file systems with 1k or 2k (with or without
> bigalloc) is that it's useful is that it's a good way of testing what
> happens on an architecture with a 16k page size and a 4k blocksize.  I
> am regularly testing with a 1k blocksize because it catches problems
> that would otherwise only show up on PowerPC or Intanium platforms.
> I'm not testing with bigalloc plus 1k block size, though, I admit.
> 
> > FWIW, recently I am considering whether we could remove 'data=journal'
> > and 'data=writeback' mode.  'data=journal' mode hurts performance
> > dramatically.  Further, 'data=writeback' seems also useless, especially
> > after we have 'no journal' feature.  TBH, these modes are lack of tests.
> > Maybe this is a crazy idea in my mind.
> 
> As far as data=writeback and data=ordered are concerned, the only
> difference is a single call to ext4_jbd2_file_end() in
> ext4_ordered_write_end().  In fact, it looks like we could do
> something like the following attached patch to simplify the code and
> improve code coverage from a testing perspective.  (Note: patch not
> yet tested!)
> 
> As far as "data=journalled", it's a bit more complicated but I do have
> a sentimental attachment to it, since it's something which no other
> file system has.  I have been regularly testing it, and it's something
> which has been pretty stable for quite a while now.

Indeed, it seems that other file systems don't have this feature AFAIK.

> 
> If there was a mode that I'd be tempted to get rid of, it would be the
> combined data=ordered/data=writeback modes.  The main reason why we
> keep it is because of a concern of buggy applications that depend on
> the implied fsync() of data=ordered mode at each commit.  However,
> ext4 has been around for long enough that I think most of the buggy
> applications have been fixed by now.  And of course, those buggy
> applications will lose in the same way when they are using btrfs and
> xfs.  Something to consider....

IMHO, the application shouldn't depend on a kernel feature.  So maybe it
is time to highlight this buggy usage.

> 
> 						- Ted
> 
> commit d075b5c3031752a4c41642ff505c3302e5321940
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu Feb 21 23:04:59 2013 -0500
> 
>     ext4: collapse handling of data=ordered and data=writeback codepaths
>     
>     The only difference between how we handle data=ordered and
>     data=writeback is a single call to ext4_jbd2_file_inode().  Eliminate
>     code duplication by factoring out redundant the code paths.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Just one minor comment below.  Otherwise the patch looks good to me, and
it can pass in xfstests with 'data=ordered' and 'data=writeback'.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 6e16c18..85dfd49 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1373,6 +1373,7 @@ enum {
>  	EXT4_STATE_DIOREAD_LOCK,	/* Disable support for dio read
>  					   nolocking */
>  	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */
> +	EXT4_STATE_ORDERED_MODE,	/* data=ordered mode */
>  };
>  
>  #define EXT4_INODE_BIT_FNS(name, field, offset)				\
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 95a0c62..2e338a6 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1055,77 +1055,36 @@ static int ext4_generic_write_end(struct file *file,
>   * ext4 never places buffers on inode->i_mapping->private_list.  metadata
>   * buffers are managed internally.
>   */
> -static int ext4_ordered_write_end(struct file *file,
> -				  struct address_space *mapping,
> -				  loff_t pos, unsigned len, unsigned copied,
> -				  struct page *page, void *fsdata)
> +static int ext4_write_end(struct file *file,
> +			  struct address_space *mapping,
> +			  loff_t pos, unsigned len, unsigned copied,
> +			  struct page *page, void *fsdata)
>  {
>  	handle_t *handle = ext4_journal_current_handle();
>  	struct inode *inode = mapping->host;
>  	int ret = 0, ret2;
>  
>  	trace_ext4_ordered_write_end(inode, pos, len, copied);

Here this function needs to be renamed with trace_ext4_write_end().

Regards,
                                                - Zheng

> -	ret = ext4_jbd2_file_inode(handle, inode);
> -
> -	if (ret == 0) {
> -		ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
> -							page, fsdata);
> -		copied = ret2;
> -		if (pos + len > inode->i_size && ext4_can_truncate(inode))
> -			/* if we have allocated more blocks and copied
> -			 * less. We will have blocks allocated outside
> -			 * inode->i_size. So truncate them
> -			 */
> -			ext4_orphan_add(handle, inode);
> -		if (ret2 < 0)
> -			ret = ret2;
> -	} else {
> -		unlock_page(page);
> -		page_cache_release(page);
> -	}
> -
> -	ret2 = ext4_journal_stop(handle);
> -	if (!ret)
> -		ret = ret2;
> -
> -	if (pos + len > inode->i_size) {
> -		ext4_truncate_failed_write(inode);
> -		/*
> -		 * If truncate failed early the inode might still be
> -		 * on the orphan list; we need to make sure the inode
> -		 * is removed from the orphan list in that case.
> -		 */
> -		if (inode->i_nlink)
> -			ext4_orphan_del(NULL, inode);
> +	if (ext4_test_inode_state(inode, EXT4_STATE_ORDERED_MODE)) {
> +		ret = ext4_jbd2_file_inode(handle, inode);
> +		if (ret) {
> +			unlock_page(page);
> +			page_cache_release(page);
> +			goto errout;
> +		}
>  	}
>  
> -
> -	return ret ? ret : copied;
> -}
> -
> -static int ext4_writeback_write_end(struct file *file,
> -				    struct address_space *mapping,
> -				    loff_t pos, unsigned len, unsigned copied,
> -				    struct page *page, void *fsdata)
> -{
> -	handle_t *handle = ext4_journal_current_handle();
> -	struct inode *inode = mapping->host;
> -	int ret = 0, ret2;
> -
> -	trace_ext4_writeback_write_end(inode, pos, len, copied);
> -	ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
> -							page, fsdata);
> -	copied = ret2;
> +	copied = ext4_generic_write_end(file, mapping, pos, len, copied,
> +					page, fsdata);
> +	if (copied < 0)
> +		ret = copied;
>  	if (pos + len > inode->i_size && ext4_can_truncate(inode))
>  		/* if we have allocated more blocks and copied
>  		 * less. We will have blocks allocated outside
>  		 * inode->i_size. So truncate them
>  		 */
>  		ext4_orphan_add(handle, inode);
> -
> -	if (ret2 < 0)
> -		ret = ret2;
> -
> +errout:
>  	ret2 = ext4_journal_stop(handle);
>  	if (!ret)
>  		ret = ret2;
> @@ -2656,18 +2615,9 @@ static int ext4_da_write_end(struct file *file,
>  	unsigned long start, end;
>  	int write_mode = (int)(unsigned long)fsdata;
>  
> -	if (write_mode == FALL_BACK_TO_NONDELALLOC) {
> -		switch (ext4_inode_journal_mode(inode)) {
> -		case EXT4_INODE_ORDERED_DATA_MODE:
> -			return ext4_ordered_write_end(file, mapping, pos,
> -					len, copied, page, fsdata);
> -		case EXT4_INODE_WRITEBACK_DATA_MODE:
> -			return ext4_writeback_write_end(file, mapping, pos,
> -					len, copied, page, fsdata);
> -		default:
> -			BUG();
> -		}
> -	}
> +	if (write_mode == FALL_BACK_TO_NONDELALLOC)
> +		return ext4_write_end(file, mapping, pos,
> +				      len, copied, page, fsdata);
>  
>  	trace_ext4_da_write_end(inode, pos, len, copied);
>  	start = pos & (PAGE_CACHE_SIZE - 1);
> @@ -3172,27 +3122,12 @@ static int ext4_journalled_set_page_dirty(struct page *page)
>  	return __set_page_dirty_nobuffers(page);
>  }
>  
> -static const struct address_space_operations ext4_ordered_aops = {
> +static const struct address_space_operations ext4_aops = {
>  	.readpage		= ext4_readpage,
>  	.readpages		= ext4_readpages,
>  	.writepage		= ext4_writepage,
>  	.write_begin		= ext4_write_begin,
> -	.write_end		= ext4_ordered_write_end,
> -	.bmap			= ext4_bmap,
> -	.invalidatepage		= ext4_invalidatepage,
> -	.releasepage		= ext4_releasepage,
> -	.direct_IO		= ext4_direct_IO,
> -	.migratepage		= buffer_migrate_page,
> -	.is_partially_uptodate  = block_is_partially_uptodate,
> -	.error_remove_page	= generic_error_remove_page,
> -};
> -
> -static const struct address_space_operations ext4_writeback_aops = {
> -	.readpage		= ext4_readpage,
> -	.readpages		= ext4_readpages,
> -	.writepage		= ext4_writepage,
> -	.write_begin		= ext4_write_begin,
> -	.write_end		= ext4_writeback_write_end,
> +	.write_end		= ext4_write_end,
>  	.bmap			= ext4_bmap,
>  	.invalidatepage		= ext4_invalidatepage,
>  	.releasepage		= ext4_releasepage,
> @@ -3237,23 +3172,21 @@ void ext4_set_aops(struct inode *inode)
>  {
>  	switch (ext4_inode_journal_mode(inode)) {
>  	case EXT4_INODE_ORDERED_DATA_MODE:
> -		if (test_opt(inode->i_sb, DELALLOC))
> -			inode->i_mapping->a_ops = &ext4_da_aops;
> -		else
> -			inode->i_mapping->a_ops = &ext4_ordered_aops;
> +		ext4_set_inode_state(inode, EXT4_STATE_ORDERED_MODE);
>  		break;
>  	case EXT4_INODE_WRITEBACK_DATA_MODE:
> -		if (test_opt(inode->i_sb, DELALLOC))
> -			inode->i_mapping->a_ops = &ext4_da_aops;
> -		else
> -			inode->i_mapping->a_ops = &ext4_writeback_aops;
> +		ext4_clear_inode_state(inode, EXT4_STATE_ORDERED_MODE);
>  		break;
>  	case EXT4_INODE_JOURNAL_DATA_MODE:
>  		inode->i_mapping->a_ops = &ext4_journalled_aops;
> -		break;
> +		return;
>  	default:
>  		BUG();
>  	}
> +	if (test_opt(inode->i_sb, DELALLOC))
> +		inode->i_mapping->a_ops = &ext4_da_aops;
> +	else
> +		inode->i_mapping->a_ops = &ext4_aops;
>  }
>  
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
