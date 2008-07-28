From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: partially uptodate page reads
Date: Sun, 27 Jul 2008 23:51:24 -0700
Message-ID: <20080727235124.5b04fd8b.akpm@linux-foundation.org>
References: <200807250117.11331.nickpiggin@yahoo.com.au>
	<20080724175913.GA32117@infradead.org>
	<20080724120841.81c72be9.akpm@linux-foundation.org>
	<6.0.0.20.2.20080728115511.045088a8@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>, jack@ucw.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578AbYG1Gvl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2008 02:51:41 -0400
In-Reply-To: <6.0.0.20.2.20080728115511.045088a8@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Jul 2008 13:34:12 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> Hi
> 
> >> > 
> >> > Are there significant numbers of people using block size < page size in
> >> > situations where performance is important and significantly improved by
> >> > this patch? Can you give any performance numbers to illustrate perhaps?
> >> 
> >> With XFS lots of people use 4k blocksize filesystems on ia64 systems
> >> with 16k pages, so an optimization like this would be useful.
> >
> >As Nick says, we really should have some measurement results which
> >confirm this theory.  Maybe we did do some but they didn't find theor
> >way into the changelog.
> >
> >I've put the patch on hold until this confirmation data is available.
> >
> 
> I've got some performance number.
> I wrote a benchmark program and got result number with this program.
> This benchmark do:
> 	1, mount and open a test file.
> 	2, create a 512MB file.
> 	3, close a file and umount.
> 	4, mount and again open a test file.
> 	5, pwrite randomly 300000 times on a test file. offset is aligned by IO size(1024bytes).
> 	6, measure time of preading randomly 100000 times on a test file.
> 
> The result was:
> 	2.6.26
>         330 sec
> 
> 	2.6.26-patched
>         226 sec
> 
> Arch:i386 
> Filesystem:ext3
> Blocksize:1024 bytes
> Memory: 1GB
> 
> On ext3/4, a file is written through buffer/block. So random read/write mixed workloads
> or random read after random write workloads are optimized with this patch under 
> pagesize != blocksize environment. This test result showed this.

OK, thanks.  Those are pretty nice numbers for what is probably a
fairly common workload.
