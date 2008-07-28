From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: partially uptodate page reads
Date: Mon, 28 Jul 2008 00:09:08 -0700
Message-ID: <20080728000908.869c3e85.akpm@linux-foundation.org>
References: <200807250117.11331.nickpiggin@yahoo.com.au>
	<6.0.0.20.2.20080728115511.045088a8@172.19.0.2>
	<20080727235124.5b04fd8b.akpm@linux-foundation.org>
	<200807281656.37908.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	Christoph Hellwig <hch@infradead.org>, jack@ucw.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbYG1HJ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2008 03:09:27 -0400
In-Reply-To: <200807281656.37908.nickpiggin@yahoo.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Jul 2008 16:56:37 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Monday 28 July 2008 16:51, Andrew Morton wrote:
> > On Mon, 28 Jul 2008 13:34:12 +0900 Hisashi Hifumi 
> <hifumi.hisashi@oss.ntt.co.jp> wrote:
> > > Hi
> > >
> > > >> > Are there significant numbers of people using block size < page size
> > > >> > in situations where performance is important and significantly
> > > >> > improved by this patch? Can you give any performance numbers to
> > > >> > illustrate perhaps?
> > > >>
> > > >> With XFS lots of people use 4k blocksize filesystems on ia64 systems
> > > >> with 16k pages, so an optimization like this would be useful.
> > > >
> > > >As Nick says, we really should have some measurement results which
> > > >confirm this theory.  Maybe we did do some but they didn't find theor
> > > >way into the changelog.
> > > >
> > > >I've put the patch on hold until this confirmation data is available.
> > >
> > > I've got some performance number.
> > > I wrote a benchmark program and got result number with this program.
> > > This benchmark do:
> > > 	1, mount and open a test file.
> > > 	2, create a 512MB file.
> > > 	3, close a file and umount.
> > > 	4, mount and again open a test file.
> > > 	5, pwrite randomly 300000 times on a test file. offset is aligned by IO
> > > size(1024bytes). 6, measure time of preading randomly 100000 times on a
> > > test file.
> > >
> > > The result was:
> > > 	2.6.26
> > >         330 sec
> > >
> > > 	2.6.26-patched
> > >         226 sec
> > >
> > > Arch:i386
> > > Filesystem:ext3
> > > Blocksize:1024 bytes
> > > Memory: 1GB
> > >
> > > On ext3/4, a file is written through buffer/block. So random read/write
> > > mixed workloads or random read after random write workloads are optimized
> > > with this patch under pagesize != blocksize environment. This test result
> > > showed this.
> 
> Yeah, thanks for the numbers.
> 
> 
> > OK, thanks.  Those are pretty nice numbers for what is probably a
> > fairly common workload.
> 
> What kind of workloads does this kind of thing?

Various databases?  (confused).

More likely pattern is 8k IOs with 16k pagesize or thereabouts.
