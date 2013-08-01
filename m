From: Jan Kara <jack@suse.cz>
Subject: Re: xfstests failure generic/239
Date: Thu, 1 Aug 2013 11:10:46 +0200
Message-ID: <20130801091046.GD19219@quack.suse.cz>
References: <51B2A15F.1060704@huawei.com>
 <20130608223038.GA19229@thunk.org>
 <51F732FA.9090307@huawei.com>
 <20130730154801.GA22013@quack.suse.cz>
 <51F8799D.7070202@huawei.com>
 <20130731141340.GB22930@quack.suse.cz>
 <51F9C254.1000207@huawei.com>
 <20130801084941.GB19219@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, hch@lst.de, khoroshilov@ispras.ru
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab3HAJKs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Aug 2013 05:10:48 -0400
Content-Disposition: inline
In-Reply-To: <20130801084941.GB19219@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 01-08-13 10:49:41, Jan Kara wrote:
>   Hi,
> 
> On Thu 01-08-13 10:05:08, Zhao Hongjiang wrote:
> > It hit this bug, the "Bug happened!" is come out everytime while the test
> > is fail.  Any suggestion for fix this?
>   OK, so the test is still failing after using io_end instead of
> iocb->private? If yes, I'm not sure where the problem exactly is, sorry.
  Just one addition: But from the fact that debug printk triggers we see
that really the problem happens when DIO is completed before
__blockdev_direct_IO() returns and thus extent conversion can race with
parts of __blockdev_direct_IO() or ext4_ext_direct_IO(). That is impossible
after my patch because ext4_ext_direct_IO() holds a reference to io_end so
it gets queued for completion only after __blockdev_direct_IO() returns. So
at least I somewhat understand why my patch makes a difference.

 
 								Honza

