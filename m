From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 03/10] ext4: fix unwritten counter leakage
Date: Thu, 27 Sep 2012 16:19:01 +0400
Message-ID: <87bogr64lm.fsf@openvz.org>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org> <1348487060-19598-4-git-send-email-dmonakhov@openvz.org> <20120926130714.GD10145@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	lczerner@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47883 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2I0MTF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2012 08:19:05 -0400
Received: by bkcjk13 with SMTP id jk13so1657954bkc.19
        for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2012 05:19:04 -0700 (PDT)
In-Reply-To: <20120926130714.GD10145@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 26 Sep 2012 15:07:14 +0200, Jan Kara <jack@suse.cz> wrote:
> On Mon 24-09-12 15:44:13, Dmitry Monakhov wrote:
> > ext4_set_io_unwritten_flag() will increment i_unwritten counter, so
> > once we mark end_io with END_IO_UNWRITTEN we have to revert it back
>                            ^^ EXT4_IO_END_UNWRITTEN
> > on error path.
> > 
> >  - add missed error checks to prevent counter leakage
> >  - ext4_end_io_nolock() will clear END_IO_UNWRITTEN flag to signal
>                                      ^^ EXT4_IO_END_UNWRITTEN
> >    that conversion finished.
> >  - add BUGON to free_end_io() to prevent similar leackage in future.
>          ^^ BUG_ON    ^^ext4_free_io_end()         ^^ leakage
> 
> > Visiable effect of this bug is that unaligned aio_stress may deadlock
>   ^^ Visible
> 
>   Umm, and won't it be more foolproof it we just decrement i_unwritten in
> ext4_free_io_end() when we see EXT4_IO_END_UNWRITTEN set?
I'd like to consider BUG_ON inside ext4_free_io_end as a sanity check to
force all callers to perform all necessary error checks in known context. 
> 
>   That still leaves the mess with EXT4_STATE_DIO_UNWRITTEN unhandled. But
> that's a separate issue. We seem to clear that flag only in
> ext4_ext_direct_IO() although it could be set even when buffered write
> converts extents. And error cases seem to be buggy as well.
No, each unwritten extent will be added to i_complete_io_list regardless
to it's origin (buffered or DIO), and will be completed via
ext4_end_io_nolock(). So assertion is correct.
> 
> 								Honza
> 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/ext4/extents.c |   21 ++++++++++++++-------
> >  fs/ext4/page-io.c |    6 +++++-
> >  2 files changed, 19 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 6eb6b0c..739c21d 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -3660,6 +3660,8 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
> >  	if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
> >  		ret = ext4_split_unwritten_extents(handle, inode, map,
> >  						   path, flags);
> > +		if (ret <= 0)
> > +			goto out;
> >  		/*
> >  		 * Flag the inode(non aio case) or end_io struct (aio case)
> >  		 * that this IO needs to conversion to written when IO is
> > @@ -3905,6 +3907,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
> >  	struct ext4_allocation_request ar;
> >  	ext4_io_end_t *io = (ext4_io_end_t*) EXT4_CUR_AIO_DIO(inode);
> >  	ext4_lblk_t cluster_offset;
> > +	int set_unwritten = 0;
> >  
> >  	ext_debug("blocks %u/%u requested for inode %lu\n",
> >  		  map->m_lblk, map->m_len, inode->i_ino);
> > @@ -4127,13 +4130,8 @@ got_allocated_blocks:
> >  		 * For non asycn direct IO case, flag the inode state
> >  		 * that we need to perform conversion when IO is done.
> >  		 */
> > -		if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
> > -			if (io)
> > -				ext4_set_io_unwritten_flag(inode, io);
> > -			else
> > -				ext4_set_inode_state(inode,
> > -						     EXT4_STATE_DIO_UNWRITTEN);
> > -		}
> > +		if ((flags & EXT4_GET_BLOCKS_PRE_IO))
> > +			set_unwritten = 1;
> >  		if (ext4_should_dioread_nolock(inode))
> >  			map->m_flags |= EXT4_MAP_UNINIT;
> >  	}
> > @@ -4145,6 +4143,15 @@ got_allocated_blocks:
> >  	if (!err)
> >  		err = ext4_ext_insert_extent(handle, inode, path,
> >  					     &newex, flags);
> > +
> > +	if (!err && set_unwritten) {
> > +		if (io)
> > +			ext4_set_io_unwritten_flag(inode, io);
> > +		else
> > +			ext4_set_inode_state(inode,
> > +					     EXT4_STATE_DIO_UNWRITTEN);
> > +	}
> > +
> >  	if (err && free_on_err) {
> >  		int fb_flags = flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE ?
> >  			EXT4_FREE_BLOCKS_NO_QUOT_UPDATE : 0;
> > diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> > index de77e31..9970022 100644
> > --- a/fs/ext4/page-io.c
> > +++ b/fs/ext4/page-io.c
> > @@ -71,6 +71,8 @@ void ext4_free_io_end(ext4_io_end_t *io)
> >  	int i;
> >  
> >  	BUG_ON(!io);
> > +	BUG_ON(io->flag & EXT4_IO_END_UNWRITTEN);
> > +
> >  	if (io->page)
> >  		put_page(io->page);
> >  	for (i = 0; i < io->num_io_pages; i++)
> > @@ -94,6 +96,8 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
> >  	ssize_t size = io->size;
> >  	int ret = 0;
> >  
> > +	BUG_ON(!(io->flag & EXT4_IO_END_UNWRITTEN));
> > +
> >  	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
> >  		   "list->prev 0x%p\n",
> >  		   io, inode->i_ino, io->list.next, io->list.prev);
> > @@ -106,7 +110,7 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
> >  			 "(inode %lu, offset %llu, size %zd, error %d)",
> >  			 inode->i_ino, offset, size, ret);
> >  	}
> > -
> > +	io->flag &= ~EXT4_IO_END_UNWRITTEN;
> >  	if (io->iocb)
> >  		aio_complete(io->iocb, io->result, 0);
> >  
> > -- 
> > 1.7.7.6
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
