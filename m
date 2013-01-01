From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 3/9 v1] ext4: add physical block and status member
 into extent status tree
Date: Tue, 1 Jan 2013 13:16:07 +0800
Message-ID: <20130101051607.GB7546@gmail.com>
References: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
 <1356335742-11793-4-git-send-email-wenqing.lz@taobao.com>
 <20121231214952.GL7564@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58168 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3AAFCa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jan 2013 00:02:30 -0500
Received: by mail-pa0-f49.google.com with SMTP id bi1so7386276pad.22
        for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2012 21:02:29 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121231214952.GL7564@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 31, 2012 at 10:49:52PM +0100, Jan Kara wrote:
> On Mon 24-12-12 15:55:36, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > es_pblk is used to record physical block that maps to the disk.  es_status is
> > used to record the status of the extent.  Three status are defined, which are
> > written, unwritten and delayed.
>   So this means one extent is 48 bytes on 64-bit architectures. If I'm a
> nasty user and create artificially fragmented file (by allocating every
> second block), extent tree takes 6 MB per GB of file. That's quite a bit
> and I think you need to provide a way for kernel to reclaim extent
> structures...

Indeed, when a file has a lot of fragmentations, status tree will occupy
a number of memory.  That is why it will be loaded on-demand.  When I make
it, there are two solutions to load status tree.  One is loading
on-demand, and another is loading complete extent tree in
ext4_alloc_inode().  Finally I choose the former because it can reduce
the pressure of memory at most of time.  But it has a disadvantage that
status tree doesn't be fully trusted because it hasn't track a
completely status of extent tree on disk.

I will provide a way to reclaim extent structures from status tree.  Now
I have an idea in my mind that we can reclaim all extent which are
WRITTEN/UNWRITTEN status because we always need DELAYED extent in
fiemap, seek_data/hole and bigalloc code.  Furthermore, as you said in
another mail, some unwritten extent which will be converted into
written also doesn't be reclaimed.

Another question is when do these extents reclaim?  Currently when
clear_inode() is called, the whole status tree will be reclaimed.  Maybe
a switch in sysfs is a optional choice.  Any thoughts?

Thanks,
                                                - Zheng
