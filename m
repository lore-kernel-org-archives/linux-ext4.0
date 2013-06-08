From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstests failure generic/239
Date: Sat, 8 Jun 2013 18:30:38 -0400
Message-ID: <20130608223038.GA19229@thunk.org>
References: <51B2A15F.1060704@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, hch@lst.de
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56189 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab3FHWaq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Jun 2013 18:30:46 -0400
Content-Disposition: inline
In-Reply-To: <51B2A15F.1060704@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 08, 2013 at 11:13:35AM +0800, Zhao Hongjiang wrote:
> 
> I run xfstests #239 against mainline 3.10.0-rc3, unfortunately it failure in my QEMU. I run the
> case a hundred times, it certainly hit the failure several times. The failure msg is as follow:
> 
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64  3.10.0-rc3-mainline
> 
> generic/239 1s ... - output mismatch (see /home/zhj/xfstests/results/generic/239.out.bad)
>     --- tests/generic/239.out   2013-06-07 22:04:09.000000000 -0400
>     +++ /home/zff/xfstests/results/generic/239.out.bad  2013-06-07 22:04:09.000000000 -0400
>     @@ -1,2 +1,515 @@
>      QA output created by 239
>     +hostname: Host name lookup failure

OK, so this hostname failure is weird; I'm not sure what's causing
this, but this I presume unrelated to the failure at hand.

>      Silence is golden
>     +0: 0x0
>     +1: 0x0
>     +2: 0x0
>     +3: 0x0

This indicates a problem.  Test generic/239 is running
aio-dio-hole-filling-race.c, which submits an asynchronous, direct I/O
4k write with a buffer containing non-zero contents to a sparse file,
and once the I/O has completed, it uses pread to read it back, using
the same descriptor, so it is doing the read using direct I/O.  It
then checks to see if the read returns zero or not.  

The "XX: 0x0" lines indicates that buffer is zero, which implies that
somehow aio_complete() is getting called before the uninitialized to
initialized conversion is taking place.  I'm not seeing how this is
happening, though, so I'm a bit puzzled.  If there are any unwritten
extents, we don't call aio_complete() in ext4_end_io_dio(), but
instead the conversion is queued via a call to ext4_add_compete_io(),
and and aio_done() is only called on the iocb after the conversion is
complete.

Can anyone see something that I might be missing?

    	       		      	      - Ted

P.S.  Zhao, what was the hardware that you using to find this failure?
I'm not seeing it, but then again if the failure is only happening
once every few hundred runs that might explain it.  I'm perhaps
wondering if we should add a mode to aio-dio-hole-filling-race.c which
allows it to try the race a large number of times, instead of just
once.

P.P.S.  One thought.... perhaps it might be useful to have a debug
mode where we use queue_delayed_work() to submit the conversion
request to the workqueue.  It will of course make certain workloads
run slow as molasses, but it might expose some races so we can see
them more easily.
