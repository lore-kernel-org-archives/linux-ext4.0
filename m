From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: Only link an inode into a directory once
Date: Wed, 15 Feb 2012 17:23:42 -0500
Message-ID: <20120215222342.GB20023@thunk.org>
References: <20120107044743.3366.16848.stgit@elm3c44.beaverton.ibm.com>
 <20120215192537.GI11382@thunk.org>
 <20120215204015.GB15164@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52394 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab2BOWXr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Feb 2012 17:23:47 -0500
Content-Disposition: inline
In-Reply-To: <20120215204015.GB15164@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 15, 2012 at 12:40:15PM -0800, Darrick J. Wong wrote:
> 
> Yes.  I took a look at the block iteration code again, and I'm
> wondering, do we need one of these:
> 
> if (ret & BLOCK_ABORT)
> 	break;
> 
> ...around lib/ext2fs/block.c, line 450?

Good spotting; it turns out there was another problem later on, where the

	if (ret & BLOCK_ABORT)
		break;

does the wrong thing, since we need to break out of both the for loop
*and* the while loop.

I'll send a patch which I believe will fix BLOCK_ABORT in the block
iterator for the extent case.

						- Ted
