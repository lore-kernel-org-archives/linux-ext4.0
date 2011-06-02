From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Thu, 2 Jun 2011 10:14:35 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106020953510.3931@dhcp-27-109.brq.redhat.com>
References: <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <4CE59C9E.6050902@teksavvy.com>
 <1290177488-sup-6540@think> <4CE68F80.7000607@teksavvy.com> <20101119145748.GB27919@infradead.org> <4CE695FF.20601@teksavvy.com> <20101207092749.GA26100@infradead.org> <1291740643-sup-2494@think> <BANLkTimkn7ZVAUJw6NfWVMECfe+C+82i+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-672173440-1307002481=:3931"
Cc: Chris Mason <chris.mason@oracle.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Mark Lord <kernel@teksavvy.com>,
	James Bottomley <james.bottomley@suse.de>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	sandeen <sandeen@redhat.com>, Dave Chinner <dchinner@redhat.com>
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759140Ab1FBIPD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2011 04:15:03 -0400
In-Reply-To: <BANLkTimkn7ZVAUJw6NfWVMECfe+C+82i+g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-672173440-1307002481=:3931
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 2 Jun 2011, Kyungmin Park wrote:

> On Wed, Dec 8, 2010 at 1:52 AM, Chris Mason <chris.mason@oracle.com> wrote:
> > Excerpts from Christoph Hellwig's message of 2010-12-07 04:27:49 -0500:
> >> On Fri, Nov 19, 2010 at 10:21:35AM -0500, Mark Lord wrote:
> >> > >I really hate to rely on this third party hearsay (from all sides), and
> >> > >have implement TRIM support in qemu now.  I'll soon install win7 and
> >> > >will check out the TRIM patters myself.
> >> >
> >> > Excellent!
> >>
> >> I did a Windows 7 installation under qemu today, and the result is:
> >
> > Great, thanks for testing this.
> >
> >>
> >>  - it TRIMs the whole device early during the installation
> >>  - after that I see a constant stream of small trims during the
> >>    installation.  It's using lots of non-contiguous ranges in a single
> >>    TRIM command, with sizes down to 8 sectors (4k) for a single range.
> >>  - after installation there's is some background-trimming going on
> >>    even when doing no user interaction with the VM at all.
> 
> Hi Lukas,
> 
> Now FITRIM is based on user interaction. So how about to implement the
> AUTO batched discard at kernel level?
> Idea is same as windows, make a single thread and iterate the
> superblocks and call the trim.
> 
> here's pseudo codes.
> 
> 1. generate the trim thread.
> 2. iterate the superblocks by iterate_supers() at fs/super.c
> 3. check the queue which support the discard feature or not.
> blk_queue_discard(q)
> 4. wait on events
> 5. call the sb->trim (need to re-introduce it)
> 
> The difficult things are how to define the events and how to trigger
> the trim thread.
> e.g., notified from block layer, called from filesystem and so on.
> 
> How do you think?

Hi Kyungmin,

generally I think this is a good idea and I thought about it as well.
However I also think that we might want to wait for the FITRIM and
discard supported devices to settle down to see how it performs and if
frequently calling discard on big chunks of the device does not have
some unwanted consequences (as Dave Chinner pointed out in a different
thread, that this automations usually do).

Regarding events, filesystem might watch amount of data written to it
(and it usually do right now) and trigger the event when it exceeds,
let's say 50% of the fs size and zero the counter. The downside of this
is that it is not controlled behaviour hence we'll end up with
unpredictable behaviour of the filesystem in the long term.

The solution might be (and it is something I want to look into)
infrastructure to determine size of the queue to the device from within
the filesystem (or vfs) so we can tell when it is busy and we want to wait,
or when it is doing nothing and we can discard.

Also per filesystem, or per device, control will be needed, so we can
selectively turn it on and off. But as I said I am not sure that this is
the best idea to do it right now, but others might have different
opinion.

Thanks!
-Lukas

> 
> Thank you,
> Kyungmin Park
> 
> >>  - removing files leads to an instant stream of TRIMs, again vectored
> >>    and of all sizes down to 4k.  Note that the TRIMs are a lot more
> >>    instant than even with btrfs and -o discard, which delays most
> >>    TRIMs until doing a sync.
> >
> > Btrfs will do some small trims right when the block is freed, especially
> > in fsync heavy workloads but this is a suboptimal thing I want to fix.
> >
> > The code tries to gather a whole transaction worth of trims and do them
> > after the commit is done.
> >
> > -chris
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 

-- 
--8323328-672173440-1307002481=:3931--
