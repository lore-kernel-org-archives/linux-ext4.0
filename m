From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch, resend] ext4: fix race between unwritten extent
 conversion and truncate
Date: Mon, 20 Feb 2012 23:00:07 -0500
Message-ID: <20120221040007.GE25249@thunk.org>
References: <x49hayqy16f.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53106 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab2BUEAL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 23:00:11 -0500
Content-Disposition: inline
In-Reply-To: <x49hayqy16f.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 16, 2012 at 03:26:48PM -0500, Jeff Moyer wrote:
> Hi,
> 
> The following comment in ext4_end_io_dio caught my attention:
> 
> 	/* XXX: probably should move into the real I/O completion handler */
>         inode_dio_done(inode);
> 
> The truncate code takes i_mutex, then calls inode_dio_wait.  Because the
> ext4 code path above will end up dropping the mutex before it is
> reacquired by the worker thread that does the extent conversion, it
> seems to me that the truncate can happen out of order.  Jan Kara
> mentioned that this might result in error messages in the system logs,
> but that should be the extent of the "damage."
> 
> The fix is pretty straight-forward: don't call inode_dio_done until the
> extent conversion is complete.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
