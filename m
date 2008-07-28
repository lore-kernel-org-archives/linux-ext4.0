From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: partially uptodate page reads
Date: Mon, 28 Jul 2008 16:56:37 +1000
Message-ID: <200807281656.37908.nickpiggin@yahoo.com.au>
References: <200807250117.11331.nickpiggin@yahoo.com.au> <6.0.0.20.2.20080728115511.045088a8@172.19.0.2> <20080727235124.5b04fd8b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	Christoph Hellwig <hch@infradead.org>, jack@ucw.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:25961 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752018AbYG1G4r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2008 02:56:47 -0400
In-Reply-To: <20080727235124.5b04fd8b.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 28 July 2008 16:51, Andrew Morton wrote:
> On Mon, 28 Jul 2008 13:34:12 +0900 Hisashi Hifumi 
<hifumi.hisashi@oss.ntt.co.jp> wrote:
> > Hi
> >
> > >> > Are there significant numbers of people using block size < page size
> > >> > in situations where performance is important and significantly
> > >> > improved by this patch? Can you give any performance numbers to
> > >> > illustrate perhaps?
> > >>
> > >> With XFS lots of people use 4k blocksize filesystems on ia64 systems
> > >> with 16k pages, so an optimization like this would be useful.
> > >
> > >As Nick says, we really should have some measurement results which
> > >confirm this theory.  Maybe we did do some but they didn't find theor
> > >way into the changelog.
> > >
> > >I've put the patch on hold until this confirmation data is available.
> >
> > I've got some performance number.
> > I wrote a benchmark program and got result number with this program.
> > This benchmark do:
> > 	1, mount and open a test file.
> > 	2, create a 512MB file.
> > 	3, close a file and umount.
> > 	4, mount and again open a test file.
> > 	5, pwrite randomly 300000 times on a test file. offset is aligned by IO
> > size(1024bytes). 6, measure time of preading randomly 100000 times on a
> > test file.
> >
> > The result was:
> > 	2.6.26
> >         330 sec
> >
> > 	2.6.26-patched
> >         226 sec
> >
> > Arch:i386
> > Filesystem:ext3
> > Blocksize:1024 bytes
> > Memory: 1GB
> >
> > On ext3/4, a file is written through buffer/block. So random read/write
> > mixed workloads or random read after random write workloads are optimized
> > with this patch under pagesize != blocksize environment. This test result
> > showed this.

Yeah, thanks for the numbers.


> OK, thanks.  Those are pretty nice numbers for what is probably a
> fairly common workload.

What kind of workloads does this kind of thing?
