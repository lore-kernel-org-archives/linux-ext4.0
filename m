From: Jan Kara <jack@suse.cz>
Subject: Re: Possible bug with extent status tree
Date: Tue, 12 Mar 2013 10:32:11 +0100
Message-ID: <20130312093211.GA13152@quack.suse.cz>
References: <20130311203834.GA22229@quack.suse.cz>
 <20130312035319.GB6142@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab3CLJcO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 05:32:14 -0400
Content-Disposition: inline
In-Reply-To: <20130312035319.GB6142@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Tue 12-03-13 11:53:19, Zheng Liu wrote:
> On Mon, Mar 11, 2013 at 09:38:34PM +0100, Jan Kara wrote:
> >   Hello,
> > 
> >   while looking into the ext4 code I spotted one thing which I think is a
> > bug introduced by extent status tree code. The problem is that
> > ext4_map_blocks() checks extent status tree and if the extent is found, it
> > doesn't call into ext4_ext_map_blocks(). However ext4_ext_direct_IO() expects
> > that if the extent DIO is done to is unwritten, EXT4_IO_END_UNWRITTEN flag
> > gets set in the io_end (or inode) flags and that happens only in
> > ext4_ext_map_blocks().
> > 
> > The easiest fix seems to be to move setting of flags from
> > ext4_ext_map_blocks() up into ext4_map_blocks() (or maybe even
> > _ext4_get_block()). What do you think?
> 
> Hi Jan,
> 
> Thanks for reviewing the code.  But I don't think it is a potential bug.
> Let's see what happens after adding extent status tree.  There are three
> cases that we need to take care, a) no block has been allocated, b)
> unwritten extent has been allocated, and c) written extent has been
> allocated.
> 
> a) no block has been allocated.
> In this case, both extent tree on disk and status tree in memory haven't
> this extent.  When we do a extent-based dio write, ext4_get_block_write
> will be called with EXT4_GET_BLOCKS_IO_CREATE_EXT flag.  In
> ext4_map_blocks(), the codepath looks like:
> 
> ext4_map_blocks()
>   ->ext4_es_lookup_extent()
>     [no extent found in status tree]
>   ->ext4_ext_map_blocks() without flags
>     [no extent found in extent tree]
>   ->ext4_ext_map_blocks() with EXT4_GET_BLOCKS_IO_CREATE_EXT
>     ->ext4_mb_new_blocks()
>       [allocate an unwritten extent]
>     ->ext4_set_io_unwritten_flag()
>       [set EXT4_IO_END_UNWRITTEN flag because _PRE_IO flag is set and an
>        unwritten extent has been allocated]
> 
> In this case, we are safe.
  Agreed.

> b) unwritten extent has been allocated
> In this case, both extent tree on disk and status tree in memory have an
> unwritten extent, and codepath looks like:
> 
> ext4_map_blocks()
>   ->ext4_es_lookup_extent()
>     [unwritten extent found in status tree, EXT4_MAP_UNWRITTEN flag is
>      marked in map->m_flags.  In the mean time, ext4_ext_map_blocks()
>      isn't called]
>   [But we don't return from ext4_map_blocks because EXT4_GET_BLOCKS_CREATE
>    flag is set and EXT4_MAP_MAPPED flag is not set]
>   ->ext4_ext_map_blocks() with EXT4_GET_BLOCKS_IO_CREATE_EXT
>     ->ext4_ext_handle_uninitialized_extents()
>       ->ext4_set_io_unwritten_flag()
>         [set EXT4_IO_END_UNWRITTEN flag because _PRE_IO flag is set]
> 
> So it seems that there is no bug.
  Ah, right. This is what I was missing. I didn't realize that we won't
set EXT4_MAP_MAPPED when the extent is unwritten so we will end up calling
ext4_ext_map_blocks() later. Sorry for the noise.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
