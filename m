From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/10 v5] ext4: lookup block mapping in extent status
 tree
Date: Fri, 15 Feb 2013 17:47:51 +0100
Message-ID: <20130215164751.GE7458@quack.suse.cz>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-6-git-send-email-wenqing.lz@taobao.com>
 <20130212123142.GC19583@quack.suse.cz>
 <20130215070626.GD26945@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab3BOQry (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Feb 2013 11:47:54 -0500
Content-Disposition: inline
In-Reply-To: <20130215070626.GD26945@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 15-02-13 15:06:26, Zheng Liu wrote:
> On Tue, Feb 12, 2013 at 01:31:42PM +0100, Jan Kara wrote:
> > On Fri 08-02-13 16:44:01, Zheng Liu wrote:
> > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > 
> > > After tracking all extent status, we already have a extent cache in
> > > memory.  Every time we want to lookup a block mapping, we can first
> > > try to lookup it in extent status tree to avoid a potential disk I/O.
> > > 
> > > A new function called ext4_es_lookup_extent is defined to finish this
> > > work.  When we try to lookup a block mapping, we always call
> > > ext4_map_blocks and/or ext4_da_map_blocks.  So in these functions we
> > > first try to lookup a block mapping in extent status tree.
> > > 
> > > A new flag EXT4_GET_BLOCKS_NO_PUT_HOLE is used in ext4_da_map_blocks
> > > in order not to put a hole into extent status tree because this hole
> > > will be converted to delayed extent in the tree immediately.
> >   It looks somewhat inconsistent that you put hole into the extent tree in
> > ext4_ext_map_blocks() but all other extent types are handled in
> > ext4_map_blocks() or ext4_da_map_blocks(). Can we put the handling in one
> > place?
> 
> It seems that putting all handlings in one place is too complex because
> ext4_da_map_blocks() calls ext4_ext_map_blocks() and ext4_ind_map_blocks()
> directly.  So now we put all extent except hole in ext4_map_blocks() and
> ext4_da_map_blocks().  For the hole, it will be inserted into the status
> tree in ext4_ext_put_gap_in_cache().  In this function we can get the
> the length of the hole.  If we handle it in ext4_da_map_blocks() or
> ext4_map_blocks(), we only can insert a hole which the length of this
> hole is 1 because in these functions we couldn't know the length of the
> hole.
  Ah right, thanks for explanation.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
