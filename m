From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/9 v4] ext4: track all extent status in extent status
 tree
Date: Tue, 5 Feb 2013 13:08:54 +0100
Message-ID: <20130205120854.GC5943@quack.suse.cz>
References: <1359609477-29845-1-git-send-email-wenqing.lz@taobao.com>
 <1359609477-29845-6-git-send-email-wenqing.lz@taobao.com>
 <20130131165055.GF4612@quack.suse.cz>
 <20130201053308.GA6274@gmail.com>
 <20130204112709.GC7523@quack.suse.cz>
 <20130205033221.GA18864@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab3BEMI6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2013 07:08:58 -0500
Content-Disposition: inline
In-Reply-To: <20130205033221.GA18864@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 05-02-13 11:32:21, Zheng Liu wrote:
> On Mon, Feb 04, 2013 at 12:27:09PM +0100, Jan Kara wrote:
> > On Fri 01-02-13 13:33:08, Zheng Liu wrote:
> > > On Thu, Jan 31, 2013 at 05:50:55PM +0100, Jan Kara wrote:
> > > > On Thu 31-01-13 13:17:53, Zheng Liu wrote:
> > > > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > > > 
> > > > > By recording the phycisal block and status, extent status tree is able
> > > > > to track the status of every extents.  When we call _map_blocks
> > > > > functions to lookup an extent or create a new written/unwritten/delayed
> > > > > extent, this extent will be inserted into extent status tree.
> > > > > 
> > > > > We don't load all extents from disk in alloc_inode() because it costs
> > > > > too much memory, and if a file is opened and closed frequently it will
> > > > > takes too much time to load all extent information.  So currently when
> > > > > we create/lookup an extent, this extent will be inserted into extent
> > > > > status tree.  Hence, the extent status tree may not comprehensively
> > > > > contain all of the extents found in the file.
> > > > > 
> > > > > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > > > > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > > > > ---
> > > > >  fs/ext4/extents.c |  5 +++-
> > > > >  fs/ext4/file.c    |  6 +++--
> > > > >  fs/ext4/inode.c   | 73 ++++++++++++++++++++++++++++++++++++-------------------
> > > > >  3 files changed, 56 insertions(+), 28 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > > > index aa9a6d2..d23a654 100644
> > > > > --- a/fs/ext4/extents.c
> > > > > +++ b/fs/ext4/extents.c
> > > > > @@ -2074,7 +2074,7 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
> > > > >  		}
> > > > >  
> > > > >  		/* This is possible iff next == next_del == EXT_MAX_BLOCKS */
> > > > > -		if (next == next_del) {
> > > > > +		if (next == next_del && next_del == EXT_MAX_BLOCKS) {
> > > >   This doesn't seem to be related, does it?
> > > 
> > > ext4_ext_next_allocated_block() will return EXT_MAX_BLOCKS when it
> > > reaches the end of file.  ext4_find_delayed_extent() does the same
> > > thing.
> >   Yes.
> > 
> > > Before tracking written/unwritten extent it is correct because
> > > next never equals to next_del unless both of them equal to
> > > EXT_MAX_BLOCKS.  However, after that next is possible to equal to
> > > next_del when they don't reach the end of file.
  <snip>
> > To our current discussion ext4_find_delayed_extent() either returns 0 or
> > start of next delalloc extent (if we found extent of other type in the
> > status tree we just return 0) so I don't see how next_del == next for other
> > value than EXT_MAX_BLOCKS. But maybe I miss something.
> 
> After tracking all extent status in status tree, ext4_es_find_extent()
> returns not only delayed extent, but also written/unwritten extents.  So
> it is possible that next_del == next and its value is not
> EXT_MAX_BLOCKS.  *But* in latest version ext4_es_find_extent() will be
> changed to only return delayed extent.  So the problem will be fixed.
  Ah, now I see. You added the condition checking whether extent is delayed
only to the newex->ec_start == 0 branch. So if we don't take that branch,
we could have returned an extent which isn't delayed.

IMHO it is a wrong decision for ext4_es_find_extent() to return only
delayed extents. That should really return any extent that contains given
block (or is after it). It is ext4_find_delayed_extent() that should really
be changed to return only delayed extents as its name suggests...

> > > > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > > > index e09c7cf..f0dda2a 100644
> > > > > --- a/fs/ext4/inode.c
> > > > > +++ b/fs/ext4/inode.c
> > > > > @@ -615,18 +615,27 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
> > > > >  			(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE))
> > > > >  			ext4_da_update_reserve_space(inode, retval, 1);
> > > > >  	}
> > > > > -	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
> > > > > +	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
> > > > >  		ext4_clear_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
> > > > >  
> > > > > -		if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
> > > > > -			int ret;
> > > > > -delayed_mapped:
> > > > > -			/* delayed allocation blocks has been allocated */
> > > > > -			ret = ext4_es_remove_extent(inode, map->m_lblk,
> > > > > -						    map->m_len);
> > > > > -			if (ret < 0)
> > > > > -				retval = ret;
> > > > > -		}
> > > > > +	if (retval > 0) {
> > > > > +		int ret, status;
> > > > > +
> > > > > +		if (flags & EXT4_GET_BLOCKS_PRE_IO)
> > > > > +			status = EXTENT_STATUS_UNWRITTEN;
> > > > > +		else if (flags & EXT4_GET_BLOCKS_CONVERT)
> > > > > +			status = EXTENT_STATUS_WRITTEN;
> > > > > +		else if (flags & EXT4_GET_BLOCKS_UNINIT_EXT)
> > > > > +			status = EXTENT_STATUS_UNWRITTEN;
> > > > > +		else if (flags & EXT4_GET_BLOCKS_CREATE)
> > > > > +			status = EXTENT_STATUS_WRITTEN;
> > > > > +		else
> > > > > +			BUG_ON(1);
> > > > > +
> > > > > +		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
> > > > > +					    map->m_pblk, status);
> > > > > +		if (ret < 0)
> > > > > +			retval = ret;
> > > >   Hum, are you sure the extent status will be correct? Won't it be safer to
> > > > just use whatever we have in 'map'?
> > > 
> > > Your meaning is that we need to ignore the error when we insert a extent
> > > into the extent status tree, right?  But that would causes an
> > > inconsistency between status tree and extent tree.  Further,
> > > ext4_es_insert_extent() returns EINVAL or ENOMEM.  I believe that
> > > reporting an error is a better choice.  What do you think?
> >   No, I meant something else. For example you decide extent at given
> > position is 'UNWRITTEN' just on the basis that someone passed
> > EXT4_GET_BLOCKS_PRE_IO as get_blocks flags. How do you know? Cannot someone
> > pass EXT4_GET_BLOCKS_PRE_IO and we actually find out the extent at given
> > position is fully allocated extent (i.e. WRITTEN) so we do nothing? Then
> > you would cache bad state in the extent tree... That's why I'd rather see
> > we derive current 'status' from 'map' where we are sure to have correct
> > information and don't have to guess it from passed flags.
> 
> First of all, we don't need to worry about this problem because we
> always lookup an extent before trying to create it.  So when it is an
> written extent, we will return from ext4_map_blocks() directly and won't
> try to create it.  So status tree don't be touched.
  So my argument isn't as much about whether you can deduce the correct
result from flags passed to ext4_map_blocks() but rather that it simply
isn't the right place where to look. The right place where to look what
extent is at given position is 'map' where we store what we found. And you
are right that ext4_ext_map_blocks() isn't properly returning
EXT4_MAP_UNWRITTEN in some cases - thanks for noticing that - but then the
right answer is to fix ext4_ext_map_blocks() to return it and not to hack
around that in extent cache code... Believe me it will save us quite some
head scratching later.

> Secondly, as far as I know, ext4_ext_map_blocks() will never return
> EXT4_MAP_UNWRITTEN flags after it tries to allocate an unwritten extent.
> So that means that 'm_flags' in map is incorrect.  Maybe I miss
> something.

							Bye
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
