From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] jbd/2[stable only]: Use WRITE_SYNC_PLUG in
 journal_commit_transaction.
Date: Thu, 14 Jul 2011 16:01:00 -0400
Message-ID: <20110714200100.GI6672@redhat.com>
References: <1310467431-23108-1-git-send-email-tm@tao.ma>
 <20110712123041.GC1293@redhat.com>
 <4E1C65EA.5060009@tao.ma>
 <x4962n4g6zb.fsf@segfault.boston.devel.redhat.com>
 <20110714194657.GA16415@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org, stable@kernel.org,
	Corrado Zoccolo <czoccolo@gmail.com>,
	Jens Axboe <jaxboe@fusionio.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab1GNUBS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jul 2011 16:01:18 -0400
Content-Disposition: inline
In-Reply-To: <20110714194657.GA16415@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 14, 2011 at 09:46:57PM +0200, Jan Kara wrote:
> On Thu 14-07-11 12:30:32, Jeff Moyer wrote:
> > Tao Ma <tm@tao.ma> writes:
> > >> - WRITE_SYNC_PLUG will plug the queue and expects explicity unplug. Who
> > >>   is doing unplug in this case?
> > > See the comments I removed, "we rely on sync_buffer() doing the unplug
> > > for us". I removed them cause we all use pluged write now.
> > 
> > Your logic is upside-down.  The code currently only uses the _PLUG
> > variant when t_synchronous_commit is set, meaning somebody *will* call
> > sync_buffer.  Simply setting WRITE_SYNC_PLUG doens't mean the upper
> > layer is going to issue the unplug.  Of course, I'm not 100% sure of the
> > journaling process, so it may very well be that there always is an
> > unplug.  Can Jan or someone comment on that?  Anyway, you could test
> > this theory by seeing if your kernel generates any timer unplugs in the
> > blktrace output.
>   So I'm not expert in plugging code but from what I understand when we do
> wait_on_buffer() (which calls io_schedule()) which will do
> blk_flush_plug()), the queue will get unplugged and IO starts. And we wait
> for all buffers we submit so we are guaranteed wait_on_buffer() will be
> called...

But blk_flush_plug() is called only in recent kernels where problem is
not present anyway.

Tao is reporting problem in 2.6.38 and 2.6.39. My concern is that if we
send all the IO as WRITE_SYNC_UNPLUG and not really unplug the queue
explicitly then we might lose more time in waiting for timer unplugs
and not benefit that much from merging.

Thanks
Vivek
