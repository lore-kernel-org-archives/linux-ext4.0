From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 00/25] e2fsprogs patchbomb 10/2013
Date: Fri, 18 Oct 2013 14:39:43 -0400
Message-ID: <20131018183943.GB6101@thunk.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47772 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112Ab3JRSjq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Oct 2013 14:39:46 -0400
Content-Disposition: inline
In-Reply-To: <20131018044854.7339.48457.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 09:48:54PM -0700, Darrick J. Wong wrote:
> 
> Ted, since you've accepted patches into -pu, do you want me to send
> patches against -pu as well?  Or put more bluntly, what are your
> thoughts about revert-and-replace of patches in -pu?  Patches 2, 6,
> 11, 23, and 24 have changed significantly since 9/30.

The pu branch is a rewinding patch.  What this means in practice is
that I'll accept those patches which I believe are aready, and for the
rest, I'll rewind the "dw/resize64-fuse" branch back to next, and
apply the rest onto the dw/resize64-fuse branch.  If I get a new set
of inline patches, I'd do the same thing.

Then when I update the pu branch, I rewind the pu branch to next, and
then merge in all of the "xx/yyyy" feature branches, resolving
conflicts along the way.  This makes it obvious which branches have
conflicts against each other, and it also allows me to run regression
tests against the combined set of feature patch sets that aren't quite
ready for next.

So in other words, no, you don't need to send patches against pu,
thanks!

      	    	       	   	      - Ted
