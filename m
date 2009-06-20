From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfstests: fallocate + read/write tests, ext4
	regression tests
Date: Sat, 20 Jun 2009 13:59:53 -0400
Message-ID: <20090620175953.GC3984@infradead.org>
References: <4A370DD2.6080204@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40543 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbZFTR7u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Jun 2009 13:59:50 -0400
Content-Disposition: inline
In-Reply-To: <4A370DD2.6080204@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 15, 2009 at 10:13:22PM -0500, Eric Sandeen wrote:
> New test to test basic mixed fallocate + read & write,
> includes a couple regression tests for bugs that ext4
> hit.  Uses xfs_io to generate fallocate calls, so requires
> git xfsprogs and very recent glibc at this point.

Looks good to me, and again does the correct notrun for my 32-bit
VM.  Guess I need to do the raw syscall wireup i xfsprogs eventually..


Reviewed-by: Christoph Hellwig <hch@lst.de>

