From: Theodore Tso <tytso@mit.edu>
Subject: Comments on respun 16T patches: group_desc_loops
Date: Mon, 11 Sep 2006 22:30:55 -0400
Message-ID: <20060912023055.GA31035@thunk.org>
References: <44E3855D.5040303@redhat.com> <20060830061825.GB8046@thunk.org> <44F5D66D.8030500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:30934 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S964983AbWILJN4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Sep 2006 05:13:56 -0400
To: Eric Sandeen <esandeen@redhat.com>
Content-Disposition: inline
In-Reply-To: <44F5D66D.8030500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 30, 2006 at 01:18:21PM -0500, Eric Sandeen wrote:
> http://people.redhat.com/esandeen/ext3/e2fsprogs-1.39-16T/e2fsprogs-hg-20060830-16T-patches.tar.gz

In the group_desc_loops patches in the above tarball:

>For loops iterating over all group descriptors, consistently define
>first_block and last_block in a way that they are inclusive of the
>range, and do not overflow.
>
>Previously on the last block group we did a test of <= first + dec_blocks;
>this would actually wrap back to 0 for a total block count of 2^32-1

As far as I can tell this is not a problem.  sb->s_last_block can be
at most 2**32-1 --- which means that the last valid block number is
actually 2**32-2, since block numbers are zero based.

So as long as the handling of the last block group is correct, I don't
think we actually need to make the <= to < change.  It's not wrong to
make the change, just not necessary as far as I can see.  
Also, there are some files for which the only change was variable
names.  That's fine, but the changelogs should state that.

So there is a last block group handling bug in ext2fs_check_desc(),
but I didn't see any other bugs that this patch would actually affect.
Am I missing anything?

Regards,

						- Ted

