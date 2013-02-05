From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/9 v4] ext4: track all extent status in extent status
 tree
Date: Tue, 5 Feb 2013 14:27:38 +0100
Message-ID: <20130205132738.GA7959@quack.suse.cz>
References: <1359609477-29845-1-git-send-email-wenqing.lz@taobao.com>
 <1359609477-29845-6-git-send-email-wenqing.lz@taobao.com>
 <20130131165055.GF4612@quack.suse.cz>
 <20130201053308.GA6274@gmail.com>
 <20130204112709.GC7523@quack.suse.cz>
 <20130205033221.GA18864@gmail.com>
 <20130205120854.GC5943@quack.suse.cz>
 <20130205132433.GA27601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab3BEN1l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2013 08:27:41 -0500
Content-Disposition: inline
In-Reply-To: <20130205132433.GA27601@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 05-02-13 21:24:33, Zheng Liu wrote:
> On Tue, Feb 05, 2013 at 01:08:54PM +0100, Jan Kara wrote:
> [snip]
> > > After tracking all extent status in status tree, ext4_es_find_extent()
> > > returns not only delayed extent, but also written/unwritten extents.  So
> > > it is possible that next_del == next and its value is not
> > > EXT_MAX_BLOCKS.  *But* in latest version ext4_es_find_extent() will be
> > > changed to only return delayed extent.  So the problem will be fixed.
> >   Ah, now I see. You added the condition checking whether extent is delayed
> > only to the newex->ec_start == 0 branch. So if we don't take that branch,
> > we could have returned an extent which isn't delayed.
> > 
> > IMHO it is a wrong decision for ext4_es_find_extent() to return only
> > delayed extents. That should really return any extent that contains given
> > block (or is after it). It is ext4_find_delayed_extent() that should really
> > be changed to return only delayed extents as its name suggests...
> 
> I revised the patch series and found that ext4_es_find_extent() is
> only used to lookup a delayed extent by the following functions:
> 
>  - ext4_find_delalloc_range()
>  - ext4_find_delayed_extent()
>  - ext4_seek_data()
>  - ext4_seek_hole()
> 
> So IMHO the better decision is to rename it to ext4_es_find_delayed_extent()
> and let it only return delayed extent.  In patch 6/9, a new function
> called ext4_es_lookup_extent() is defined to do this job that returns an
> extent that contains given block.  What do you think?
  Yes, this works for me. Thanks for looking into it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
