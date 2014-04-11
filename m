From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: fix over-pessimistic heuristic.
Date: Thu, 10 Apr 2014 23:39:15 -0400
Message-ID: <20140411033915.GA21215@thunk.org>
References: <1396788965-11777-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52754 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaDKDjS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 23:39:18 -0400
Content-Disposition: inline
In-Reply-To: <1396788965-11777-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 06, 2014 at 04:56:05PM +0400, Dmitry Monakhov wrote:
> In worst case we need one extent per moved block. Number of blocks to
> be moved is less or equals to blks_needed.

I can believe that the original safety margin of 0.2% of how much we
will be shrinking the file system might have been overly pessimistic.

However I'm concerned that your change might be over-optimistic.  For
example, if we are shrinking the file system down to under 500 blocks,
then the safety_margin will be 0 --- but it's could very easily be the
case that an extent tree will need to grow.

I'd accept this change, although I don't know it would make a
difference in the cases you are concerned about:

		blk64_t safe_margin = (ext2fs_blocks_count(fs->super) -
				       blks_needed)/500;
		if (safe_margin > blks_needed)
			safe_margin = blks_needed;

How and why are you using this?  I've never been all that exicited
about the -M option, since it's been abused in so many different ways,
and the result when you compress the file system that significantly is
often no good for performance.

					- Ted

