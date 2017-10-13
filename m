From: Eryu Guan <eguan@redhat.com>
Subject: Re: [v4.14-rc3 bug] scheduling while atomic in generic/451 test on
 extN
Date: Fri, 13 Oct 2017 13:51:26 +0800
Message-ID: <20171013055126.GO10593@eguan.usersys.redhat.com>
References: <20171005060700.GF8034@eguan.usersys.redhat.com>
 <20171012150740.GD31488@quack2.suse.cz>
 <20171012165707.GJ10593@eguan.usersys.redhat.com>
 <20171012191815.GB32738@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        lczerner@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753266AbdJMFv2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 13 Oct 2017 01:51:28 -0400
Content-Disposition: inline
In-Reply-To: <20171012191815.GB32738@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 12, 2017 at 09:18:15PM +0200, Jan Kara wrote:
> On Fri 13-10-17 00:57:07, Eryu Guan wrote:
> > On Thu, Oct 12, 2017 at 05:07:40PM +0200, Jan Kara wrote:
> > > Hi Eryu!
> > > 
> > > On Thu 05-10-17 14:07:00, Eryu Guan wrote:
> > > > I hit "scheduling while atomic" bug by running fstests generic/451 on
> > > > extN filesystems in v4.14-rc3 testing, but it didn't reproduce for me on
> > > > every host I tried, but I've seen it multiple times on multiple hosts. A
> > > > test vm of mine with 4 vcpus and 8G memory reproduced the bug reliably,
> > > > while a bare metal host with 8 cpus and 8G mem couldn't.
> > > > 
> > > > This is due to commit 332391a9935d ("fs: Fix page cache inconsistency
> > > > when mixing buffered and AIO DIO"), which defers AIO DIO io completion
> > > > to a workqueue if the inode has mapped pages and does page cache
> > > > invalidation in process context. I think that the problem is that the
> > > > pages can be mapped after the dio->inode->i_mapping->nrpages check, so
> > > > we're doing page cache invalidation, which could sleep, in interrupt
> > > > context, thus "scheduling while atomic" bug happens.
> > > > 
> > > > Defering all AIO DIO completion to workqueue unconditionally (as what
> > > > the iomap based path does) fixed the problem for me. But there're
> > > > performance concerns to do so in the original discussions.
> > > > 
> > > > https://www.spinics.net/lists/linux-fsdevel/msg112669.html
> > > 
> > > Thanks for report and the detailed analysis. I think your analysis is
> > > correct and the nrpages check in dio_bio_end_aio() is racy. My solution to
> > > this would be to pass to dio_complete() as an argument whether invalidation
> > > is required or not (and set it to true for deferred completion and to false
> > > when we decide not to defer completion since nrpages is 0 at that moment).
> > > Lukas?
> > 
> > But wouldn't that bring the original bug back? i.e. read the stale data
> > from pagecache, because it's possible that we need to invalidate the
> > caches but we didn't.
> 
> I don't think so. dio_bio_end_aio() gets called when the storage has
> acknowledged the data is stored. Thus once that is invoked, if we establish
> new page cache page, it will be loaded with new data and thus we won't
> carry stale data in it.

I think you're right, I missed that. Thanks for the explanation!

Eryu

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
