From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: enable many tests to run on ext2/3/4
Date: Sun, 24 May 2009 11:38:02 -0500
Message-ID: <4A1977EA.3000604@redhat.com>
References: <4A15B649.70801@redhat.com> <20090524143945.GA32554@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs mailing list <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59916 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbZEXQiY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 May 2009 12:38:24 -0400
In-Reply-To: <20090524143945.GA32554@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
> Wow, that's a nice start.  The only important thing missing is checking
> the filesystems after each test run for the non-xfs case.

Yep, that was in the back of my mind.  Probably needs more abstraction
to make that cleaner.

> Maybe we should put this in in stages?  The _supported_fs generic
> thing is a nice cleanup already for the existing xfs/nfs/udf setup
> and should go in ASAP.

sure, I can break it up.

> The _scratch_mkfs output fix in 069 could also be a separate patch.
> 
> The _setup_generic_testdir should be generalized to match XFS for the
> default case and just set testdir in _setup_testdir instead of
> another function.  Also the comment there should be updated.
> 
> Same for _cleanup_testdir.
> 
> Btw, the way udf and nfs are currently handled look not very nice to me.
> We should not set up the test device by default for any filesystem but
> rather have a -setup or similar option to set it up if needed.

many of them likely fail, too, some of the acl & attr tests have some
assumptions about xfs limits.

> In common I would indeed prefer a new fstype option, but we might aswell
> put the current version in as-is.  Especially if we could tie up a really
> generic fstype= that wouldn't require listing the filesystems if they
> don't require special mount options or similar.

Ok.  I'd even thought that maybe by default, w/o options, it should just
run as whatever $TEST_DEV is formatted to (though that's trickier for
nfs I guess)

> The only thing preventing that is as far as I can see the current difference
> in _require_scratch for xfs and udf vs the rest.  Which looks really weird
> to me, need to investigate what's going on.

I think this is because even for udf etc, it still expects $TEST_DIR to
be xfs, so swizzles around test & scratch. yeah, I agree that's messy.

> As for the generic group I must say I don't like it very much, the
> filtering of notrun (maybe only notrun because of the filesystem type
> mismatch) sounds much better to me.

yeah, after I ran it a bit more I think I tend to agree....

I'll work on breaking this up a bit and tidying up some of the loose
ends, since the basic approach seems sane to more than one person now  :)

Thanks,
-Eric