> > On 2013/7/31 22:13, Jan Kara wrote:
> > > On Wed 31-07-13 10:42:37, Zhao Hongjiang wrote:
> > >> On 2013/7/30 23:48, Jan Kara wrote:
> > >>> On Tue 30-07-13 11:28:58, Zhao Hongjiang wrote:
> > >>>> Hi, jack
> > >>>>
> > >>>> I test the latest kernel 3.11-rc2 and it seems the problem is fix by the
> > >>>> follow patch: commit id:97a851ed71cd9cc2542955e92a001c6ea3d21d35 (ext4:
> > >>>> use io_end for multiple bios).  But it's so difficult to backport to
> > >>>> kernel 3.4-stable, any suggestion for this?
> > >>>   Backporting that patch to stable kernels is no-go. It is far to intrusive
> > >>> for stable kernels. I was looking for a while how that patch could fix the
> > >>> problem you were observing. I think there is a subtle race possible when
> > >>> AIO DIO write completes before __blockdev_direct_IO() returns. In that case
> > >>> we set iocb->private to NULL in ext4_end_io_dio() but we also key off
> > >>> iocb->private in ext4_ext_direct_IO() as:
> > >>>                 if (iocb->private)
> > >>>                         ext4_inode_aio_set(inode, NULL);
> > >>>
> > >>> So in the case above we forget to reset inode's AIO pointer. That can then
> > >>> cause strange effects with unwritten extent handling (although I admit I'm
> > >>> not sure whether it can also cause the failure you observe) and
> > >>> 97a851ed71cd9cc2542955e92a001c6ea3d21d35 actually fixes that bug. You can
> > >>> easily check whether you are hitting that bug or not by changing the above
> > >>> condition from testing iocb->private to testing some private variable...
> > >>> E.g. you could declare io_end and set it to NULL one level up in 
> > >>> ext4_ext_direct_IO() and then test io_end != NULL in that condition.
> > >>>
> > >> Thanks for your reply first. 
> > >> I change the code like the follow:
> > >>
> > >> @@ -2921,6 +2921,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
> > >>         struct inode *inode = file->f_mapping->host;
> > >>         ssize_t ret;
> > >>         size_t count = iov_length(iov, nr_segs);
> > >> +       ext4_io_end_t *io_end = NULL;
> > >>
> > >>         loff_t final_size = offset + count;
> > >>         if (rw == WRITE && final_size <= inode->i_size) {
> > >> @@ -2947,8 +2948,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
> > >>                 iocb->private = NULL;
> > >>                 EXT4_I(inode)->cur_aio_dio = NULL;
> > >>                 if (!is_sync_kiocb(iocb)) {
> > >> -                       ext4_io_end_t *io_end =
> > >> -                               ext4_init_io_end(inode, GFP_NOFS);
> > >> +                       io_end = ext4_init_io_end(inode, GFP_NOFS);
> > >>                         if (!io_end)
> > >>                                 return -ENOMEM;
> > >>                         io_end->flag |= EXT4_IO_END_DIRECT;
> > >> @@ -2970,8 +2970,10 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
> > >>                                          ext4_end_io_dio,
> > >>                                          NULL,
> > >>                                          DIO_LOCKING);
> > >> -               if (iocb->private)
> > >> +               if (io_end != NULL) {
> > >> +                       printk("Zhao Hongjiang Ext4 test!\n");
> > >>                         EXT4_I(inode)->cur_aio_dio = NULL;
> > >> +               }
> > >>                 /*
> > >>                  * The io_end structure takes a reference to the inode,
> > >>                  * that structure needs to be destroyed and the
> > >>
> > >> And the print come out when i run the test everytime. So i think the test
> > >> hit the bug that you mentioned, Am i right or miss something?
> > >   It is not a bug that you hit the branch with printk(). It would be a bug
> > > if the debug check looked like:
> > > 	if (io_end != NULL) {
> > > 		if (iocb->private == NULL)
> > > 			printk("Bug happened!\n");
> > > 		EXT4_I(inode)->cur_aio_dio = NULL;
> > > 	}
> > > 
> > > 								Honza
> > > 
> > >>>> On 2013/6/9 6:30, Theodore Ts'o wrote:
> > >>>>> On Sat, Jun 08, 2013 at 11:13:35AM +0800, Zhao Hongjiang wrote:
> > >>>>>>
> > >>>>>> I run xfstests #239 against mainline 3.10.0-rc3, unfortunately it failure in my QEMU. I run the
> > >>>>>> case a hundred times, it certainly hit the failure several times. The failure msg is as follow:
> > >>>>>>
> > >>>>>> FSTYP         -- ext4
> > >>>>>> PLATFORM      -- Linux/x86_64  3.10.0-rc3-mainline
> > >>>>>>
> > >>>>>> generic/239 1s ... - output mismatch (see /home/zhj/xfstests/results/generic/239.out.bad)
> > >>>>>>     --- tests/generic/239.out   2013-06-07 22:04:09.000000000 -0400
> > >>>>>>     +++ /home/zff/xfstests/results/generic/239.out.bad  2013-06-07 22:04:09.000000000 -0400
> > >>>>>>     @@ -1,2 +1,515 @@
> > >>>>>>      QA output created by 239
> > >>>>>>     +hostname: Host name lookup failure
> > >>>>>
> > >>>>> OK, so this hostname failure is weird; I'm not sure what's causing
> > >>>>> this, but this I presume unrelated to the failure at hand.
> > >>>>>
> > >>>>>>      Silence is golden
> > >>>>>>     +0: 0x0
> > >>>>>>     +1: 0x0
> > >>>>>>     +2: 0x0
> > >>>>>>     +3: 0x0
> > >>>>>
> > >>>>> This indicates a problem.  Test generic/239 is running
> > >>>>> aio-dio-hole-filling-race.c, which submits an asynchronous, direct I/O
> > >>>>> 4k write with a buffer containing non-zero contents to a sparse file,
> > >>>>> and once the I/O has completed, it uses pread to read it back, using
> > >>>>> the same descriptor, so it is doing the read using direct I/O.  It
> > >>>>> then checks to see if the read returns zero or not.  
> > >>>>>
> > >>>>> The "XX: 0x0" lines indicates that buffer is zero, which implies that
> > >>>>> somehow aio_complete() is getting called before the uninitialized to
> > >>>>> initialized conversion is taking place.  I'm not seeing how this is
> > >>>>> happening, though, so I'm a bit puzzled.  If there are any unwritten
> > >>>>> extents, we don't call aio_complete() in ext4_end_io_dio(), but
> > >>>>> instead the conversion is queued via a call to ext4_add_compete_io(),
> > >>>>> and and aio_done() is only called on the iocb after the conversion is
> > >>>>> complete.
> > >>>>>
> > >>>>> Can anyone see something that I might be missing?
> > >>>>>
> > >>>>>     	       		      	      - Ted
> > >>>>>
> > >>>>> P.S.  Zhao, what was the hardware that you using to find this failure?
> > >>>>> I'm not seeing it, but then again if the failure is only happening
> > >>>>> once every few hundred runs that might explain it.  I'm perhaps
> > >>>>> wondering if we should add a mode to aio-dio-hole-filling-race.c which
> > >>>>> allows it to try the race a large number of times, instead of just
> > >>>>> once.
> > >>>>>
> > >>>>> P.P.S.  One thought.... perhaps it might be useful to have a debug
> > >>>>> mode where we use queue_delayed_work() to submit the conversion
> > >>>>> request to the workqueue.  It will of course make certain workloads
> > >>>>> run slow as molasses, but it might expose some races so we can see
> > >>>>> them more easily.
> > >>>>>
> > >>>>> .
> > 
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
