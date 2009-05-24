From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: enable many tests to run on ext2/3/4
Date: Sun, 24 May 2009 10:39:46 -0400
Message-ID: <20090524143945.GA32554@infradead.org>
References: <4A15B649.70801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs mailing list <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZEXOjq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 10:39:46 -0400
Content-Disposition: inline
In-Reply-To: <4A15B649.70801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Wow, that's a nice start.  The only important thing missing is checking
the filesystems after each test run for the non-xfs case.

Maybe we should put this in in stages?  The _supported_fs generic
thing is a nice cleanup already for the existing xfs/nfs/udf setup
and should go in ASAP.

The _scratch_mkfs output fix in 069 could also be a separate patch.

The _setup_generic_testdir should be generalized to match XFS for the
default case and just set testdir in _setup_testdir instead of
another function.  Also the comment there should be updated.

Same for _cleanup_testdir.

Btw, the way udf and nfs are currently handled look not very nice to me.
We should not set up the test device by default for any filesystem but
rather have a -setup or similar option to set it up if needed.

In common I would indeed prefer a new fstype option, but we might aswell
put the current version in as-is.  Especially if we could tie up a really
generic fstype= that wouldn't require listing the filesystems if they
don't require special mount options or similar.

The only thing preventing that is as far as I can see the current difference
in _require_scratch for xfs and udf vs the rest.  Which looks really weird
to me, need to investigate what's going on.

As for the generic group I must say I don't like it very much, the
filtering of notrun (maybe only notrun because of the filesystem type
mismatch) sounds much better to me.
