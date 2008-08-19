From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] improve ext3 fsync batching
Date: Mon, 18 Aug 2008 21:31:28 -0700
Message-ID: <20080818213128.3a76d1e8.akpm@linux-foundation.org>
References: <20080806190819.GH27394@unused.rdu.redhat.com>
	<20080806191536.GI27394@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, rwheeler@redhat.com,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbYHSEcL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Aug 2008 00:32:11 -0400
In-Reply-To: <20080806191536.GI27394@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 6 Aug 2008 15:15:36 -0400 Josef Bacik <jbacik@redhat.com> wrote:

> Hello,
> 
> Fsync batching in ext3 is somewhat flawed when it comes to disks that are very
> fast.  Now we do an unconditional sleep for 1 second,

It sleeps for one jiffy, not one second.

> which is great on slow
> disks like SATA and such, but on fast disks this means just sitting around and
> waiting for nothing.  This patch measures the time it takes to commit a
> transaction to the disk, and sleeps based on the speed of the underlying disk.
> Using the following fs_mark command to test the speeds
> 
> ./fs_mark -d /mnt/ext3-test -s 4096 -n 2000 -D 64 -t 2
> 
> I got the following results (with write cacheing turned off)
> 
> type	threads		with patch	without patch
> sata	2		26.4		27.8
> sata	4		44.6		44.4
> sata	8		70.4		72.8
> sata	16		75.2		89.6
> sata	32		92.7		96.0
> ram	1		2399.1		2398.8
> ram	2		257.3		3603.0
> ram	4		395.6		4827.9
> ram	8		659.0		4721.1
> ram	16		1326.4		4373.3
> ram	32		1964.2		3816.3
> 
> I used a ramdisk to emulate a "fast" disk since I don't happen to have a
> clariion sitting around.  I didn't test single thread in the sata case as it
> should be relatively the same between the two.  Thanks,

This is all a bit mysterious.  That delay doesn't have much at all to
do with commit times.  The code is looping around giving other
userspace processes an opportunity to get scheduled and to run an fsync
and to join the current transaction rather than having to start a new
one.

(that code was quite effective when I first added it, but in more
recent testing, which was some time ago, it doesn't appear to provide
any improvement.  This needs to be understood)

Also, I'd expect that the average commit time is much longer that one
jiffy on most disks, and perhaps even on fast disks and maybe even on
ramdisk.  So perhaps what's happened here is that you've increased the
sleep period and more tasks are joining particular transactions.

Or you've shortened the sleep time (which wasn't really doing anything
useful) and this causes tasks to spend less time asleep.

Or something else.

