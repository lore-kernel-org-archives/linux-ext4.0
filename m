From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Tue, 30 Oct 2012 14:38:25 +0100
Message-ID: <20121030133825.GA2260@quack.suse.cz>
References: <20121026101909.GB19617@blackbox.djwong.org>
 <20121027013524.GA19591@blackbox.djwong.org>
 <20121029181358.GG18767@quack.suse.cz>
 <20121029183051.GJ18767@quack.suse.cz>
 <20121030104837.2e4b06fc@notabene.brown>
 <20121030001008.GA372@quack.suse.cz>
 <20121030113441.7f62df51@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab2J3Ni2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2012 09:38:28 -0400
Content-Disposition: inline
In-Reply-To: <20121030113441.7f62df51@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 30-10-12 11:34:41, NeilBrown wrote:
> On Tue, 30 Oct 2012 01:10:08 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > On Tue 30-10-12 10:48:37, NeilBrown wrote:
> > > On Mon, 29 Oct 2012 19:30:51 +0100 Jan Kara <jack@suse.cz> wrote:
> > > 
> > > > On Mon 29-10-12 19:13:58, Jan Kara wrote:
> > > > > On Fri 26-10-12 18:35:24, Darrick J. Wong wrote:
> > > > > > This creates BDI_CAP_STABLE_WRITES, which indicates that a device requires
> > > > > > stable page writes.  It also plumbs in a sysfs attribute so that admins can
> > > > > > check the device status.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > >   I guess Jens Axboe <axboe@kernel.dk> would be the best target for this
> > > > > patch (so that he can merge it). The patch looks OK to me. You can add:
> > > > >   Reviewed-by: Jan Kara <jack@suse.cz>
> > > >   One more thing popped up in my mind: What about NFS, Ceph or md RAID5?
> > > > These could (at least theoretically) care about stable writes as well. I'm
> > > > not sure if they really started to use them but it would be good to at
> > > > least let them know.
> > > > 
> > > 
> > > What exactly are the semantics of BDI_CAP_STABLE_WRITES ?
> > > 
> > > If I set it for md/RAID5, do I get a cast-iron guarantee that no byte in any
> > > page submitted for write will ever change until after I call bio_endio()?
> >   Yes.
> > 
> > > If so, is this true for all filesystems? - I would expect a bigger patch would
> > > be needed for that.
> >   Actually the code is in kernel for quite some time already. The problem
> > is it is always enabled causing unnecessary performance issues for some
> > workloads. So these patches try to be more selective in when the code gets
> > enabled.
> > 
> > Regarding "all filesystems" question: If we update filemap_page_mkwrite()
> > to call wait_on_page_writeback() then it should be for all filesystems.
> 
> Cool.  I didn't realise it had progressed that far.
> 
> I guess it is time to look at the possibility of removing the
> 'copy-into-cache' step for full-page, well-aligned bi_iovecs.
> 
> I assume this applies to swap-out as well ??  It has been a minor source of
> frustration that when you swap-out to RAID1, you can occasionally get
> different data on the two devices because memory changed between the two DMA
> events.
  Really? I'm somewhat surprised. I was under the impression that when a
page is added to a swap cache it is unmapped so there should be no
modification to it possible while it is being swapped out. But maybe it
could get mapped back and modified after we unlock the page and submit the
bio. So mm/memory.c:do_swap_page() might need wait_on_page_writeback() as
well. But I'm not an expert on swap code. I guess I'll experiment with this
a bit. Thanks for a pointer.

								Honza
