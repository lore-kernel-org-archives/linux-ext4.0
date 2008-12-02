From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4 ENOSPC Bug
Date: Tue, 2 Dec 2008 15:33:15 -0500
Message-ID: <20081202203315.GA20858@mit.edu>
References: <200811291418.24672.andres@anarazel.de> <200812021559.05103.andres@anarazel.de> <20081202164709.GC18162@mit.edu> <200812021847.35771.andres@anarazel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Andres Freund <andres@anarazel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37728 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751018AbYLBUdV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 15:33:21 -0500
Content-Disposition: inline
In-Reply-To: <200812021847.35771.andres@anarazel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 02, 2008 at 06:47:24PM +0100, Andres Freund wrote:
> 
> I think that I have seen the problem on metadata only changes (find
> /tmp -type f|xargs touch) as well, but sometimes metadata changes
> were possible while file creation was not.

Hmm...  really?  Was the error message ENOSPC, or something else?

The only way I can see that it might be ENOSPC would be if we got an
error in the jbd2 layer, in start_this_handle(), but that would have
resulted in a kernel printk:

	if (nblocks > journal->j_max_transaction_buffers) {
		printk(KERN_ERR "JBD: %s wants too many credits (%d > %d)\n",
		       current->comm, nblocks,
		       journal->j_max_transaction_buffers);
		ret = -ENOSPC;
		goto out;
	}


If that wasn't too long ago, you might want to search your old system
log files in /var/log for any "JBD" or "ext4" messages.  That might be
an important clue, although that seems rather unlikely to me.  Or in
the case where metadata changes were failing, perhaps they were doing
so with some other error that ENOSPC?

   	   					- Ted
