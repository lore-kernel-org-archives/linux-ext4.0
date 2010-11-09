From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Date: Mon, 8 Nov 2010 22:30:38 -0500
Message-ID: <20101109033038.GF3099@thunk.org>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
 <20101109011222.GD2715@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	joel.becker@oracle.com, cmm@us.ibm.com, cluster-devel@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35768 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab0KIDat (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Nov 2010 22:30:49 -0500
Content-Disposition: inline
In-Reply-To: <20101109011222.GD2715@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 09, 2010 at 12:12:22PM +1100, Dave Chinner wrote:
> Hole punching was not included originally in fallocate() for a
> variety of reasons. IIRC, they were along the lines of:
> 
> 	1 de-allocating of blocks in an allocation syscall is wrong.
> 	  People wanted a new syscall for this functionality.
> 	2 no glibc interface needs it
> 	3 at the time, only XFS supported punching holes, so there
> 	  is not need to support it in a generic interface
> 	4 the use cases presented were not considered compelling
> 	  enough to justify the additional complexity (!)
> 
> In the end, I gave up arguing for it to be included because just
> getting the FALLOC_FL_KEEP_SIZE functionality was a hard enough
> battle.
> 
> Anyway, #3 isn't the case any more, #4 was just an excuse not to
> support anything ext4 couldn't do and lots of apps are calling
> fallocate directly (because glibc can't use FALLOC_FL_KEEP_SIZE) so
> #2 isn't an issue, either.

I don't recall anyone arguing #4 because of ext4, but I get very tired
of the linux-fsdevel bike-shed painting parties, so I often will
concede whatever is necessary just to get the !@#! interface in,
assuming we could add more flags later....

glibc does support fallocate(), BTW; it's just posix_fallocate() that
doesn't use FALLOC_FL_KEEP_SIZE.

> I guess that leaves #1 to be debated;
> I don't think there is any problem with doing what you propose.

I don't have a problem either.

As a completely separate proposal, what do people think about an
FALLOCATE_FL_ZEROIZE after which time the blocks are allocated, but
reading from them returns zero.  This could be done either by (a)
sending a discard in the case of devices where discard_zeros_data is
true and discard_granularty is less than the fs block size, or (b) by
setting the uninitialized flag in the extent tree.

						- Ted
