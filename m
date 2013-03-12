From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Possible bug with extent status tree
Date: Tue, 12 Mar 2013 11:53:19 +0800
Message-ID: <20130312035319.GB6142@gmail.com>
References: <20130311203834.GA22229@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63253 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3CLDiC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Mar 2013 23:38:02 -0400
Received: by mail-pb0-f43.google.com with SMTP id md12so4557847pbc.16
        for <linux-ext4@vger.kernel.org>; Mon, 11 Mar 2013 20:38:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130311203834.GA22229@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 11, 2013 at 09:38:34PM +0100, Jan Kara wrote:
>   Hello,
> 
>   while looking into the ext4 code I spotted one thing which I think is a
> bug introduced by extent status tree code. The problem is that
> ext4_map_blocks() checks extent status tree and if the extent is found, it
> doesn't call into ext4_ext_map_blocks(). However ext4_ext_direct_IO() expects
> that if the extent DIO is done to is unwritten, EXT4_IO_END_UNWRITTEN flag
> gets set in the io_end (or inode) flags and that happens only in
> ext4_ext_map_blocks().
> 
> The easiest fix seems to be to move setting of flags from
> ext4_ext_map_blocks() up into ext4_map_blocks() (or maybe even
> _ext4_get_block()). What do you think?

Hi Jan,

Thanks for reviewing the code.  But I don't think it is a potential bug.
Let's see what happens after adding extent status tree.  There are three
cases that we need to take care, a) no block has been allocated, b)
unwritten extent has been allocated, and c) written extent has been
allocated.

a) no block has been allocated.
In this case, both extent tree on disk and status tree in memory haven't
this extent.  When we do a extent-based dio write, ext4_get_block_write
will be called with EXT4_GET_BLOCKS_IO_CREATE_EXT flag.  In
ext4_map_blocks(), the codepath looks like:

ext4_map_blocks()
  ->ext4_es_lookup_extent()
    [no extent found in status tree]
  ->ext4_ext_map_blocks() without flags
    [no extent found in extent tree]
  ->ext4_ext_map_blocks() with EXT4_GET_BLOCKS_IO_CREATE_EXT
    ->ext4_mb_new_blocks()
      [allocate an unwritten extent]
    ->ext4_set_io_unwritten_flag()
      [set EXT4_IO_END_UNWRITTEN flag because _PRE_IO flag is set and an
       unwritten extent has been allocated]

In this case, we are safe.

b) unwritten extent has been allocated
In this case, both extent tree on disk and status tree in memory have an
unwritten extent, and codepath looks like:

ext4_map_blocks()
  ->ext4_es_lookup_extent()
    [unwritten extent found in status tree, EXT4_MAP_UNWRITTEN flag is
     marked in map->m_flags.  In the mean time, ext4_ext_map_blocks()
     isn't called]
  [But we don't return from ext4_map_blocks because EXT4_GET_BLOCKS_CREATE
   flag is set and EXT4_MAP_MAPPED flag is not set]
  ->ext4_ext_map_blocks() with EXT4_GET_BLOCKS_IO_CREATE_EXT
    ->ext4_ext_handle_uninitialized_extents()
      ->ext4_set_io_unwritten_flag()
        [set EXT4_IO_END_UNWRITTEN flag because _PRE_IO flag is set]

So it seems that there is no bug.

c) written extent has been allocated
In this case, both extent tree on disk and status tree in memory have an
written extent and codepath looks like:

ext4_map_blocks()
  ->ext4_es_lookup_extent()
    [written extent found in status tree, EXT4_MAP_MAPPED flag is set in
     map->m_flags.  In the mean time, ext4_ext_map_blocks() isn't called]
  [we return directly because retval > 0 and EXT4_MAP_MAPPED is set, and
   *EXT4_IO_END_UNWRITTEN flag is not set*]

I guess that you are aruging this case.  If we don't apply status tree
code, the codepath will look like:

ext4_map_blocks()
  ->ext4_ext_map_blocks() without flags
    [written extent found in extent tree.  We return directly because
     retval > 0 and EXT4_MAP_MAPPED is set.]

Thus, it seems we are safe.  Am I miss something?

Thanks,
                                                - Zheng
