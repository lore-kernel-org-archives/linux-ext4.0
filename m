From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 5/9 v4] ext4: track all extent status in extent status
 tree
Date: Fri, 1 Feb 2013 13:33:08 +0800
Message-ID: <20130201053308.GA6274@gmail.com>
References: <1359609477-29845-1-git-send-email-wenqing.lz@taobao.com>
 <1359609477-29845-6-git-send-email-wenqing.lz@taobao.com>
 <20130131165055.GF4612@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64860 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3BAFS5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2013 00:18:57 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so1993994pbc.10
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jan 2013 21:18:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130131165055.GF4612@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2013 at 05:50:55PM +0100, Jan Kara wrote:
> On Thu 31-01-13 13:17:53, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > By recording the phycisal block and status, extent status tree is able
> > to track the status of every extents.  When we call _map_blocks
> > functions to lookup an extent or create a new written/unwritten/delayed
> > extent, this extent will be inserted into extent status tree.
> > 
> > We don't load all extents from disk in alloc_inode() because it costs
> > too much memory, and if a file is opened and closed frequently it will
> > takes too much time to load all extent information.  So currently when
> > we create/lookup an extent, this extent will be inserted into extent
> > status tree.  Hence, the extent status tree may not comprehensively
> > contain all of the extents found in the file.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  fs/ext4/extents.c |  5 +++-
> >  fs/ext4/file.c    |  6 +++--
> >  fs/ext4/inode.c   | 73 ++++++++++++++++++++++++++++++++++++-------------------
> >  3 files changed, 56 insertions(+), 28 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index aa9a6d2..d23a654 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -2074,7 +2074,7 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
> >  		}
> >  
> >  		/* This is possible iff next == next_del == EXT_MAX_BLOCKS */
> > -		if (next == next_del) {
> > +		if (next == next_del && next_del == EXT_MAX_BLOCKS) {
>   This doesn't seem to be related, does it?

ext4_ext_next_allocated_block() will return EXT_MAX_BLOCKS when it
reaches the end of file.  ext4_find_delayed_extent() does the same
thing.  Before tracking written/unwritten extent it is correct because
next never equals to next_del unless both of them equal to
EXT_MAX_BLOCKS.  However, after that next is possible to equal to
next_del when they don't reach the end of file.  So we need to make sure
next equals to next_del and both of them equal to EXT_MAX_BLOCKS.  In
this condition it indicates that we reach the end of file.  Am I miss
something?

> 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index e09c7cf..f0dda2a 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -615,18 +615,27 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
> >  			(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE))
> >  			ext4_da_update_reserve_space(inode, retval, 1);
> >  	}
> > -	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
> > +	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
> >  		ext4_clear_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
> >  
> > -		if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
> > -			int ret;
> > -delayed_mapped:
> > -			/* delayed allocation blocks has been allocated */
> > -			ret = ext4_es_remove_extent(inode, map->m_lblk,
> > -						    map->m_len);
> > -			if (ret < 0)
> > -				retval = ret;
> > -		}
> > +	if (retval > 0) {
> > +		int ret, status;
> > +
> > +		if (flags & EXT4_GET_BLOCKS_PRE_IO)
> > +			status = EXTENT_STATUS_UNWRITTEN;
> > +		else if (flags & EXT4_GET_BLOCKS_CONVERT)
> > +			status = EXTENT_STATUS_WRITTEN;
> > +		else if (flags & EXT4_GET_BLOCKS_UNINIT_EXT)
> > +			status = EXTENT_STATUS_UNWRITTEN;
> > +		else if (flags & EXT4_GET_BLOCKS_CREATE)
> > +			status = EXTENT_STATUS_WRITTEN;
> > +		else
> > +			BUG_ON(1);
> > +
> > +		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
> > +					    map->m_pblk, status);
> > +		if (ret < 0)
> > +			retval = ret;
>   Hum, are you sure the extent status will be correct? Won't it be safer to
> just use whatever we have in 'map'?

Your meaning is that we need to ignore the error when we insert a extent
into the extent status tree, right?  But that would causes an
inconsistency between status tree and extent tree.  Further,
ext4_es_insert_extent() returns EINVAL or ENOMEM.  I believe that
reporting an error is a better choice.  What do you think?

Thanks,
                                                - Zheng
