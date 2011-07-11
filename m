From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] Free allocated and pre-allocated blocks when
 check_eofblocks_fl fails
Date: Sun, 10 Jul 2011 20:10:36 -0400
Message-ID: <20110711001035.GB28763@thunk.org>
References: <20110622023351.0326042270@ruihe.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56374 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab1GKAKk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2011 20:10:40 -0400
Content-Disposition: inline
In-Reply-To: <20110622023351.0326042270@ruihe.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 21, 2011 at 07:33:50PM -0700, Jiaying Zhang wrote:
> ext4: free allocated and pre-allocated blocks when check_eofblocks_fl fails
> 
> Upon corrupted inode or disk failures, we may fail after we already allocate
> some blocks from the inode or take some blocks from the inode's preallocation
> list, but before we successfully insert the corresponding extent to the extent
> tree. In this case, we should free any allocated blocks and discard the inode's
> preallocated blocks because the entries in the inode's preallocation list may
> be in an inconsistent state.
> 
> Signed-off-by: Jiaying Zhang <jiayingz@google.com>

Thanks, added to the ext4 tree.  I reformatted the commit description
because its fill width was a bit too large.

	    	    	     	       	 - Ted
