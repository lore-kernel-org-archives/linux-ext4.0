From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: fix check for out-of-bound xattr value
Date: Wed, 10 Aug 2016 18:02:23 -0400
Message-ID: <20160810220223.GD10523@thunk.org>
References: <1470775371-19591-1-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42344 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbcHJWC0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2016 18:02:26 -0400
Content-Disposition: inline
In-Reply-To: <1470775371-19591-1-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 09, 2016 at 02:42:51PM -0600, Andreas Dilger wrote:
> Since commit v1.42.12-1-g8a546777119c, the check for in-inode
> xattrs in internal_dump_inode_extra() has been incorrectly checking
> the value size.  The value can go right to the end of the inode.
> 
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>

This looks like it's another 1.42 related patch.  I wasn't planning on
putting out another 1.42 maintenance branch, mainly because I just
don't have the time.  So what I've been doing is trying to see if
fixes can apply to the maint branch --- and if they can, I'll apply
them there and then merge them into the next / master branches.

But for patches where the code in question has changed radically
between 1.42 and 1.43, I haven't been bothering to try to apply them
into the maint branch, mainly because that just causes patch conflicts
lately.

I'm planning on retiring the 1.42 maint branch, and merging the maint
branch to 1.43, probably after 1.43.2, and then we can start using
putting more development related changes to the master/next branches.

Any objections to that plan?  Is there anyone who needs a 1.42 based
maintenance branch for some reason?

	    				- Ted
