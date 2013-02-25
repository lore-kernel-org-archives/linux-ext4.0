From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4 xfstest regression due to ext4_es_lookup_extent
Date: Mon, 25 Feb 2013 12:39:21 +0400
Message-ID: <87zjys3hza.fsf@openvz.org>
References: <87obfcs1x6.fsf@openvz.org> <20130224145837.GA3722@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:45929 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab3BYIj0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Feb 2013 03:39:26 -0500
Received: by mail-lb0-f181.google.com with SMTP id gm6so2012520lbb.26
        for <linux-ext4@vger.kernel.org>; Mon, 25 Feb 2013 00:39:24 -0800 (PST)
In-Reply-To: <20130224145837.GA3722@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 24 Feb 2013 22:58:37 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> Hi Dmirty,
> 
> On Fri, Feb 22, 2013 at 09:17:57PM +0400, Dmitry Monakhov wrote:
> [snip]
> > From 65c5fc212b1c684c76899c6e5e1f24d88550c6fc Mon Sep 17 00:00:00 2001
> > From: Dmitry Monakhov <dmonakhov@openvz.org>
> > Date: Fri, 22 Feb 2013 20:55:52 +0400
> > Subject: [PATCH] ext4 add sanity ext4_es_lookup_extent
> > 
> > This patch does very simple thing: it recheck result returned from
> > ext4_es_lookup_extent() by comparing it old-good lookup via
> > ext4_{ind,ext}_map_blocks() under i_data_sem
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> I try to apply the following patch in my tree, but I realize that it
> seems that we couldn't add this sanity check in ext4_map_blocks and
> ext4_da_map_blocks now.  The reason is that when we try to initialize an
> unwritten extent this extent could be zeroed out.  But we could know it
> in *_map_blocks, and status tree couldn't be updated.  So we will hit a
> BUG_ON(1) after added this sanity check.
This means that extent-status tree should be updated once zeroout
happen.

> 
> I agree with you that we need to add self-testing infrastructre after
> applied status tree patch series.  But it seems that we need to mix
> updating status tree code with extent tree code.  IMHO it is too
> complicated.  Any thought?
Many developers have invested significant amount of man-hours in to 
ext4's delay allocation state machine. It is now known as stable and reliable
So it reasonable to use it as a primary for self-testing of
extent-status tree. If es_cache != real_state this is means that we have
forget to update es_cache.
For example when extents was introduced it have many self testing things
such as:
1) CHECK_BINSEARCH__: Which recheck binarry search result.
        
2) AGGRESSIVE_TEST : Which force deep extent tree constructions and
                     allow to cover unusual branches.
3) DOUBLE_CHECK : Recheck block alloc bitmap one more time

I strongly believe in testing. Ext4 is production-grade filesystem
so we can not break it in the name of new features, unless we are sure
that features are safe and valuable, that's why investments in
self-testing infrastructure for ES should have very high priority.
But off course Theodore's decision whenever feature is looks stable
enough to get ready go upstream.
> 
> Thanks,
>                                                 - Zheng
> 
> > ---
> >  fs/ext4/inode.c |   42 ++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 42 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 95a0c62..706db1f 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -482,6 +482,41 @@ static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
> >  	return num;
> >  }
> >  
> > +#define ES_AGGRESSIVE_TEST 1
> > +#ifdef ES_AGGRESSIVE_TEST
> > +void ext4_map_blocks_es_recheck(handle_t *handle, struct inode *inode,
> > +				struct ext4_map_blocks *es_map, int es_ret,
> > +				struct ext4_map_blocks *map, int flags)
> > +{
> > +	int ret;
> > +
> > +	map->m_flags = 0;
> > +	if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
> > +		down_read((&EXT4_I(inode)->i_data_sem));
> > +	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
> > +		ret = ext4_ext_map_blocks(handle, inode, map, flags &
> > +					     EXT4_GET_BLOCKS_KEEP_SIZE);
> > +	} else {
> > +		ret = ext4_ind_map_blocks(handle, inode, map, flags &
> > +					     EXT4_GET_BLOCKS_KEEP_SIZE);
> > +	}
> > +	if (es_map->m_lblk != map->m_lblk ||
> > +	    es_map->m_flags != map->m_flags ||
> > +	    es_map->m_len != map->m_len ||
> > +	    es_map->m_pblk != map->m_pblk ||
> > +	    es_ret != ret) {
> > +		printk("Assertation failed for inode:%lu "
> > +		       "es_cached_ex [%d/%d/%llu/%x]:%d != "
> > +		       "found_ex [%d/%d/%llu/%x]:%d\n", inode->i_ino,
> > +		       es_map->m_lblk, es_map->m_len, es_map->m_pblk,
> > +		       es_map->m_flags, es_ret,
> > +		       map->m_lblk, map->m_len, map->m_pblk, map->m_flags, ret);
> > +		BUG();
> > +	}
> > +	if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
> > +		up_read((&EXT4_I(inode)->i_data_sem));
> > +}
> > +#endif
> >  /*
> >   * The ext4_map_blocks() function tries to look up the requested blocks,
> >   * and returns if the blocks are already mapped.
> > @@ -509,7 +544,11 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
> >  {
> >  	struct extent_status es;
> >  	int retval;
> > +#ifdef ES_AGGRESSIVE_TEST
> > +	struct ext4_map_blocks orig_map;
> >  
> > +	memcpy(&orig_map, map, sizeof(*map));
> > +#endif
> >  	map->m_flags = 0;
> >  	ext_debug("ext4_map_blocks(): inode %lu, flag %d, max_blocks %u,"
> >  		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
> > @@ -531,6 +570,9 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
> >  		} else {
> >  			BUG_ON(1);
> >  		}
> > +#ifdef ES_AGGRESSIVE_TEST
> > +		ext4_map_blocks_es_recheck(handle,inode, map, retval, &orig_map, flags);
> > +#endif
> >  		goto found;
> >  	}
> >  
> > -- 
> > 1.7.1
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
