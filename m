From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfstests 218: very basic defragmentation testing
	for xfs & ext4
Date: Mon, 10 Aug 2009 10:09:30 -0400
Message-ID: <20090810140930.GA24174@infradead.org>
References: <4A5E3A37.5050306@redhat.com> <4A7A5CA8.8040702@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs mailing list <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053AbZHJOJd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 10:09:33 -0400
Content-Disposition: inline
In-Reply-To: <4A7A5CA8.8040702@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 05, 2009 at 11:31:36PM -0500, Eric Sandeen wrote:
> Test a few very basic defragmentation scenarios.
> 
> This test creates some files, runs defrag on them,
> and compares the before/after fragmentation as well
> as file md5sums and timestamps.
> 
> The test currently expects to find e4defrag in
> /usr/bin
> 
> It should be relatively easy to add more interestingly
> fragmented files to the tests, as well as to test
> that memory-mapped files aren't touched, etc - 
> but this gives us a framework.
> 
> V2: remount before checking file contents, and create
> common.defrag.

The patch loks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

Unfortunately it still fails on my Debian testing system with:

 QA output created by 218
 zero-length file:
-Before: 0
-After: 0
+Before: 1
+After: 1
 Sparse file (no blocks):
-Before: 0
-After: 0
+Before: 1
+After: 1

But that's due to a bug in filefrag that I have already reported to the
Debian BTS.

