From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 07:03:14 +0930
Message-ID: <20090514213314.GN5146@kulgan>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan> <20090514212325.GG21316@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:59144 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbZENVdP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 17:33:15 -0400
Content-Disposition: inline
In-Reply-To: <20090514212325.GG21316@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 05:23:25PM -0400, Theodore Tso wrote:
> On Fri, May 15, 2009 at 06:32:45AM +0930, Kevin Shanahan wrote:
> > Okay, so now I've booted into 2.6.29.3 + check_block_validity patch +
> > short circuit i_cached_extent patch, mounted the fs without
> > nodelalloc. I was able to run the full exchange backup without
> > triggering the check_block_validity error.
> 
> Great!
> 
> So here's the final fix (it replaces the short circuit i_cached_extent
> patch) which I plan to push to Linus.  It should be much less of a
> performance hit than simply short-circuiting i_cached_extent...
> 
> Thanks so much for helping to find track this down!!!  If ever someone
> deserved an "Ext4 Baker Street Irregulars" T-shirt, it would be
> you....

Hehe, no problem. Will do the final testing shortly (ran out of time
this morning, users are back on the system now). Just one little
correction to your patch below:

> commit 039ed7a483fdcb2dbbc29f00cd0d74c101ab14c5
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu May 14 17:09:37 2009 -0400
> 
>     ext4: Fix race in ext4_inode_info.i_cached_extent
>     
>     If one CPU is reading from a file while another CPU is writing to the
>     same file different locations, there is nothing protecting the
>     i_cached_extent structure from being used and updated at the same
>     time.  This could potentially cause the wrong location on disk to be
>     read or written to, including potentially causing the corruption of
>     the block group descriptors and/or inode table.
>     
>     Many thanks to Ken Shannah for helping to track down this problem.
                     ^^^^^^^^^^^

Cheers,
Kevin Shanahan.
