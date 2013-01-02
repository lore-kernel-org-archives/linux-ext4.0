From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH 3/9 v1] ext4: add physical block and status member
 into extent status tree
Date: Wed, 2 Jan 2013 12:22:55 +0100
Message-ID: <20130102112255.GA30633@quack.suse.cz>
References: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
 <1356335742-11793-4-git-send-email-wenqing.lz@taobao.com>
 <20121231214952.GL7564@quack.suse.cz>
 <20130101051607.GB7546@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab3ABLW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jan 2013 06:22:57 -0500
Content-Disposition: inline
In-Reply-To: <20130101051607.GB7546@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 01-01-13 13:16:07, Zheng Liu wrote:
> On Mon, Dec 31, 2012 at 10:49:52PM +0100, Jan Kara wrote:
> > On Mon 24-12-12 15:55:36, Zheng Liu wrote:
> > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > 
> > > es_pblk is used to record physical block that maps to the disk.  es_status is
> > > used to record the status of the extent.  Three status are defined, which are
> > > written, unwritten and delayed.
> >   So this means one extent is 48 bytes on 64-bit architectures. If I'm a
> > nasty user and create artificially fragmented file (by allocating every
> > second block), extent tree takes 6 MB per GB of file. That's quite a bit
> > and I think you need to provide a way for kernel to reclaim extent
> > structures...
> 
> Indeed, when a file has a lot of fragmentations, status tree will occupy
> a number of memory.  That is why it will be loaded on-demand.  When I make
> it, there are two solutions to load status tree.  One is loading
> on-demand, and another is loading complete extent tree in
> ext4_alloc_inode().  Finally I choose the former because it can reduce
> the pressure of memory at most of time.  But it has a disadvantage that
> status tree doesn't be fully trusted because it hasn't track a
> completely status of extent tree on disk.
  Not reading the whole extent tree in ext4_alloc_inode() is a good start
but it's not the whole solution IMHO. It saves us from unnecessary reading
of extents but still if someone reads the whole filesystem (like
grep -R "foo" /) you will still end up with all extents cached. And that
will make ext4 inodes pretty heavy in memory. Surely inode reclaim will
eventually release these inodes including cached extents but it is usually
more beneficial to cache the inode itself than more extents so allowing us
to strip cached extents without releasing inode itself would be good.

> I will provide a way to reclaim extent structures from status tree.  Now
> I have an idea in my mind that we can reclaim all extent which are
> WRITTEN/UNWRITTEN status because we always need DELAYED extent in
> fiemap, seek_data/hole and bigalloc code.  Furthermore, as you said in
> another mail, some unwritten extent which will be converted into
> written also doesn't be reclaimed.
> 
> Another question is when do these extents reclaim?  Currently when
> clear_inode() is called, the whole status tree will be reclaimed.  Maybe
> a switch in sysfs is a optional choice.  Any thoughts?
  The natural way to handle the shrinking is using 'shrinker' framework. In
this case, we could register a shrinker for shrinking extents. Just having
LRU of extents would increase the size of extent structure by 2 pointers
which is too big I'd think and I'm not yet sure how to choose extents for
reclaim in some other way. I will think about it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
