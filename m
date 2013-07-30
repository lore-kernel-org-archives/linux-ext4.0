From: Jan Kara <jack@suse.cz>
Subject: Re: xfstests failure generic/239
Date: Tue, 30 Jul 2013 17:48:01 +0200
Message-ID: <20130730154801.GA22013@quack.suse.cz>
References: <51B2A15F.1060704@huawei.com>
 <20130608223038.GA19229@thunk.org>
 <51F732FA.9090307@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, jack@suse.cz,
	linux-ext4@vger.kernel.org, hch@lst.de, khoroshilov@ispras.ru
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab3G3PsD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jul 2013 11:48:03 -0400
Content-Disposition: inline
In-Reply-To: <51F732FA.9090307@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 30-07-13 11:28:58, Zhao Hongjiang wrote:
> Hi, jack
> 
> I test the latest kernel 3.11-rc2 and it seems the problem is fix by the
> follow patch: commit id:97a851ed71cd9cc2542955e92a001c6ea3d21d35 (ext4:
> use io_end for multiple bios).  But it's so difficult to backport to
> kernel 3.4-stable, any suggestion for this?
  Backporting that patch to stable kernels is no-go. It is far to intrusive
for stable kernels. I was looking for a while how that patch could fix the
problem you were observing. I think there is a subtle race possible when
AIO DIO write completes before __blockdev_direct_IO() returns. In that case
we set iocb->private to NULL in ext4_end_io_dio() but we also key off
iocb->private in ext4_ext_direct_IO() as:
                if (iocb->private)
                        ext4_inode_aio_set(inode, NULL);

So in the case above we forget to reset inode's AIO pointer. That can then
cause strange effects with unwritten extent handling (although I admit I'm
not sure whether it can also cause the failure you observe) and
97a851ed71cd9cc2542955e92a001c6ea3d21d35 actually fixes that bug. You can
easily check whether you are hitting that bug or not by changing the above
condition from testing iocb->private to testing some private variable...
E.g. you could declare io_end and set it to NULL one level up in 
ext4_ext_direct_IO() and then test io_end != NULL in that condition.

								Honza

> On 2013/6/9 6:30, Theodore Ts'o wrote:
> > On Sat, Jun 08, 2013 at 11:13:35AM +0800, Zhao Hongjiang wrote:
> >>
> >> I run xfstests #239 against mainline 3.10.0-rc3, unfortunately it failure in my QEMU. I run the
> >> case a hundred times, it certainly hit the failure several times. The failure msg is as follow:
> >>
> >> FSTYP         -- ext4
> >> PLATFORM      -- Linux/x86_64  3.10.0-rc3-mainline
> >>
> >> generic/239 1s ... - output mismatch (see /home/zhj/xfstests/results/generic/239.out.bad)
> >>     --- tests/generic/239.out   2013-06-07 22:04:09.000000000 -0400
> >>     +++ /home/zff/xfstests/results/generic/239.out.bad  2013-06-07 22:04:09.000000000 -0400
> >>     @@ -1,2 +1,515 @@
> >>      QA output created by 239
> >>     +hostname: Host name lookup failure
> > 
> > OK, so this hostname failure is weird; I'm not sure what's causing
> > this, but this I presume unrelated to the failure at hand.
> > 
> >>      Silence is golden
> >>     +0: 0x0
> >>     +1: 0x0
> >>     +2: 0x0
> >>     +3: 0x0
> > 
> > This indicates a problem.  Test generic/239 is running
> > aio-dio-hole-filling-race.c, which submits an asynchronous, direct I/O
> > 4k write with a buffer containing non-zero contents to a sparse file,
> > and once the I/O has completed, it uses pread to read it back, using
> > the same descriptor, so it is doing the read using direct I/O.  It
> > then checks to see if the read returns zero or not.  
> > 
> > The "XX: 0x0" lines indicates that buffer is zero, which implies that
> > somehow aio_complete() is getting called before the uninitialized to
> > initialized conversion is taking place.  I'm not seeing how this is
> > happening, though, so I'm a bit puzzled.  If there are any unwritten
> > extents, we don't call aio_complete() in ext4_end_io_dio(), but
> > instead the conversion is queued via a call to ext4_add_compete_io(),
> > and and aio_done() is only called on the iocb after the conversion is
> > complete.
> > 
> > Can anyone see something that I might be missing?
> > 
> >     	       		      	      - Ted
> > 
> > P.S.  Zhao, what was the hardware that you using to find this failure?
> > I'm not seeing it, but then again if the failure is only happening
> > once every few hundred runs that might explain it.  I'm perhaps
> > wondering if we should add a mode to aio-dio-hole-filling-race.c which
> > allows it to try the race a large number of times, instead of just
> > once.
> > 
> > P.P.S.  One thought.... perhaps it might be useful to have a debug
> > mode where we use queue_delayed_work() to submit the conversion
> > request to the workqueue.  It will of course make certain workloads
> > run slow as molasses, but it might expose some races so we can see
> > them more easily.
> > 
> > .
> > 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
