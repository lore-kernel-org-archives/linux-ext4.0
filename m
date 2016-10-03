From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Unmap metadata when zeroing blocks
Date: Mon, 3 Oct 2016 09:18:48 +0200
Message-ID: <20161003071848.GC6457@quack2.suse.cz>
References: <1474992918-20488-1-git-send-email-jack@suse.cz>
 <20160929131457.wyhlp34n55ewzzxu@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45613 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751542AbcJCHSu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 3 Oct 2016 03:18:50 -0400
Content-Disposition: inline
In-Reply-To: <20160929131457.wyhlp34n55ewzzxu@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu 29-09-16 15:14:57, Lukas Czerner wrote:
> do we have a xfstest case for this particular problem ?

Not specifically, but some of the existing xfstests did trigger this
problem for me which is how I found it out...

								Honza

> On Tue, Sep 27, 2016 at 06:15:18PM +0200, Jan Kara wrote:
> > When zeroing blocks for DAX allocations, we also have to unmap aliases
> > in the block device mappings. Otherwise writeback can overwrite zeros
> > with stale data from block device page cache.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/inode.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > Ted, can you merge this patch please? It's a data corruption issue for DAX.
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index c6ea25a190f8..87150122d361 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -647,11 +647,19 @@ found:
> >  		/*
> >  		 * We have to zeroout blocks before inserting them into extent
> >  		 * status tree. Otherwise someone could look them up there and
> > -		 * use them before they are really zeroed.
> > +		 * use them before they are really zeroed. We also have to
> > +		 * unmap metadata before zeroing as otherwise writeback can
> > +		 * overwrite zeros with stale data from block device.
> >  		 */
> >  		if (flags & EXT4_GET_BLOCKS_ZERO &&
> >  		    map->m_flags & EXT4_MAP_MAPPED &&
> >  		    map->m_flags & EXT4_MAP_NEW) {
> > +			ext4_lblk_t i;
> > +
> > +			for (i = 0; i < map->m_len; i++) {
> > +				unmap_underlying_metadata(inode->i_sb->s_bdev,
> > +							  map->m_pblk + i);
> > +			}
> >  			ret = ext4_issue_zeroout(inode, map->m_lblk,
> >  						 map->m_pblk, map->m_len);
> >  			if (ret) {
> > -- 
> > 2.6.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
