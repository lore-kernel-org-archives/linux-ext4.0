From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd/2[stable only]: Use WRITE_SYNC_PLUG in
 journal_commit_transaction.
Date: Thu, 14 Jul 2011 23:38:22 +0200
Message-ID: <20110714213822.GC16415@quack.suse.cz>
References: <1310467431-23108-1-git-send-email-tm@tao.ma>
 <20110712123041.GC1293@redhat.com>
 <4E1C65EA.5060009@tao.ma>
 <x4962n4g6zb.fsf@segfault.boston.devel.redhat.com>
 <20110714194657.GA16415@quack.suse.cz>
 <x49d3hck4lj.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Tao Ma <tm@tao.ma>,
	Vivek Goyal <vgoyal@redhat.com>, linux-ext4@vger.kernel.org,
	stable@kernel.org, Corrado Zoccolo <czoccolo@gmail.com>,
	Jens Axboe <jaxboe@fusionio.com>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab1GNViY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jul 2011 17:38:24 -0400
Content-Disposition: inline
In-Reply-To: <x49d3hck4lj.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 14-07-11 16:08:24, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Thu 14-07-11 12:30:32, Jeff Moyer wrote:
> >> Tao Ma <tm@tao.ma> writes:
> >> >> - WRITE_SYNC_PLUG will plug the queue and expects explicity unplug. Who
> >> >>   is doing unplug in this case?
> >> > See the comments I removed, "we rely on sync_buffer() doing the unplug
> >> > for us". I removed them cause we all use pluged write now.
> >> 
> >> Your logic is upside-down.  The code currently only uses the _PLUG
> >> variant when t_synchronous_commit is set, meaning somebody *will* call
> >> sync_buffer.  Simply setting WRITE_SYNC_PLUG doens't mean the upper
> >> layer is going to issue the unplug.  Of course, I'm not 100% sure of the
> >> journaling process, so it may very well be that there always is an
> >> unplug.  Can Jan or someone comment on that?  Anyway, you could test
> >> this theory by seeing if your kernel generates any timer unplugs in the
> >> blktrace output.
> >   So I'm not expert in plugging code but from what I understand when we do
> > wait_on_buffer() (which calls io_schedule()) which will do
> > blk_flush_plug()), the queue will get unplugged and IO starts. And we wait
> > for all buffers we submit so we are guaranteed wait_on_buffer() will be
> > called...
> 
> Sorry, I should have been more specific.  As Vivek mentioned, we're
> talking about older kernels (pre the blk plugging series).  So, the
> question is, if journal_commit_transaction is called with
> t_synchronous_commit not set, will the underlying device ever be
> unplugged by the journal code?  My guess is there's no explicit unplug,
> so it's not correct to replace a WRITE_SYNC with a WRITE_SYNC_PLUG.
  There are no explicit unplugs in journalling code. But checking the code
in 2.6.37, I still see wait_on_buffer() calls sync_bh() which calls
blk_run_address_space() which ends up calling bdi->unplug_io_fn() so I
would say unplug is called anyway.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
