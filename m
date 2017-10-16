From: Jan Kara <jack@suse.cz>
Subject: Re: [v4.14-rc3 bug] scheduling while atomic in generic/451 test on
 extN
Date: Mon, 16 Oct 2017 10:17:08 +0200
Message-ID: <20171016081708.GF32738@quack2.suse.cz>
References: <20171005060700.GF8034@eguan.usersys.redhat.com>
 <20171012150740.GD31488@quack2.suse.cz>
 <20171013102842.7blegiipyftp3xcy@rh_laptop>
 <20171013132200.dvc33h26ezwqpqwm@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43355 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751501AbdJPIRJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 16 Oct 2017 04:17:09 -0400
Content-Disposition: inline
In-Reply-To: <20171013132200.dvc33h26ezwqpqwm@rh_laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 13-10-17 15:22:00, Lukas Czerner wrote:
> On Fri, Oct 13, 2017 at 12:28:42PM +0200, Lukas Czerner wrote:
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
> 
> Btw, instead of changing the arguments, can't we just use
> 
> if (current->flags & PF_WQ_WORKER)
> 
> to make sure we're called from the workqueue ?

I don't think that would be ideal since dio_complete() can be also called
in task's context where this check would fail...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
