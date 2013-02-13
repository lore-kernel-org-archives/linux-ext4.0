From: Theodore Ts'o <tytso@mit.edu>
Subject: Merge window planning for ext4 and Ted's vacation
Date: Wed, 13 Feb 2013 10:08:41 -0500
Message-ID: <20130213150841.GA17431@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <20130209171015.GC8091@thunk.org>
 <20130212215832.GA25984@quack.suse.cz>
 <20130213045759.GE2614@thunk.org>
 <87ehgku11r.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48113 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934109Ab3BMPIv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 10:08:51 -0500
Content-Disposition: inline
In-Reply-To: <87ehgku11r.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 13, 2013 at 11:26:40AM +0400, Dmitry Monakhov wrote:
> This helps us to spot several hidden issues (number is still unknown)
> so may be it is reasonable to split first patch in two parts:
> 1) disable uninitialized extents merging itself.
> 2) Print warning if split is required inside end_io(so only warning will
> be printed, but w/o data corruption)
> 3) Get rid of extent split machinery from end_io (because it is not
> longer valid situation)
> 
> (1) and (2) should be accepted ASAP and will help us to spot and fix
> other hidden issues. And we fix all related issues it will be safe
> to apply (3)'rd one.
> I'll send patches soon.

That seems like reasonable approach; I'm not sure we'll be able to get
to (3) by the time the merge window opens, but getting (1) and (2) in
would be great; if the warning is getting triggered a lot, we might
need to only enable it under CONFIG_EXT4_DEBUG, though.

If you could you base the patches off of tip of the dev branch (which
I just updated), I'd really appreciate it.  The last commit on the
newly updated dev branch is:

7eedefe ext4: support simple conversion of extent-mapped inodes to use i_blocks

In this updated dev branch, I've moved the extent status patches to
the unstable portion of the tree due to the bigalloc regressions.  So
the plan for the merge window is that currently, the extent status
patches and the uninitialized extent merging patches are currently on
the unstable portion of the tree here:

	http://repo.or.cz/w/ext4-patch-queue.git
	git://repo.or.cz/ext4-patch-queue.git

That way we can do intensive testing on the rest of the ext4 tree.
Once the rest of the patches have been validated, I'll push the master
branch on the ext4 git tree to point at the fully validated set of
patches, and then we can try to push the rest of the patches that have
been moved past the stable-boundary in the ext4 patch queue back onto
the dev branch, and see if we can shake out the rest of the problems
before the merge window opens.

I will be leaving for Hawaii tomorrow, so the amount of time I will
have to do a development/debugging work will be limited.  On the other
hand, it's easy to let regression tests run in the hotel room while
I'm visiting volcano craters, so please do send me updated patches,
and I'll review and test them as I have time.  The joys of having the
pre-merge window crunch coincide with your vacation...  :-)

    	    	       	     	    	     - Ted
