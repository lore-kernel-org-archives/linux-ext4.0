From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 8/9][e2fsprogs] Add 64-bit closefs interface.
Date: Mon, 12 May 2008 15:29:35 -0400
Message-ID: <20080512192935.GJ7029@mit.edu>
References: <20080509163928.15484.22146.stgit@gara> <20080509164018.15484.53983.stgit@gara> <20080512150550.GF7029@mit.edu> <20080512122443.7ef72b19@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42124 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751226AbYELT3r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 15:29:47 -0400
Content-Disposition: inline
In-Reply-To: <20080512122443.7ef72b19@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 12, 2008 at 12:24:43PM -0500, Jose R. Santos wrote:
> 
> I thought that we concluded that ext2fs_super_and_bgd_loc() would not
> do the right thing which is the reason that ext2fs_super_and_bgd_loc2()
> returns just the number of groups used by super block and group
> descriptors.  Right now, ext2fs_super_and_bgd_loc() works the same as
> it has before, and the new ext2fs_super_and_bgd_loc2() would do the
> right thing here by not assuming inode tables and bitmaps are located
> in the block group.
> 

I dealt with the situation by having ext2fs_initialize back out the
inode table accounting, which worked around the problem, and indeed
that's the only place where the numblocks value is even used.  So my
point is that if you make the change in ext2fs_super_and_bgd_loc2(),
it will have ripple effects to at least ext2fs_initialize() --- it
would not be safe to just change ext2fs_super_and_bgd_loc to
ext2fs_super_and_bgd_loc2, since you're making semantic change to what
the function actually returns.  

So by not including the change in ext2fs_initialize(), and because
ext2fs_initialize() doesn't call ext2fs_super_and_bgd_loc2() directly,
but indirectly through ext2fs_reserve_super_and_bgd(), we're setting
ourselves up to forget to make this change, and thus introduce a bug.
This is *especially* true since ext2fs_reserve_super_and_bgd() would
apparently not need to be changed since it doesn't return a blk_t ---
so it would be a case where the function wouldn't change, but its
behaviour (via its return code) would be changing, which is dangerous.

Practicing defensive programming is a good thing here, which is why I
suggested making it return numblocks via a pointer, and then very
carefully *documenting* what the new parameter contains, and then
documenting the change in ext2fs_reserve_super_and_bgd2(), and then in
turn to ext2fs_initialize(), is just a much safer way to go.  

     			     	       	    - Ted
