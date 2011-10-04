From: Ted Ts'o <tytso@mit.edu>
Subject: Re: mkfs'ing a 48-bit fs... or not.
Date: Tue, 4 Oct 2011 00:00:33 -0400
Message-ID: <20111004040033.GM6684@thunk.org>
References: <4E8A2F3F.30700@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36207 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1JDEAg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 00:00:36 -0400
Content-Disposition: inline
In-Reply-To: <4E8A2F3F.30700@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 03, 2011 at 04:55:11PM -0500, Eric Sandeen wrote:
> Has anyone tried mke2fs at its limits?  The latest git tree seems to fail in several ways.
> (Richard Jones reported the initial failure)
> 
> # truncate --size 1152921504606846976 reallybigfile 
> # mke2fs -t ext4 reallybigfile
> 
> first,
> 
> Warning: the fs_type huge is not defined in mke2fs.conf
> 
> (when types "big" and "huge" got added, they never got a mke2fs.conf update?)

It used to be that an undefined file system type didn't flag an error.
It now does, so we should have definitions for them in mke2fs.conf.

> reallybigfile: Not enough space to build proposed filesystem while setting up superblock
> 
> because:
> 
>         fs->group_desc_count = (blk_t) ext2fs_div64_ceil(
>                 ext2fs_blocks_count(super) - super->s_first_data_block,
>                 EXT2_BLOCKS_PER_GROUP(super));
>         if (fs->group_desc_count == 0) {
>                 retval = EXT2_ET_TOOSMALL;
> 
> The div64_ceil returns > 2^32 (2^33, actually), and the cast to blk_t
> (which should be dgrp_t?) turns that into a 0.

Yep, that should be dgrp_t.  Oops.

> Trying it with "-O bigalloc" (which should be automatic at this size,
> I think?) just goes away for a very long time, I'm not sure what it's
> thinking about, or if it's in a loop somewhere (looking now).

Well, we probably do want to engage bigalloc automatically, at some
point (I want to wait until bigalloc is in commonly used kernels, at
least for community distro's).  I'm not sure what the best cluster
size to pick by default should be, though.  16k?  64k?

     	     		       	   	    	  - Ted
