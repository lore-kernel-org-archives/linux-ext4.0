From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfstests: fallocate + read/write tests, ext4
	regression tests
Date: Sun, 21 Jun 2009 15:17:32 -0400
Message-ID: <20090621191732.GB19596@infradead.org>
References: <4A370DD2.6080204@sandeen.net> <20090620175953.GC3984@infradead.org> <58093.76.66.127.206.1245531627.squirrel@www.sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55764 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZFUTR3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Jun 2009 15:17:29 -0400
Content-Disposition: inline
In-Reply-To: <58093.76.66.127.206.1245531627.squirrel@www.sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 20, 2009 at 04:00:27PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Mon, Jun 15, 2009 at 10:13:22PM -0500, Eric Sandeen wrote:
> >> New test to test basic mixed fallocate + read & write,
> >> includes a couple regression tests for bugs that ext4
> >> hit.  Uses xfs_io to generate fallocate calls, so requires
> >> git xfsprogs and very recent glibc at this point.
> >
> > Looks good to me, and again does the correct notrun for my 32-bit
> > VM.  Guess I need to do the raw syscall wireup i xfsprogs eventually..
> 
> I don't mind doing it either ... how many arches? :)

Most important is x86 I think.  arm might be the other really important
candidate.

