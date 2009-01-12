From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove stale block allocator code
Date: Sun, 11 Jan 2009 23:10:19 -0500
Message-ID: <20090112041019.GA17381@mit.edu>
References: <1231619326-29963-1-git-send-email-snitzer@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59504 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbZALEKV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Jan 2009 23:10:21 -0500
Content-Disposition: inline
In-Reply-To: <1231619326-29963-1-git-send-email-snitzer@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 10, 2009 at 03:28:46PM -0500, Mike Snitzer wrote:
> Remove some leftovers from when the old block allocator was removed
> (c2ea3fde).  ext4_sb_info is now a bit lighter.  Also remove a dangling
> read_block_bitmap() prototype.

Thanks for the patch.  I've added it to the ext4 patch queue.

       	       	       	    	     	- Ted
