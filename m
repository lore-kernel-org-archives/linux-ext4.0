From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] improve ext3 fsync batching
Date: Mon, 18 Aug 2008 23:44:14 -0600
Message-ID: <20080819054414.GM3392@webber.adilger.int>
References: <20080806190819.GH27394@unused.rdu.redhat.com>
 <20080806191536.GI27394@unused.rdu.redhat.com>
 <20080818213128.3a76d1e8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
	rwheeler@redhat.com, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46028 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYHSFo1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Aug 2008 01:44:27 -0400
In-reply-to: <20080818213128.3a76d1e8.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 18, 2008  21:31 -0700, Andrew Morton wrote:
> On Wed, 6 Aug 2008 15:15:36 -0400 Josef Bacik <jbacik@redhat.com> wrote:
> > Using the following fs_mark command to test the speeds
> > 
> > ./fs_mark -d /mnt/ext3-test -s 4096 -n 2000 -D 64 -t 2
> > 
> > I got the following results (with write cacheing turned off)
> > 
> > type	threads		with patch	without patch
> > sata	2		26.4		27.8
> > sata	4		44.6		44.4
> > sata	8		70.4		72.8
> > sata	16		75.2		89.6
> > sata	32		92.7		96.0
> > ram	1		2399.1		2398.8
> > ram	2		257.3		3603.0
> > ram	4		395.6		4827.9
> > ram	8		659.0		4721.1
> > ram	16		1326.4		4373.3
> > ram	32		1964.2		3816.3
> > 
> > I used a ramdisk to emulate a "fast" disk since I don't happen to have a
> > clariion sitting around.  I didn't test single thread in the sata case as it
> > should be relatively the same between the two.  Thanks,
> 
> This is all a bit mysterious.  That delay doesn't have much at all to
> do with commit times.  The code is looping around giving other
> userspace processes an opportunity to get scheduled and to run an fsync
> and to join the current transaction rather than having to start a new
> one.
> 
> (that code was quite effective when I first added it, but in more
> recent testing, which was some time ago, it doesn't appear to provide
> any improvement.  This needs to be understood)

I don't think it is mysterious at all.  With a HZ=100 system 1 jiffie
is 10ms, which was comparable to the seek time of a disk, so sleeping
for 1 jiffie to avoid doing 2 transactions was a win.  With a flash
device (simulated by RAM here) seek time is 1ms so waiting 10ms
isn't going to be useful if there are only 2 threads and both have
already joined the transaction.

> Also, I'd expect that the average commit time is much longer that one
> jiffy on most disks, and perhaps even on fast disks and maybe even on
> ramdisk.  So perhaps what's happened here is that you've increased the
> sleep period and more tasks are joining particular transactions.
> 
> Or you've shortened the sleep time (which wasn't really doing anything
> useful) and this causes tasks to spend less time asleep.

I think both are true.  By making the sleep time dynamic it removes
the "useless" sleep time, but can also increase the sleep time if
there are many threads and the commit cost is better amortized over
more operations.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

