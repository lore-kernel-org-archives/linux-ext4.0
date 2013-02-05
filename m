From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 5/9 v4] ext4: track all extent status in extent status
 tree
Date: Tue, 5 Feb 2013 21:24:33 +0800
Message-ID: <20130205132433.GA27601@gmail.com>
References: <1359609477-29845-1-git-send-email-wenqing.lz@taobao.com>
 <1359609477-29845-6-git-send-email-wenqing.lz@taobao.com>
 <20130131165055.GF4612@quack.suse.cz>
 <20130201053308.GA6274@gmail.com>
 <20130204112709.GC7523@quack.suse.cz>
 <20130205033221.GA18864@gmail.com>
 <20130205120854.GC5943@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59541 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab3BENKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2013 08:10:17 -0500
Received: by mail-pa0-f50.google.com with SMTP id fa11so137239pad.23
        for <linux-ext4@vger.kernel.org>; Tue, 05 Feb 2013 05:10:16 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130205120854.GC5943@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 05, 2013 at 01:08:54PM +0100, Jan Kara wrote:
[snip]
> > After tracking all extent status in status tree, ext4_es_find_extent()
> > returns not only delayed extent, but also written/unwritten extents.  So
> > it is possible that next_del == next and its value is not
> > EXT_MAX_BLOCKS.  *But* in latest version ext4_es_find_extent() will be
> > changed to only return delayed extent.  So the problem will be fixed.
>   Ah, now I see. You added the condition checking whether extent is delayed
> only to the newex->ec_start == 0 branch. So if we don't take that branch,
> we could have returned an extent which isn't delayed.
> 
> IMHO it is a wrong decision for ext4_es_find_extent() to return only
> delayed extents. That should really return any extent that contains given
> block (or is after it). It is ext4_find_delayed_extent() that should really
> be changed to return only delayed extents as its name suggests...

I revised the patch series and found that ext4_es_find_extent() is
only used to lookup a delayed extent by the following functions:

 - ext4_find_delalloc_range()
 - ext4_find_delayed_extent()
 - ext4_seek_data()
 - ext4_seek_hole()

So IMHO the better decision is to rename it to ext4_es_find_delayed_extent()
and let it only return delayed extent.  In patch 6/9, a new function
called ext4_es_lookup_extent() is defined to do this job that returns an
extent that contains given block.  What do you think?

[snip]
> > > > >   Hum, are you sure the extent status will be correct? Won't it be safer to
> > > > > just use whatever we have in 'map'?
> > > > 
> > > > Your meaning is that we need to ignore the error when we insert a extent
> > > > into the extent status tree, right?  But that would causes an
> > > > inconsistency between status tree and extent tree.  Further,
> > > > ext4_es_insert_extent() returns EINVAL or ENOMEM.  I believe that
> > > > reporting an error is a better choice.  What do you think?
> > >   No, I meant something else. For example you decide extent at given
> > > position is 'UNWRITTEN' just on the basis that someone passed
> > > EXT4_GET_BLOCKS_PRE_IO as get_blocks flags. How do you know? Cannot someone
> > > pass EXT4_GET_BLOCKS_PRE_IO and we actually find out the extent at given
> > > position is fully allocated extent (i.e. WRITTEN) so we do nothing? Then
> > > you would cache bad state in the extent tree... That's why I'd rather see
> > > we derive current 'status' from 'map' where we are sure to have correct
> > > information and don't have to guess it from passed flags.
> > 
> > First of all, we don't need to worry about this problem because we
> > always lookup an extent before trying to create it.  So when it is an
> > written extent, we will return from ext4_map_blocks() directly and won't
> > try to create it.  So status tree don't be touched.
>   So my argument isn't as much about whether you can deduce the correct
> result from flags passed to ext4_map_blocks() but rather that it simply
> isn't the right place where to look. The right place where to look what
> extent is at given position is 'map' where we store what we found. And you
> are right that ext4_ext_map_blocks() isn't properly returning
> EXT4_MAP_UNWRITTEN in some cases - thanks for noticing that - but then the
> right answer is to fix ext4_ext_map_blocks() to return it and not to hack
> around that in extent cache code... Believe me it will save us quite some
> head scratching later.

Fair enough.  I will try to fix it.

Thanks for your suggestion,
                                                - Zheng
